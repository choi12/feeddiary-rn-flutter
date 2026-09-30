// AuthController — restore/signIn/signUp/signOut 상태 전환. ProviderContainer + http_mock_adapter + secure_storage 채널 mock (Tier B).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/features/community/comments_controller.dart';
import 'package:feeddiary/ui/features/community/diary_likes.dart';
import 'package:feeddiary/ui/features/diary/diary_detail_controller.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_controller.dart';
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

  test('로그아웃만으로는 재조회하지 않고, 다음 로그인에서 이전 세션의 좋아요·화분을 비우고 다시 불러온다', () async {
    var flowerpotFetches = 0;
    dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.path == '/flowerpot') flowerpotFetches++;
          handler.next(options);
        },
      ),
    );
    adapter
      ..onPost('/auth/sign-out', (server) => server.reply(200, {'status': 'success'}), data: Matchers.any)
      ..onPost(
        '/auth/sign-in',
        (server) => server.reply(200, {'status': 'success', 'resData': userJson(token: 'newtok')}),
        data: Matchers.any,
      )
      ..onPost(
        '/diary/like',
        (server) => server.reply(200, {
          'status': 'success',
          'resData': {'like_count': 1, 'isLike': true},
        }),
        data: Matchers.any,
      )
      ..onGet(
        '/flowerpot',
        (server) => server.reply(200, {
          'status': 'success',
          'resData': {'level': 1, 'exp': 0, 'max_exp': 100, 'watering_count': 1, 'love_count': 1, 'showBadge': false},
        }),
      );
    final container = makeContainer();
    // 화면이 구독 중인 상태를 흉내 낸다(구독자가 있으면 invalidate 가 즉시 재조회를 예약한다).
    container.listen(flowerpotControllerProvider, (_, _) {});
    await container.read(diaryLikesProvider.notifier).toggle(idx: 1, baseIsLike: false, baseLikeCount: 0);
    await container.read(flowerpotControllerProvider.future);
    final fetchesBeforeSignOut = flowerpotFetches;

    await container.read(authControllerProvider.notifier).signOut();
    await Future<void>.delayed(const Duration(milliseconds: 50)); // 예약된 재조회가 있었다면 요청까지 나갈 시간
    expect(flowerpotFetches, fetchesBeforeSignOut);

    await container.read(authControllerProvider.notifier).signIn(SignInType.google);
    expect(container.read(diaryLikesProvider), isEmpty);
    await container.read(flowerpotControllerProvider.future);
    expect(flowerpotFetches, fetchesBeforeSignOut + 1);
  });

  test('다음 로그인에서 이전 세션이 본 일기 상세·댓글 캐시도 비우고 다시 불러온다', () async {
    final fetched = <String>[];
    dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (options, handler) {
          fetched.add(options.path);
          handler.next(options);
        },
      ),
    );
    adapter
      ..onPost(
        '/auth/sign-in',
        (server) => server.reply(200, {'status': 'success', 'resData': userJson(token: 'newtok')}),
        data: Matchers.any,
      )
      ..onGet(
        '/diary/1',
        (server) => server.reply(200, {
          'status': 'success',
          'resData': {
            'idx': 1,
            'user_idx': 1,
            'nickname': '새싹이',
            'sticker': 'Star',
            'text': '본문',
            'image': '',
            'created_time': '2026-06-01T00:00:00.000Z',
            'updated_time': null,
            'is_visible': 1,
            'like_count': 0,
            'commentCount': 0,
            'user_image': '',
            'background': '',
            'character': 'Chick',
            'isLike': false,
          },
        }),
      )
      ..onGet('/comment/list/1', (server) => server.reply(200, {'status': 'success', 'resData': <Object>[]}));
    final container = makeContainer();
    await container.read(diaryDetailControllerProvider(1).future);
    await container.read(commentsControllerProvider(1).future);

    await container.read(authControllerProvider.notifier).signIn(SignInType.google);
    await container.read(diaryDetailControllerProvider(1).future);
    await container.read(commentsControllerProvider(1).future);

    expect(fetched.where((path) => path == '/diary/1'), hasLength(2));
    expect(fetched.where((path) => path == '/comment/list/1'), hasLength(2));
  });
}
