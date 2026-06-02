// AuthController — restore/signIn/signUp/signOut 상태 전환. ProviderContainer + http_mock_adapter + secure_storage 채널 mock (Tier B).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  final store = <String, String>{};

  late Dio dio;
  late DioAdapter adapter;

  ProviderContainer makeContainer() {
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    return container;
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
    store.clear();
    // flutter_secure_storage 채널을 인메모리로 mock (token_storage_test 패턴).
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
      final args = (call.arguments as Map).cast<String, Object?>();
      final key = args['key'] as String?;
      switch (call.method) {
        case 'read':
          return store[key];
        case 'write':
          store[key!] = args['value'] as String;
          return null;
        case 'delete':
          store.remove(key);
          return null;
        case 'containsKey':
          return store.containsKey(key);
      }
      return null;
    });
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('restore: 토큰 없으면 unauthenticated', () async {
    final container = makeContainer();
    await container.read(authControllerProvider.notifier).restore();
    expect(container.read(authControllerProvider).status, AuthStatus.unauthenticated);
  });

  test('restore: 토큰 있으면 autoSignIn → authenticated', () async {
    adapter.onPost(
      '/auth/sign-in-auto/v2',
      (server) => server.reply(200, {'status': 'success', 'resData': userJson(nickname: '복원')}),
      data: Matchers.any,
    );
    final container = makeContainer();
    await container.read(tokenStorageProvider).save('existing');
    await container.read(authControllerProvider.notifier).restore();
    final state = container.read(authControllerProvider);
    expect(state.status, AuthStatus.authenticated);
    expect(state.user?.nickname, '복원');
  });

  test('restore: autoSignIn 실패 시 토큰 정리 + unauthenticated', () async {
    adapter.onPost('/auth/sign-in-auto/v2', (server) => server.reply(401, {'message': '만료'}), data: Matchers.any);
    final container = makeContainer();
    final tokenStorage = container.read(tokenStorageProvider);
    await tokenStorage.save('expired');
    await container.read(authControllerProvider.notifier).restore();
    expect(container.read(authControllerProvider).status, AuthStatus.unauthenticated);
    expect(tokenStorage.token, isNull);
  });

  test('signIn 성공 → authenticated + 토큰 저장', () async {
    adapter.onPost(
      '/auth/sign-in',
      (server) => server.reply(200, {'status': 'success', 'resData': userJson(token: 'newtok')}),
      data: Matchers.any,
    );
    final container = makeContainer();
    final result = await container.read(authControllerProvider.notifier).signIn(SignInType.google);
    expect(result, isNull);
    expect(container.read(authControllerProvider).status, AuthStatus.authenticated);
    expect(container.read(tokenStorageProvider).token, 'newtok');
  });

  test('signIn 신규 사용자(401) → NewUserInfo 반환, authenticated 아님', () async {
    adapter.onPost('/auth/sign-in', (server) => server.reply(401, {'message': '신규'}), data: Matchers.any);
    final container = makeContainer();
    final result = await container.read(authControllerProvider.notifier).signIn(SignInType.google);
    expect(result, isA<NewUserInfo>());
    expect(result!.uid, 'mock_user_id');
    expect(container.read(authControllerProvider).status, isNot(AuthStatus.authenticated));
  });

  test('signUp 성공 → authenticated + 토큰 저장', () async {
    adapter.onPost(
      '/auth/sign-up',
      (server) => server.reply(200, {'status': 'success', 'resData': userJson(nickname: '가입', token: 'signuptok')}),
      data: Matchers.any,
    );
    final container = makeContainer();
    const info = NewUserInfo(uid: 'u', email: 'e@e.com', type: SignInType.google);
    await container.read(authControllerProvider.notifier).signUp(info: info, nickname: '가입', character: 'Chick');
    expect(container.read(authControllerProvider).status, AuthStatus.authenticated);
    expect(container.read(tokenStorageProvider).token, 'signuptok');
  });

  test('signOut → unauthenticated + 토큰 정리', () async {
    adapter.onPost('/auth/sign-out', (server) => server.reply(200, {'status': 'success'}), data: Matchers.any);
    final container = makeContainer();
    final tokenStorage = container.read(tokenStorageProvider);
    await tokenStorage.save('tok');
    await container.read(authControllerProvider.notifier).signOut();
    expect(container.read(authControllerProvider).status, AuthStatus.unauthenticated);
    expect(tokenStorage.token, isNull);
  });
}
