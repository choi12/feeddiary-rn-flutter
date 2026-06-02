// 데모 API 어댑터 — USE_MOCK 시 auth·diary·community 엔드포인트를 인메모리로 응답(네트워크 경계 격리). RN App.tsx setupMockAdapter(axios-mock-adapter) 대응.
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:feeddiary/config/api_config.dart';
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

  /// 인메모리 댓글 저장소(diaryIdx → 댓글 목록). RN mock commentsByDiary 대응.
  late final Map<int, List<Map<String, dynamic>>> _commentsByDiary = _seedComments();

  /// 신고로 차단된 작성자 user_idx 집합(community 목록에서 제외).
  final Set<int> _blockedUsers = {};

  /// 새 일기에 부여할 다음 idx(시드 최대 idx 다음부터).
  int _nextIdx = 1014;

  /// 새 댓글에 부여할 다음 idx(시드 최대 idx 다음부터).
  int _nextCommentIdx = 5004;

  /// 인메모리 화분 상태(레벨·경험치·물주기/사랑 충전). 물주기/사랑·미션 완료로 변형된다. RN mock flowerpot stateful.
  late final Map<String, dynamic> _flowerpot = {
    'level': 1,
    'exp': 200,
    'max_exp': FlowerpotConfig.defaultMaxExp,
    'watering_count': 2,
    'love_count': 1,
  };

  /// 인메모리 미션 상태(진행중/완료). 일기/댓글/좋아요/공개 액션으로 진행되고 완료 시 이동한다. RN mock missions stateful.
  late final Map<String, List<Map<String, dynamic>>> _missions = _seedMissions();

  /// 물/사랑 1회당 경험치 증가량(데모 게임 루프용).
  static const int _expPerAction = 250;

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
    if (segments.isNotEmpty && segments.first == 'flowerpot') {
      return _handleFlowerpot(options, segments);
    }
    if (segments.isNotEmpty && segments.first == 'mission') {
      return _handleMission(options, segments);
    }
    return _json(404, {'status': 'failed', 'message': '알 수 없는 요청: ${options.path}'});
  }

  // --- auth (PR③) ---

  ResponseBody? _handleAuth(RequestOptions options) {
    switch (options.path) {
      case '/auth/sign-in':
        return _json(401, {'status': 'failed', 'message': '신규 사용자'});
      case '/auth/sign-in-auto/v2':
        return _json(200, {'status': 'success', 'resData': _demoUser()});
      case '/auth/sign-up':
        return _json(200, {'status': 'success', 'resData': _demoUser(form: options.data)});
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

  /// 데모 사용자(snake_case). 회원가입이면 폼의 닉네임/캐릭터를 echo 한다.
  Map<String, dynamic> _demoUser({Object? form}) {
    var nickname = '새싹이';
    var character = 'Chick';
    if (form is FormData) {
      for (final field in form.fields) {
        if (field.key == 'nickname' && field.value.isNotEmpty) nickname = field.value;
        if (field.key == 'character' && field.value.isNotEmpty) character = field.value;
      }
    }
    return {
      'idx': 1,
      'account': 'demo@example.com',
      'user_id': 'mock_user_id',
      'nickname': nickname,
      'image': '',
      'background': '',
      'character': character,
      'type': 'google',
      'created_time': '2026-01-01T00:00:00.000Z',
      'token': _demoToken,
      'fcm_token': '',
    };
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
    final page = own.skip(skip).take(ApiConfig.itemsPerPage).toList();
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
    return _json(200, {'status': 'success', 'resData': found.first});
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
    // 공개(is_visible) + 신고로 차단되지 않은 작성자의 일기만 노출.
    final visible = _diaries.where((d) => d['is_visible'] == 1 && !_blockedUsers.contains(d['user_idx'])).toList();
    if (sortType == 'popular') {
      visible.sort((a, b) => (b['like_count'] as int).compareTo(a['like_count'] as int));
    } else {
      visible.sort((a, b) => _createdAt(b).compareTo(_createdAt(a)));
    }
    final page = visible.skip(skip).take(ApiConfig.itemsPerPage).toList();
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

  ResponseBody _getComments(int diaryIdx) {
    return _json(200, {'status': 'success', 'resData': _commentsByDiary[diaryIdx] ?? <Map<String, dynamic>>[]});
  }

  ResponseBody _createComment(Object? data) {
    final diaryIdx = data is Map ? (data['diary_idx'] as num?)?.toInt() : null;
    final text = data is Map ? (data['text']?.toString() ?? '') : '';
    if (diaryIdx == null) {
      return _json(404, {'status': 'failed', 'message': '일기를 찾을 수 없습니다.'});
    }
    final idx = _nextCommentIdx++;
    (_commentsByDiary[diaryIdx] ??= []).add(_comment(idx: idx, text: text, created: DateTime.now()));
    _bumpCommentCount(diaryIdx, 1);
    _progressMission('comment');
    return _json(200, {'status': 'success', 'resData': '$idx'});
  }

  ResponseBody _deleteComment(int commentIdx) {
    for (final entry in _commentsByDiary.entries) {
      final before = entry.value.length;
      entry.value.removeWhere((c) => c['idx'] == commentIdx);
      if (entry.value.length != before) {
        _bumpCommentCount(entry.key, -1);
        break;
      }
    }
    return _json(200, {'status': 'success', 'resData': 'ok'});
  }

  void _bumpCommentCount(int diaryIdx, int delta) {
    final i = _diaries.indexWhere((d) => d['idx'] == diaryIdx);
    if (i != -1) {
      final next = ((_diaries[i]['commentCount'] as int) + delta).clamp(0, 1 << 30);
      _diaries[i] = {..._diaries[i], 'commentCount': next};
    }
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
  ResponseBody _plantAction(String chargeKey) {
    final charges = _flowerpot[chargeKey] as int;
    var level = _flowerpot['level'] as int;
    // 충전이 없거나 이미 최대 레벨이면 변화 없이 성공 응답(클라 canWater 가 막지만 안전망).
    if (charges < 1 || level >= FlowerpotConfig.maxLevel) {
      return _json(200, {'status': 'success', 'resData': 'ok'});
    }
    _flowerpot[chargeKey] = charges - 1;
    final maxExp = _flowerpot['max_exp'] as int;
    var exp = (_flowerpot['exp'] as int) + _expPerAction;
    while (exp >= maxExp && level < FlowerpotConfig.maxLevel) {
      exp -= maxExp;
      level += 1;
    }
    if (level >= FlowerpotConfig.maxLevel) {
      exp = maxExp; // 최대 레벨이면 경험치를 가득 채워 더 자라지 않음을 표현.
    }
    _flowerpot['level'] = level;
    _flowerpot['exp'] = exp;
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

  /// 시드 미션 — 4종(진행중) + 완료 비움. visible 은 이미 달성(1/1)이라 즉시 완료 시연 가능.
  Map<String, List<Map<String, dynamic>>> _seedMissions() {
    return {
      'inProgress': [
        _mission(idx: 1, type: 'diary', count: 1, maxCount: 3),
        _mission(idx: 2, type: 'comment', count: 0, maxCount: 2),
        _mission(idx: 3, type: 'visible', count: 1, maxCount: 1),
        _mission(idx: 4, type: 'like', count: 0, maxCount: 3),
      ],
      'completed': <Map<String, dynamic>>[],
    };
  }

  /// 미션 한 건(snake_case, 진행중 기본 is_completed 0).
  Map<String, dynamic> _mission({required int idx, required String type, required int count, required int maxCount}) {
    return {'idx': idx, 'type': type, 'count': count, 'max_count': maxCount, 'is_completed': 0};
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
  }) {
    return {
      'idx': idx,
      'user_idx': userIdx,
      'nickname': nickname,
      'sticker': sticker,
      'text': text,
      'image': '',
      'created_time': created.toIso8601String(),
      'updated_time': null,
      'is_visible': visible ? 1 : 0,
      'like_count': likeCount,
      'commentCount': commentCount,
      'user_image': '',
      'background': '',
      'character': character,
      'isLike': false,
    };
  }

  /// 데모 댓글 한 건(snake_case). 기본 작성자는 데모 사용자('새싹이')라 데모상 삭제 가능하다.
  Map<String, dynamic> _comment({
    required int idx,
    required String text,
    required DateTime created,
    String nickname = '새싹이',
    String character = 'Chick',
  }) {
    return {
      'idx': idx,
      'nickname': nickname,
      'background': '',
      'character': character,
      'text': text,
      'created_time': created.toIso8601String(),
      'user_image': '',
    };
  }

  /// 시드 일기(현재 달 위주 + 이전 달 분포). now 상대라 캘린더가 항상 마킹을 보여준다. idx 1001~1013.
  List<Map<String, dynamic>> _seedDiaries() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime daysAgo(int d) => today.subtract(Duration(days: d));
    return [
      _diary(
        idx: 1013,
        sticker: 'Coffee',
        text: '오늘은 따뜻한 커피 한 잔으로 하루를 시작했다.',
        created: daysAgo(0),
        likeCount: 2,
        commentCount: 1,
      ),
      _diary(
        idx: 1012,
        sticker: 'Sunny',
        text: '날씨가 좋아 잠깐 산책을 다녀왔다. 기분이 한결 가벼워졌다.',
        created: daysAgo(1),
        visible: true,
        likeCount: 5,
      ),
      _diary(idx: 1011, sticker: 'Smile', text: '친구와 오랜만에 통화했다. 목소리만 들어도 좋다.', created: daysAgo(3)),
      _diary(
        idx: 1010,
        sticker: 'Flower',
        text: '베란다 화분에 새 잎이 났다. 작은 변화가 반갑다.',
        created: daysAgo(5),
        visible: true,
        likeCount: 3,
      ),
      _diary(idx: 1009, sticker: 'Thinking', text: '요즘 무엇을 배우면 좋을지 즐겁게 고민 중이다.', created: daysAgo(8)),
      _diary(idx: 1008, sticker: 'Rain', text: '비 오는 날의 빗소리를 가만히 들었다.', created: daysAgo(11)),
      _diary(idx: 1007, sticker: 'Sleep', text: '오랜만에 푹 잤다. 개운한 아침이다.', created: daysAgo(14)),
      _diary(idx: 1006, sticker: 'Star', text: '밤하늘에 별이 유난히 많았다.', created: daysAgo(20)),
      _diary(idx: 1005, sticker: 'Coffee', text: '동네에 새 카페를 발견했다. 분위기가 좋다.', created: daysAgo(33), likeCount: 1),
      _diary(idx: 1004, sticker: 'Moon', text: '늦은 밤 일기를 쓰는 습관이 생겼다.', created: daysAgo(38)),
      _diary(idx: 1003, sticker: 'Rainbow', text: '소나기 뒤에 무지개가 떴다.', created: daysAgo(45), visible: true, likeCount: 4),
      _diary(idx: 1002, sticker: 'Snow', text: '첫눈처럼 설레는 일이 있었다.', created: daysAgo(60)),
      _diary(
        idx: 1001,
        sticker: 'Happiness',
        text: '새싹일기를 시작한 날. 꾸준히 써보자.',
        created: daysAgo(70),
        visible: true,
        likeCount: 6,
      ),
      // --- community 피드 전용: 타작성자 공개 일기(좋아요·신고·인기정렬 시연용, My-Diary 에는 미노출) ---
      _diary(
        idx: 2001,
        userIdx: 2,
        nickname: '햇살이',
        character: 'Bear',
        sticker: 'Sunny',
        text: '아침 산책길에 햇살이 좋아 한참을 걸었어요. 다들 좋은 하루 보내세요!',
        created: daysAgo(0),
        visible: true,
        likeCount: 12,
        commentCount: 2,
      ),
      _diary(
        idx: 2002,
        userIdx: 3,
        nickname: '구름이',
        character: 'Cat',
        sticker: 'Coffee',
        text: '카페에서 책 한 권을 다 읽었다. 작은 성취감.',
        created: daysAgo(1),
        visible: true,
        likeCount: 7,
      ),
      _diary(
        idx: 2003,
        userIdx: 4,
        nickname: '바다',
        character: 'Whale',
        sticker: 'Rain',
        text: '비 오는 날엔 음악이 더 잘 들린다. 플레이리스트를 새로 만들었다.',
        created: daysAgo(2),
        visible: true,
        likeCount: 3,
      ),
      _diary(
        idx: 2004,
        userIdx: 2,
        nickname: '햇살이',
        character: 'Bear',
        sticker: 'Flower',
        text: '베란다 꽃이 드디어 피었어요. 기다린 보람이 있네요.',
        created: daysAgo(4),
        visible: true,
        likeCount: 9,
      ),
    ];
  }

  /// 시드 댓글(일부 일기에 표시용). 작성자 본인 댓글은 인증 배지 시연용이다.
  Map<int, List<Map<String, dynamic>>> _seedComments() {
    final now = DateTime.now();
    DateTime hoursAgo(int h) => now.subtract(Duration(hours: h));
    return {
      2001: [
        _comment(idx: 5001, nickname: '구름이', character: 'Cat', text: '사진 없이도 글이 참 따뜻하네요.', created: hoursAgo(5)),
        _comment(idx: 5002, nickname: '햇살이', character: 'Bear', text: '감사해요! 자주 들러주세요.', created: hoursAgo(3)),
      ],
      1013: [_comment(idx: 5003, nickname: '구름이', character: 'Cat', text: '커피 한 잔의 여유 좋죠.', created: hoursAgo(8))],
    };
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
