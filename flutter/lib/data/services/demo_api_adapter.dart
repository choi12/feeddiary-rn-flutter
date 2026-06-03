// 데모 API 어댑터 — USE_MOCK 시 auth·diary·community 엔드포인트를 인메모리로 응답(네트워크 경계 격리). RN App.tsx setupMockAdapter(axios-mock-adapter) 대응.
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:feeddiary/config/api_config.dart';
import 'package:feeddiary/config/app_info.dart';
import 'package:feeddiary/config/flowerpot_config.dart';

/// USE_MOCK 데모 모드에서 Dio 의 [HttpClientAdapter]를 대체해 엔드포인트를 mock 한다.
/// 응답을 백엔드 원본과 같은 snake_case 로 내려보내 인터셉터·DTO 매핑이 실제로 실행되게 한다(가이드 원칙2).
///
/// auth: 로그인은 항상 신규 사용자(401)로 처리해 CreateProfile 온보딩을 노출하고, 회원가입/자동로그인은
/// 사용자+토큰을 발급한다. diary: 인메모리 state 로 목록(본인)/캘린더/상세/CRUD/좋아요/공개토글을 실제로 변형한다(RN mock state).
/// community: 공개 일기 피드(정렬·페이지네이션)·댓글 CRUD·신고(작성자 차단)를 인메모리 맵/셋으로 시연한다.
/// 전 도메인 종합 + 실패 시나리오 주입은 후속 polish PR(가이드 C-1).
class DemoApiAdapter implements HttpClientAdapter {
  /// 닉네임 중복으로 처리할 예약어(중복 상태 시연용).
  static const Set<String> _reservedNicknames = {'새싹이', 'admin', 'test'};

  static const String _demoToken = 'demo_access_token';

  /// 인메모리 일기 저장소(community superset 형태로 보관 — 목록은 잉여 키 무시, 상세는 전체 반환).
  late final List<Map<String, dynamic>> _diaries = _seedDiaries();

  /// 인메모리 댓글 저장소(diaryIdx → 댓글 목록). RN mock commentsByDiary 대응(시작 시 비어 있음 → fallback 노출).
  late final Map<int, List<Map<String, dynamic>>> _commentsByDiary = _seedComments();

  /// 특정 일기 댓글이 없을 때 보여줄 fallback 6건. RN MOCK_COMMENTS — 모든 일기가 이 댓글로 fallback 한다.
  late final List<Map<String, dynamic>> _fallbackComments = _seedFallbackComments();

  /// 인메모리 편지 저장소(나에게 쓰는 편지). 작성/삭제로 변형된다(격리 — 게임 루프 무관). RN mock letters stateful.
  late final List<Map<String, dynamic>> _letters = _seedLetters();

  /// 신고로 차단된 작성자 user_idx 집합(community 목록에서 제외).
  final Set<int> _blockedUsers = {};

  /// 새 일기에 부여할 다음 idx. RN nextDiaryIdx(1100)+1 — 1100 이상이라 공개 시 community 피드에 노출된다.
  int _nextIdx = 1101;

  /// 새 댓글에 부여할 다음 idx(fallback 댓글 idx 1~6 과 무충돌).
  int _nextCommentIdx = 5004;

  /// 새 편지에 부여할 다음 idx(시드 idx 1~3 다음부터).
  int _nextLetterIdx = 4;

  /// 인메모리 화분 상태(레벨·경험치·물주기/사랑 충전). 물주기/사랑·미션 완료로 변형된다. RN MOCK_FLOWERPOT stateful.
  late final Map<String, dynamic> _flowerpot = {
    'level': 1,
    'exp': 20,
    'max_exp': 100,
    'watering_count': 5,
    'love_count': 3,
  };

  /// 인메모리 미션 상태(진행중/완료). 일기/댓글/좋아요/공개 액션으로 진행되고 완료 시 이동한다. RN mock missions stateful.
  late final Map<String, List<Map<String, dynamic>>> _missions = _seedMissions();

  /// 인메모리 데모 사용자(회원가입/프로필 수정으로 갱신 — 세션 동안 유지). RN mock user stateful.
  late final Map<String, dynamic> _user = _demoUser();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final auth = _handleAuth(options);
    if (auth != null) {
      return auth;
    }
    final segments = options.uri.pathSegments;
    if (segments.isNotEmpty && segments.first == 'diary') {
      return _handleDiary(options, segments);
    }
    if (segments.isNotEmpty && segments.first == 'comment') {
      return _handleComment(options, segments);
    }
    if (segments.isNotEmpty && segments.first == 'letter') {
      return _handleLetter(options, segments);
    }
    if (segments.isNotEmpty && segments.first == 'flowerpot') {
      return _handleFlowerpot(options, segments);
    }
    if (segments.isNotEmpty && segments.first == 'mission') {
      return _handleMission(options, segments);
    }
    if (segments.isNotEmpty && segments.first == 'user') {
      return _handleUser(options, segments);
    }
    if (segments.isNotEmpty && segments.first == 'etc') {
      return _handleEtc(options, segments);
    }
    return _json(404, {'status': 'failed', 'message': '알 수 없는 요청: ${options.path}'});
  }

  // --- etc (앱 버전) ---

  ResponseBody _handleEtc(RequestOptions options, List<String> segments) {
    if (segments.length == 2 && segments[1] == 'app-version' && options.method.toUpperCase() == 'GET') {
      // 현재 버전과 동일 값 반환 → AppVersion 화면이 "최신 버전" 정상 분기를 보여 준다.
      return _json(200, {
        'status': 'success',
        'resData': {'app_version_android': AppInfo.version, 'app_version_ios': AppInfo.version},
      });
    }
    return _json(404, {'status': 'failed', 'message': '알 수 없는 요청: ${options.path}'});
  }

  // --- auth (PR③) ---

  ResponseBody? _handleAuth(RequestOptions options) {
    switch (options.path) {
      case '/auth/sign-in':
        // RN 데모와 동일 — 로그인 시 기존 사용자를 반환해 바로 메인(화분)으로 진입한다(가입 우회).
        // RN mock: onPost('/auth/sign-in') → 200 userState. (실서버는 미가입 시 401 → CreateProfile.)
        return _json(200, {
          'status': 'success',
          'resData': {..._user},
        });
      case '/auth/sign-in-auto/v2':
        return _json(200, {
          'status': 'success',
          'resData': {..._user},
        });
      case '/auth/sign-up':
        _applyUserForm(options.data);
        return _json(200, {
          'status': 'success',
          'resData': {..._user},
        });
      case '/auth/check-nickname':
        return _checkNickname(options.data);
      case '/auth/sign-out':
        return _json(200, {'status': 'success', 'resData': 'ok'});
    }
    return null;
  }

  ResponseBody _checkNickname(Object? data) {
    final nickname = (data is Map ? data['nickname'] : null)?.toString().trim() ?? '';
    if (_reservedNicknames.contains(nickname)) {
      return _json(409, {'status': 'failed', 'message': '이미 사용 중인 닉네임입니다.'});
    }
    return _json(200, {'status': 'success'});
  }

  /// 데모 사용자 시드(snake_case). 회원가입/프로필 수정으로 [_user]가 갱신된다.
  Map<String, dynamic> _demoUser() {
    return {
      'idx': 1,
      'account': 'demo@example.com',
      'user_id': 'demo_user_1',
      'nickname': '새싹이',
      'image': '',
      'background': '#FFE4B5',
      'character': 'Chick',
      'type': 'google',
      'created_time': '2026-01-01T00:00:00.000Z',
      'token': _demoToken,
      'fcm_token': '',
    };
  }

  /// 멀티파트 폼의 텍스트 필드를 [_user]에 머지한다(회원가입/프로필 수정 공용). 빈 값은 기존 값을 유지한다.
  /// 사진(image)은 [MultipartFile]이라 data.files 에 있어 여기서 무시한다 — 데모는 이미지 호스팅이 없어
  /// 클라이언트가 세션 로컬 아바타(LocalAvatar)로 표시한다(RN 데모와 동일한 mock 경계 한계).
  void _applyUserForm(Object? data) {
    if (data is! FormData) return;
    for (final field in data.fields) {
      if (field.value.isEmpty) continue;
      switch (field.key) {
        case 'nickname':
          _user['nickname'] = field.value;
        case 'character':
          _user['character'] = field.value;
        case 'background':
          _user['background'] = field.value;
        case 'account':
          _user['account'] = field.value;
        case 'type':
          _user['type'] = field.value;
      }
    }
  }

  // --- user (설정: 프로필 수정/탈퇴) ---

  ResponseBody _handleUser(RequestOptions options, List<String> segments) {
    final method = options.method.toUpperCase();
    if (segments.length == 1) {
      if (method == 'PUT') {
        _applyUserForm(options.data);
        return _json(200, {
          'status': 'success',
          'resData': {..._user},
        });
      }
      if (method == 'DELETE') {
        return _json(200, {'status': 'success', 'resData': 'ok'});
      }
    }
    return _json(404, {'status': 'failed', 'message': '알 수 없는 요청: ${options.path}'});
  }

  // --- diary (PR④) ---

  ResponseBody _handleDiary(RequestOptions options, List<String> segments) {
    final method = options.method.toUpperCase();
    if (segments.length == 1) {
      if (method == 'POST') return _createDiary(options.data);
      if (method == 'PUT') return _editDiary(options.data);
    } else if (segments.length == 2) {
      switch (segments[1]) {
        case 'list':
          return _listDiaries(options);
        case 'community-list':
          return _communityList(options);
        case 'like':
          return _likeDiary(options.data);
        case 'visibility':
          return _setVisibility(options.data);
        case 'report':
          return _reportDiary(options.data);
        default:
          final idx = int.tryParse(segments[1]);
          if (idx != null) {
            if (method == 'GET') return _getDiary(idx);
            if (method == 'DELETE') return _deleteDiary(idx);
          }
      }
    } else if (segments.length == 3 && segments[1] == 'list-by-month') {
      return _monthlyDiaries(segments[2]);
    }
    return _json(404, {'status': 'failed', 'message': '알 수 없는 요청: ${options.path}'});
  }

  ResponseBody _listDiaries(RequestOptions options) {
    final skip = int.tryParse(options.uri.queryParameters['skip'] ?? '0') ?? 0;
    // 나의 일기 탭은 본인(user_idx==1) 일기만. 타작성자 시드는 community 피드 전용.
    final own = _diaries.where((d) => d['user_idx'] == 1).toList()
      ..sort((a, b) => _createdAt(b).compareTo(_createdAt(a)));
    final page = own.skip(skip).take(ApiConfig.itemsPerPage).map(_withCommentCount).toList();
    return _json(200, {'status': 'success', 'resData': page});
  }

  ResponseBody _monthlyDiaries(String month) {
    final list = _diaries.where((d) => d['user_idx'] == 1 && _createdAt(d).startsWith(month)).toList()
      ..sort((a, b) => _createdAt(a).compareTo(_createdAt(b)));
    return _json(200, {'status': 'success', 'resData': list});
  }

  ResponseBody _getDiary(int idx) {
    final found = _diaries.where((d) => d['idx'] == idx).toList();
    if (found.isEmpty) {
      return _json(404, {'status': 'failed', 'message': '일기를 찾을 수 없습니다.'});
    }
    return _json(200, {'status': 'success', 'resData': _withCommentCount(found.first)});
  }

  ResponseBody _createDiary(Object? data) {
    final fields = _formFields(data);
    final idx = _nextIdx++;
    _diaries.insert(
      0,
      _diary(
        idx: idx,
        sticker: fields['sticker'] ?? 'CloudSun',
        text: fields['text'] ?? '',
        created: DateTime.tryParse(fields['date'] ?? '') ?? DateTime.now(),
      ),
    );
    _progressMission('diary');
    return _json(200, {
      'status': 'success',
      'resData': {'diaryIdx': idx},
    });
  }

  ResponseBody _editDiary(Object? data) {
    final fields = _formFields(data);
    final idx = int.tryParse(fields['diary_idx'] ?? '');
    final i = idx == null ? -1 : _diaries.indexWhere((d) => d['idx'] == idx);
    if (i == -1) {
      return _json(404, {'status': 'failed', 'message': '일기를 찾을 수 없습니다.'});
    }
    _diaries[i] = {
      ..._diaries[i],
      'sticker': fields['sticker'] ?? _diaries[i]['sticker'],
      'text': fields['text'] ?? _diaries[i]['text'],
      'created_time': fields['date'] ?? _diaries[i]['created_time'],
      'updated_time': DateTime.now().toIso8601String(),
    };
    return _json(200, {
      'status': 'success',
      'resData': {'diaryIdx': idx},
    });
  }

  ResponseBody _deleteDiary(int idx) {
    _diaries.removeWhere((d) => d['idx'] == idx);
    return _json(200, {'status': 'success', 'resData': 'ok'});
  }

  ResponseBody _likeDiary(Object? data) {
    final i = _indexFromBody(data);
    if (i == -1) {
      return _json(404, {'status': 'failed', 'message': '일기를 찾을 수 없습니다.'});
    }
    final wasLiked = _diaries[i]['isLike'] as bool;
    final likeCount = _diaries[i]['like_count'] as int;
    final nextCount = wasLiked ? likeCount - 1 : likeCount + 1;
    _diaries[i] = {..._diaries[i], 'isLike': !wasLiked, 'like_count': nextCount};
    if (!wasLiked) {
      _progressMission('like');
    }
    return _json(200, {
      'status': 'success',
      'resData': {'like_count': nextCount, 'isLike': !wasLiked},
    });
  }

  ResponseBody _setVisibility(Object? data) {
    final i = _indexFromBody(data);
    if (i == -1) {
      return _json(404, {'status': 'failed', 'message': '일기를 찾을 수 없습니다.'});
    }
    final next = (_diaries[i]['is_visible'] as int) == 1 ? 0 : 1;
    _diaries[i] = {..._diaries[i], 'is_visible': next};
    if (next == 1) {
      _progressMission('visible');
    }
    return _json(200, {
      'status': 'success',
      'resData': {'is_visible': next},
    });
  }

  // --- community / comment (PR⑤) ---

  ResponseBody _communityList(RequestOptions options) {
    final skip = int.tryParse(options.uri.queryParameters['skip'] ?? '0') ?? 0;
    final sortType = options.uri.queryParameters['sort_type'] ?? 'latest';
    // RN community-list: 타작성자 일기는 공개 여부 무관 전부, 본인 일기는 공개+세션생성(idx>=1100)만. 신고 차단 작성자는 제외.
    final visible = _diaries.where((d) {
      final userIdx = d['user_idx'] as int;
      if (_blockedUsers.contains(userIdx)) return false;
      if (userIdx != 1) return true;
      return d['is_visible'] == 1 && (d['idx'] as int) >= 1100;
    }).toList();
    if (sortType == 'popular') {
      visible.sort((a, b) => (b['like_count'] as int).compareTo(a['like_count'] as int));
    } else {
      visible.sort((a, b) => _createdAt(b).compareTo(_createdAt(a)));
    }
    final page = visible.skip(skip).take(ApiConfig.itemsPerPage).map(_withCommentCount).toList();
    return _json(200, {'status': 'success', 'resData': page});
  }

  ResponseBody _reportDiary(Object? data) {
    final diaryIdx = data is Map ? (data['diary_idx'] as num?)?.toInt() : null;
    final matches = diaryIdx == null
        ? const <Map<String, dynamic>>[]
        : _diaries.where((d) => d['idx'] == diaryIdx).toList();
    if (matches.isNotEmpty) {
      _blockedUsers.add(matches.first['user_idx'] as int);
    }
    return _json(200, {'status': 'success', 'resData': 'ok'});
  }

  ResponseBody _handleComment(RequestOptions options, List<String> segments) {
    final method = options.method.toUpperCase();
    if (segments.length == 1 && method == 'POST') {
      return _createComment(options.data);
    }
    if (segments.length == 2) {
      final idx = int.tryParse(segments[1]);
      if (idx != null && method == 'DELETE') {
        return _deleteComment(idx);
      }
    }
    if (segments.length == 3 && segments[1] == 'list') {
      final idx = int.tryParse(segments[2]);
      if (idx != null) {
        return _getComments(idx);
      }
    }
    return _json(404, {'status': 'failed', 'message': '알 수 없는 요청: ${options.path}'});
  }

  /// 특정 일기의 댓글 목록 — 추가/삭제로 생긴 목록이 있으면 그것, 없으면 fallback 6건(RN getComments).
  List<Map<String, dynamic>> _commentsFor(int diaryIdx) => _commentsByDiary[diaryIdx] ?? _fallbackComments;

  /// 일기에 동적 댓글 수를 주입(RN withCommentCount) — 시드의 정적 commentCount 를 getComments 길이로 덮어 카드·상세·댓글화면이 일치한다.
  Map<String, dynamic> _withCommentCount(Map<String, dynamic> diary) => {
    ...diary,
    'commentCount': _commentsFor(diary['idx'] as int).length,
  };

  ResponseBody _getComments(int diaryIdx) {
    // RN getComments: 특정 일기 댓글이 있으면 그것, 없으면 fallback 6건. 댓글 화면을 항상 채워 보여 준다.
    return _json(200, {'status': 'success', 'resData': _commentsFor(diaryIdx)});
  }

  ResponseBody _createComment(Object? data) {
    final diaryIdx = data is Map ? (data['diary_idx'] as num?)?.toInt() : null;
    final text = data is Map ? (data['text']?.toString() ?? '') : '';
    if (diaryIdx == null) {
      return _json(404, {'status': 'failed', 'message': '일기를 찾을 수 없습니다.'});
    }
    final idx = _nextCommentIdx++;
    // 새 댓글은 현재 로그인 사용자로 귀속한다(실서버 동작). fallback 6건을 보존한 뒤 새 댓글을 덧붙인다(RN [...getComments, new]).
    _commentsByDiary[diaryIdx] = [
      ..._commentsFor(diaryIdx),
      _comment(
        idx: idx,
        text: text,
        created: DateTime.now(),
        nickname: _user['nickname'] as String,
        character: _user['character'] as String,
      ),
    ];
    _progressMission('comment');
    return _json(200, {'status': 'success', 'resData': '$idx'});
  }

  ResponseBody _deleteComment(int commentIdx) {
    // 댓글 수는 getComments 길이로 동적 계산하므로 별도 카운트 보정 불필요(목록에서 제거만).
    for (final entry in _commentsByDiary.entries) {
      final before = entry.value.length;
      entry.value.removeWhere((c) => c['idx'] == commentIdx);
      if (entry.value.length != before) {
        break;
      }
    }
    return _json(200, {'status': 'success', 'resData': 'ok'});
  }

  // --- letter (PR⑦) ---

  ResponseBody _handleLetter(RequestOptions options, List<String> segments) {
    final method = options.method.toUpperCase();
    if (segments.length == 1 && method == 'POST') {
      return _createLetter(options.data);
    }
    if (segments.length == 2) {
      if (segments[1] == 'list' && method == 'GET') {
        return _getLetters(options);
      }
      final idx = int.tryParse(segments[1]);
      if (idx != null && method == 'DELETE') {
        return _deleteLetter(idx);
      }
    }
    return _json(404, {'status': 'failed', 'message': '알 수 없는 요청: ${options.path}'});
  }

  ResponseBody _getLetters(RequestOptions options) {
    final skip = int.tryParse(options.uri.queryParameters['skip'] ?? '0') ?? 0;
    final sorted = [..._letters]..sort((a, b) => (b['created_time'] as String).compareTo(a['created_time'] as String));
    final page = sorted.skip(skip).take(ApiConfig.itemsPerPage).toList();
    return _json(200, {'status': 'success', 'resData': page});
  }

  ResponseBody _createLetter(Object? data) {
    final text = data is Map ? (data['text']?.toString() ?? '') : '';
    final letter = _letterEntry(idx: _nextLetterIdx++, text: text, created: DateTime.now());
    _letters.insert(0, letter);
    return _json(200, {'status': 'success', 'resData': letter});
  }

  ResponseBody _deleteLetter(int letterIdx) {
    _letters.removeWhere((letter) => letter['idx'] == letterIdx);
    return _json(200, {'status': 'success', 'resData': 'ok'});
  }

  // --- flowerpot / mission (PR⑥) ---

  ResponseBody _handleFlowerpot(RequestOptions options, List<String> segments) {
    final method = options.method.toUpperCase();
    if (segments.length == 1 && method == 'GET') {
      return _getFlowerpot();
    }
    if (segments.length == 2 && method == 'POST') {
      if (segments[1] == 'watering') {
        return _plantAction('watering_count');
      }
      if (segments[1] == 'love') {
        return _plantAction('love_count');
      }
    }
    return _json(404, {'status': 'failed', 'message': '알 수 없는 요청: ${options.path}'});
  }

  ResponseBody _handleMission(RequestOptions options, List<String> segments) {
    final method = options.method.toUpperCase();
    if (segments.length == 1 && method == 'POST') {
      return _completeMission(options.data);
    }
    if (segments.length == 2 && segments[1] == 'list' && method == 'GET') {
      return _getMissions();
    }
    return _json(404, {'status': 'failed', 'message': '알 수 없는 요청: ${options.path}'});
  }

  ResponseBody _getFlowerpot() {
    return _json(200, {'status': 'success', 'resData': _flowerpotJson()});
  }

  /// 화분 응답. showBadge 는 받을 수 있는(달성한) 진행중 미션 존재 여부로 동적 계산한다(미션→화분 단서 시연).
  Map<String, dynamic> _flowerpotJson() {
    final hasClaimable = _missions['inProgress']!.any((m) => (m['count'] as int) >= (m['max_count'] as int));
    return {..._flowerpot, 'showBadge': hasClaimable};
  }

  /// 물주기/사랑주기 공통 — 충전 1 소비 + 경험치 증가 + 레벨업(최대 레벨 상한). RN watering/love(서버 계산).
  /// 경험치 증가량은 RN 과 동일하게 물주기 +10 / 사랑 +5. 레벨업 1회당 max_exp 를 100 늘린다.
  ResponseBody _plantAction(String chargeKey) {
    final charges = _flowerpot[chargeKey] as int;
    var level = _flowerpot['level'] as int;
    // 충전이 없거나 이미 최대 레벨이면 변화 없이 성공 응답(클라 canWater 가 막지만 안전망).
    if (charges < 1 || level >= FlowerpotConfig.maxLevel) {
      return _json(200, {'status': 'success', 'resData': 'ok'});
    }
    _flowerpot[chargeKey] = charges - 1;
    final expGain = chargeKey == 'watering_count' ? 10 : 5;
    var maxExp = _flowerpot['max_exp'] as int;
    var exp = (_flowerpot['exp'] as int) + expGain;
    while (exp >= maxExp && level < FlowerpotConfig.maxLevel) {
      exp -= maxExp;
      level += 1;
      maxExp += 100;
    }
    if (level >= FlowerpotConfig.maxLevel) {
      exp = maxExp; // 최대 레벨이면 경험치를 가득 채워 더 자라지 않음을 표현.
    }
    _flowerpot['level'] = level;
    _flowerpot['exp'] = exp;
    _flowerpot['max_exp'] = maxExp;
    return _json(200, {'status': 'success', 'resData': 'ok'});
  }

  ResponseBody _getMissions() {
    return _json(200, {
      'status': 'success',
      'resData': {'completed': _missions['completed'], 'inProgress': _missions['inProgress']},
    });
  }

  /// 미션 완료 — 진행중에서 빼 완료로 옮기고 보상 충전을 지급한 뒤, 갱신된 묶음+보상을 반환. RN completeMission.
  ResponseBody _completeMission(Object? data) {
    final missionIdx = data is Map ? (data['mission_idx'] as num?)?.toInt() : null;
    final inProgress = _missions['inProgress']!;
    final i = missionIdx == null ? -1 : inProgress.indexWhere((m) => m['idx'] == missionIdx);
    if (i == -1) {
      return _json(404, {'status': 'failed', 'message': '미션을 찾을 수 없습니다.'});
    }
    final mission = inProgress.removeAt(i);
    mission['count'] = mission['max_count'];
    mission['is_completed'] = 1;
    _missions['completed']!.insert(0, mission);
    final reward = _rewardFor(mission['type'] as String);
    final chargeKey = reward['item'] == 'watering' ? 'watering_count' : 'love_count';
    _flowerpot[chargeKey] = (_flowerpot[chargeKey] as int) + (reward['count'] as int);
    return _json(200, {
      'status': 'success',
      'resData': {
        'missions': {'completed': _missions['completed'], 'inProgress': _missions['inProgress']},
        'reward': reward,
      },
    });
  }

  /// 미션 보상 규칙(미션 종류별 결정적). RN 서버 보상 계산 대응.
  Map<String, dynamic> _rewardFor(String type) {
    switch (type) {
      case 'diary':
        return {'count': 2, 'item': 'watering'};
      case 'visible':
        return {'count': 1, 'item': 'watering'};
      case 'comment':
        return {'count': 2, 'item': 'love'};
      case 'like':
      default:
        return {'count': 1, 'item': 'love'};
    }
  }

  /// 게임 루프 — 해당 종류의 진행중 미션 진행도를 1 올린다(목표 초과 금지). 일기/댓글/좋아요/공개에서 호출. RN MISSION_GROUP.
  void _progressMission(String type) {
    for (final mission in _missions['inProgress']!) {
      if (mission['type'] == type) {
        final next = (mission['count'] as int) + 1;
        final max = mission['max_count'] as int;
        mission['count'] = next > max ? max : next;
        break;
      }
    }
  }

  /// 시드 미션 — RN MOCK_MISSIONS. diary 5/5 완료 + comment/visible/like 진행중.
  Map<String, List<Map<String, dynamic>>> _seedMissions() {
    return {
      'completed': [_mission(idx: 1, type: 'diary', count: 5, maxCount: 5)],
      'inProgress': [
        _mission(idx: 2, type: 'comment', count: 1, maxCount: 3),
        _mission(idx: 3, type: 'visible', count: 0, maxCount: 1),
        _mission(idx: 4, type: 'like', count: 2, maxCount: 5),
      ],
    };
  }

  /// 미션 한 건(snake_case). RN mkMission 처럼 count>=max 면 is_completed 1.
  Map<String, dynamic> _mission({required int idx, required String type, required int count, required int maxCount}) {
    return {'idx': idx, 'type': type, 'count': count, 'max_count': maxCount, 'is_completed': count >= maxCount ? 1 : 0};
  }

  // --- helpers ---

  String _createdAt(Map<String, dynamic> diary) => diary['created_time'] as String;

  int _indexFromBody(Object? data) {
    final idx = data is Map ? (data['diary_idx'] as num?)?.toInt() : null;
    return idx == null ? -1 : _diaries.indexWhere((d) => d['idx'] == idx);
  }

  Map<String, String> _formFields(Object? data) {
    if (data is! FormData) {
      return {};
    }
    return {for (final field in data.fields) field.key: field.value};
  }

  /// 데모 일기 한 건(community superset). 목록/상세 응답이 공유한다. [userIdx]가 1이 아니면 타작성자(community 피드 전용).
  Map<String, dynamic> _diary({
    required int idx,
    required String sticker,
    required String text,
    required DateTime created,
    bool visible = false,
    int likeCount = 0,
    int commentCount = 0,
    int userIdx = 1,
    String nickname = '새싹이',
    String character = 'Chick',
    String userImage = '',
    String background = '',
    String image = '',
    bool isLike = false,
  }) {
    return {
      'idx': idx,
      'user_idx': userIdx,
      'nickname': nickname,
      'sticker': sticker,
      'text': text,
      'image': image,
      'created_time': created.toIso8601String(),
      'updated_time': null,
      'is_visible': visible ? 1 : 0,
      'like_count': likeCount,
      'commentCount': commentCount,
      'user_image': userImage,
      'background': background,
      'character': character,
      'isLike': isLike,
    };
  }

  /// 데모 댓글 한 건(snake_case). 기본 작성자는 데모 사용자('새싹이')라 데모상 삭제 가능하다.
  Map<String, dynamic> _comment({
    required int idx,
    required String text,
    required DateTime created,
    String nickname = '새싹이',
    String character = 'Chick',
    String background = '',
    String userImage = '',
  }) {
    return {
      'idx': idx,
      'nickname': nickname,
      'background': background,
      'character': character,
      'text': text,
      'created_time': created.toIso8601String(),
      'user_image': userImage,
    };
  }

  // --- RN mock/data.ts 공통 시드 배열 (1:1 미러) ---

  /// 일기 스티커 풀. RN STICKERS.
  static const List<String> _stickers = ['CloudSun', 'Star', 'Snow', 'Sunny', 'Smile', 'Happiness'];

  /// 일기 본문 풀. RN TEXTS.
  static const List<String> _texts = [
    '오늘은 정말 좋은 하루였다. 햇살이 따뜻하고 바람도 시원했다.',
    '비가 종일 내렸지만 카페에서 책 읽기 좋았다.',
    '친구들과 오랜만에 만나서 즐거운 시간을 보냈다.',
    '작은 식물 하나를 들였다. 이름은 콩이.',
  ];

  /// 나의 일기 고정 날짜(최신순). RN MY_DIARY_DATES.
  static const List<String> _myDiaryDates = [
    '2026-05-25',
    '2026-05-21',
    '2026-05-16',
    '2026-05-11',
    '2026-05-05',
    '2026-04-28',
    '2026-04-22',
    '2026-04-15',
    '2026-04-08',
    '2026-03-30',
    '2026-03-22',
    '2026-03-14',
  ];

  /// community 작성자 닉네임 풀. RN COMMUNITY_NICKNAMES.
  static const List<String> _communityNicknames = [
    '하늘이',
    '구름이',
    '바람이',
    '햇살이',
    '별빛이',
    '달빛이',
    '봄날이',
    '꽃잎이',
    '나무늘보',
    '솜사탕',
  ];

  /// community 작성자 캐릭터 풀. RN COMMUNITY_CHARACTERS.
  static const List<String> _communityCharacters = [
    'Dog',
    'Rabbit',
    'Panda',
    'Fox',
    'Hamster',
    'Frog',
    'Chick',
    'Hedgehog',
  ];

  /// community 작성자 배경색 풀. RN COMMUNITY_BACKGROUNDS.
  static const List<String> _communityBackgrounds = [
    '#FFD93D',
    '#B5E4FF',
    '#D5B5FF',
    '#B5FFD5',
    '#FFB5D5',
    '#FFDEAD',
    '#C5FFC5',
  ];

  /// community 작성자 아바타 풀(10종). RN COMMUNITY_USER_IMAGES.
  static final List<String> _communityUserImages = List.generate(
    10,
    (i) => 'https://i.pravatar.cc/200?u=community-${i + 1}',
  );

  /// community 일기 본문 이미지(idx → URL). RN COMMUNITY_DIARY_IMAGES — idx 2 만 이미지.
  static const Map<int, String> _communityDiaryImages = {
    2: 'https://images.unsplash.com/photo-1493612276216-ee3925520721?w=800&q=80',
  };

  /// 시드 일기 — RN MY_DIARIES(12, idx 1001~1012) + MOCK_COMMUNITY_DIARIES(30, idx 1~30).
  List<Map<String, dynamic>> _seedDiaries() {
    final myDiaries = <Map<String, dynamic>>[
      for (var i = 0; i < _myDiaryDates.length; i++)
        _diary(
          idx: 1001 + i,
          sticker: _stickers[i % 6],
          text: _texts[i % 4],
          created: DateTime.parse(_myDiaryDates[i]),
          visible: i % 3 != 0,
          likeCount: (i * 3) % 17,
          commentCount: (i * 2) % 11,
        ),
    ];
    final communityDiaries = <Map<String, dynamic>>[
      for (var idx = 1; idx <= 30; idx++)
        _diary(
          idx: idx,
          sticker: _stickers[idx % 6],
          text: _texts[idx % 4],
          created: DateTime(2026, 5, 27 - (idx % 30)),
          visible: idx % 3 != 0,
          likeCount: (idx * 3) % 17,
          commentCount: (idx * 2) % 11,
          userIdx: 100 + (idx % 10),
          nickname: _communityNicknames[idx % 10],
          character: _communityCharacters[idx % 8],
          background: _communityBackgrounds[idx % 7],
          userImage: idx % 3 == 0 ? '' : _communityUserImages[idx % 10],
          image: _communityDiaryImages[idx] ?? '',
          isLike: idx % 4 == 0,
        ),
    ];
    return [...myDiaries, ...communityDiaries];
  }

  /// 시드 댓글 — RN commentsByDiary 처럼 시작 시 비어 있다(모든 일기가 fallback 6건으로 노출).
  Map<int, List<Map<String, dynamic>>> _seedComments() {
    return {};
  }

  /// fallback 댓글 6건. RN MOCK_COMMENTS.
  List<Map<String, dynamic>> _seedFallbackComments() {
    const texts = ['공감되네요', '오늘도 화이팅', '저도 그런 날 있어요', '응원합니다', '같이 힘내요', '글이 따뜻해요'];
    return [
      for (var i = 0; i < 6; i++)
        _comment(
          idx: i + 1,
          text: texts[i],
          created: DateTime(2026, 5, 27 - i),
          nickname: _communityNicknames[i % 10],
          character: _communityCharacters[i % 8],
          background: _communityBackgrounds[i % 7],
          userImage: i % 2 == 0 ? '' : _communityUserImages[i % 10],
        ),
    ];
  }

  /// 데모 편지 한 건(snake_case). deleted_time 은 미사용(RN 과 동일하게 무시).
  Map<String, dynamic> _letterEntry({required int idx, required String text, required DateTime created}) {
    return {'idx': idx, 'text': text, 'created_time': created.toIso8601String(), 'deleted_time': null};
  }

  /// 시드 편지 — RN MOCK_LETTERS(3). idx 1~3, 최신순(2026-05-27 → 25).
  List<Map<String, dynamic>> _seedLetters() {
    return [
      for (var i = 0; i < 3; i++)
        _letterEntry(
          idx: i + 1,
          text: '오늘 나에게 보내는 작은 편지 ${i + 1}: 잘하고 있어, 천천히 가도 괜찮아.',
          created: DateTime(2026, 5, 27 - i),
        ),
    ];
  }

  ResponseBody _json(int statusCode, Map<String, dynamic> body) {
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
