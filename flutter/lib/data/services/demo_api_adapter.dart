// 데모 API 어댑터 — USE_MOCK 시 auth 엔드포인트를 인메모리로 응답(네트워크 경계 격리). RN App.tsx setupMockAdapter(axios-mock-adapter) 대응.
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// USE_MOCK 데모 모드에서 Dio 의 [HttpClientAdapter]를 대체해 auth 엔드포인트를 mock 한다.
/// 응답을 백엔드 원본과 같은 snake_case 로 내려보내 인터셉터·DTO 매핑이 실제로 실행되게 한다(가이드 원칙2).
///
/// 데모 시나리오: 로그인은 항상 신규 사용자(401)로 처리해 CreateProfile 온보딩을 노출하고,
/// 회원가입/자동로그인은 사용자+토큰을 발급해 영속 로그인을 보여준다.
/// 전 도메인 + 실패 시나리오 주입 + mutable state 는 후속 polish PR(가이드 C-1).
class DemoApiAdapter implements HttpClientAdapter {
  /// 닉네임 중복으로 처리할 예약어(중복 상태 시연용).
  static const Set<String> _reservedNicknames = {'새싹이', 'admin', 'test'};

  static const String _demoToken = 'demo_access_token';

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return switch (options.path) {
      '/auth/sign-in' => _json(401, {'status': 'failed', 'message': '신규 사용자'}),
      '/auth/sign-in-auto/v2' => _json(200, {'status': 'success', 'resData': _demoUser()}),
      '/auth/sign-up' => _json(200, {'status': 'success', 'resData': _demoUser(form: options.data)}),
      '/auth/check-nickname' => _checkNickname(options.data),
      '/auth/sign-out' => _json(200, {'status': 'success', 'resData': 'ok'}),
      _ => _json(404, {'status': 'failed', 'message': '알 수 없는 요청: ${options.path}'}),
    };
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
