// ProfileRepository — updateProfile/deleteAccount 의 envelope 언랩 + operation 라벨 (http_mock_adapter).
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:feeddiary/data/repositories/profile_repository.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;

  ProfileRepository makeRepo() {
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    return container.read(profileRepositoryProvider);
  }

  Map<String, dynamic> userJson({String nickname = '새싹이', String character = 'Chick'}) => {
    'idx': 1,
    'account': 'demo@example.com',
    'user_id': 'mock_user_id',
    'nickname': nickname,
    'image': '',
    'background': '',
    'character': character,
    'type': 'google',
    'created_time': '2026-01-01T00:00:00.000Z',
    'token': 'tok',
    'fcm_token': '',
  };

  setUp(() {
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('updateProfile 성공 시 갱신된 User 를 반환한다', () async {
    adapter.onPut(
      '/user',
      (server) => server.reply(200, {'status': 'success', 'resData': userJson(nickname: '수정됨', character: 'Bat')}),
      data: Matchers.any,
    );
    final user = await makeRepo().updateProfile(nickname: '수정됨', background: '', character: 'Bat');
    expect(user.nickname, '수정됨');
    expect(user.character, 'Bat');
  });

  test('updateProfile 서버 에러는 operation 라벨이 붙은 ApiException', () async {
    adapter.onPut('/user', (server) => server.reply(500, {'message': '서버 오류'}), data: Matchers.any);
    await expectLater(
      makeRepo().updateProfile(nickname: 'x', background: '', character: 'Bat', imageBytes: Uint8List(4)),
      throwsA(isA<ApiException>().having((e) => e.displayMessage, 'displayMessage', startsWith('[프로필 수정]'))),
    );
  });

  test('deleteAccount 성공은 예외 없음, 서버 에러는 [계정 탈퇴] 라벨', () async {
    adapter.onDelete('/user', (server) => server.reply(200, {'status': 'success', 'resData': 'ok'}));
    await makeRepo().deleteAccount(); // 예외 없음

    final dio2 = buildDio(TokenStorage(const FlutterSecureStorage()));
    final adapter2 = DioAdapter(dio: dio2);
    adapter2.onDelete('/user', (server) => server.reply(500, {'message': '서버 오류'}));
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio2)]);
    addTearDown(container.dispose);
    await expectLater(
      container.read(profileRepositoryProvider).deleteAccount(),
      throwsA(isA<ApiException>().having((e) => e.displayMessage, 'displayMessage', startsWith('[계정 탈퇴]'))),
    );
  });
}
