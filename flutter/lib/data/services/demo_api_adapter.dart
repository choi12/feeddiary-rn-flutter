// 데모 API 어댑터 — USE_MOCK 시 auth·diary 엔드포인트를 인메모리로 응답(네트워크 경계 격리). RN App.tsx setupMockAdapter(axios-mock-adapter) 대응.
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:feeddiary/config/api_config.dart';

/// USE_MOCK 데모 모드에서 Dio 의 [HttpClientAdapter]를 대체해 엔드포인트를 mock 한다.
/// 응답을 백엔드 원본과 같은 snake_case 로 내려보내 인터셉터·DTO 매핑이 실제로 실행되게 한다(가이드 원칙2).
///
/// auth: 로그인은 항상 신규 사용자(401)로 처리해 CreateProfile 온보딩을 노출하고, 회원가입/자동로그인은
/// 사용자+토큰을 발급한다. diary: 인메모리 state 로 목록/캘린더/상세/CRUD/좋아요/공개토글을 실제로 변형한다(RN mock state).
/// 전 도메인 종합 + 실패 시나리오 주입은 후속 polish PR(가이드 C-1).
class DemoApiAdapter implements HttpClientAdapter {
  /// 닉네임 중복으로 처리할 예약어(중복 상태 시연용).
  static const Set<String> _reservedNicknames = {'새싹이', 'admin', 'test'};

  static const String _demoToken = 'demo_access_token';

  /// 인메모리 일기 저장소(community superset 형태로 보관 — 목록은 잉여 키 무시, 상세는 전체 반환).
  late final List<Map<String, dynamic>> _diaries = _seedDiaries();

  /// 새 일기에 부여할 다음 idx(시드 최대 idx 다음부터).
  int _nextIdx = 1014;

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
        case 'like':
          return _likeDiary(options.data);
        case 'visibility':
          return _setVisibility(options.data);
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
    final sorted = [..._diaries]..sort((a, b) => _createdAt(b).compareTo(_createdAt(a)));
    final page = sorted.skip(skip).take(ApiConfig.itemsPerPage).toList();
    return _json(200, {'status': 'success', 'resData': page});
  }

  ResponseBody _monthlyDiaries(String month) {
    final list = _diaries.where((d) => _createdAt(d).startsWith(month)).toList()
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
    return _json(200, {
      'status': 'success',
      'resData': {'is_visible': next},
    });
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

  /// 데모 일기 한 건(community superset). 목록/상세 응답이 공유한다.
  Map<String, dynamic> _diary({
    required int idx,
    required String sticker,
    required String text,
    required DateTime created,
    bool visible = false,
    int likeCount = 0,
    int commentCount = 0,
  }) {
    return {
      'idx': idx,
      'user_idx': 1,
      'nickname': '새싹이',
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
      'character': 'Chick',
      'isLike': false,
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
