// AuthRepository — signIn/autoSignIn/signUp/checkNickname/signOut + 에러 매핑. ProviderContainer + http_mock_adapter (Tier B).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/repositories/auth_repository.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;

  AuthRepository makeRepo() {
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    return container.read(authRepositoryProvider);
  }

  Map<String, dynamic> userJson({String nickname = '새싹이', String token = 'tok'}) => {
    'idx': 1,
    'account': 'demo@example.com',
    'user_id': 'mock_user_id',
    'nickname': nickname,
    'image': '',
    'background': '',
    'character': 'Chick',
    'type': 'google',
    'created_time': '2026-01-01T00:00:00.000Z',
    'token': token,
    'fcm_token': '',
  };

  setUp(() {
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('signIn 성공 시 User 를 반환한다', () async {
    adapter.onPost(
      '/auth/sign-in',
      (server) => server.reply(200, {'status': 'success', 'resData': userJson(nickname: '로그인')}),
      data: Matchers.any,
    );
    final user = await makeRepo().signIn(userId: 'mock_user_id', fcmToken: '');
    expect(user.nickname, '로그인');
  });

  test('signIn 401 은 operation 라벨 없이 UnauthorizedException 으로 통과한다', () async {
    adapter.onPost('/auth/sign-in', (server) => server.reply(401, {'message': '신규'}), data: Matchers.any);
    await expectLater(
      makeRepo().signIn(userId: 'x', fcmToken: ''),
      throwsA(isA<UnauthorizedException>().having((e) => e.operation, 'operation', isNull)),
    );
  });

  test('autoSignIn 성공', () async {
    adapter.onPost(
      '/auth/sign-in-auto/v2',
      (server) => server.reply(200, {'status': 'success', 'resData': userJson()}),
      data: Matchers.any,
    );
    final user = await makeRepo().autoSignIn(accessToken: 'tok');
    expect(user.userId, 'mock_user_id');
  });

  test('signUp 성공(FormData)', () async {
    adapter.onPost(
      '/auth/sign-up',
      (server) => server.reply(200, {'status': 'success', 'resData': userJson(nickname: '가입')}),
      data: Matchers.any,
    );
    final user = await makeRepo().signUp(
      userId: 'u',
      email: 'e@e.com',
      type: SignInType.google,
      nickname: '가입',
      image: '',
      background: '',
      character: 'Chick',
      fcmToken: '',
    );
    expect(user.nickname, '가입');
  });

  test('checkNickname 성공은 정상 완료', () async {
    adapter.onPost('/auth/check-nickname', (server) => server.reply(200, {'status': 'success'}), data: Matchers.any);
    await expectLater(makeRepo().checkNickname('newbie'), completes);
  });

  test('checkNickname 409 는 ConflictException', () async {
    adapter.onPost('/auth/check-nickname', (server) => server.reply(409, {'message': '중복'}), data: Matchers.any);
    await expectLater(makeRepo().checkNickname('dup'), throwsA(isA<ConflictException>()));
  });

  test('서버 에러는 operation 라벨이 붙은 ApiException', () async {
    adapter.onPost('/auth/sign-out', (server) => server.reply(500, {'message': '서버 오류'}), data: Matchers.any);
    await expectLater(
      makeRepo().signOut(),
      throwsA(isA<ApiException>().having((e) => e.displayMessage, 'displayMessage', startsWith('[로그아웃]'))),
    );
  });
}
