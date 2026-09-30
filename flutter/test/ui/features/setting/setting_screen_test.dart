// SettingScreen 위젯 스모크 — 프로필(닉네임)·메뉴 4종·로그아웃 렌더 + 로그아웃 토스트가 redirect 뒤에 남는지 (widget test).
import 'package:feeddiary/data/models/user.dart';
import 'package:feeddiary/data/services/demo_api_adapter.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/setting/character_catalog.dart';
import 'package:feeddiary/ui/features/setting/setting_screen.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  final testUser = User(
    idx: 1,
    account: 'demo@example.com',
    userId: 'mock_user_id',
    nickname: '새싹이',
    image: '',
    background: '',
    character: 'Chick',
    type: SignInType.google,
    createdAt: DateTime.utc(2026),
    token: 'tok',
    fcmToken: '',
  );

  testWidgets('설정 화면이 프로필·메뉴·로그아웃을 렌더한다', (tester) async {
    final container = ProviderContainer(retry: (_, _) => null);
    addTearDown(container.dispose);
    container.read(authControllerProvider.notifier).setUser(testUser);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: buildAppTheme(), home: const SettingScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('새싹이'), findsOneWidget);
    expect(find.text(SettingStrings.editProfile), findsOneWidget);
    expect(find.text(SettingStrings.menuLock), findsOneWidget);
    expect(find.text(SettingStrings.menuSupport), findsOneWidget);
    expect(find.text(SettingStrings.menuLicense), findsOneWidget);
    expect(find.text(SettingStrings.menuAppVersion), findsOneWidget);
    expect(find.text(SettingStrings.signOut), findsOneWidget);
  });

  testWidgets('프로필 캐릭터 아바타는 사용자의 배경색을 칠한다(RN ProfileImageBox)', (tester) async {
    final container = ProviderContainer(retry: (_, _) => null);
    addTearDown(container.dispose);
    container.read(authControllerProvider.notifier).setUser(testUser.copyWith(background: '#ABCDEF'));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: buildAppTheme(), home: const SettingScreen()),
      ),
    );
    await tester.pump();

    final characterImage = find.byWidgetPredicate(
      (w) =>
          w is Image &&
          w.image is AssetImage &&
          (w.image as AssetImage).assetName == CharacterCatalog.assetFor('Chick'),
    );
    final circle = tester.widget<Container>(find.ancestor(of: characterImage, matching: find.byType(Container)).first);
    expect((circle.decoration! as BoxDecoration).color, const Color(0xFFABCDEF));
  });

  testWidgets('로그아웃하면 로그인 화면으로 redirect 된 뒤에도 로그아웃 토스트가 보인다', (tester) async {
    // 토큰 삭제가 닿는 flutter_secure_storage 채널을 무동작으로 mock.
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (_) async => null,
    );
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()))
      ..httpClientAdapter = DemoApiAdapter(latency: Duration.zero);
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    container.read(authControllerProvider.notifier).setUser(testUser);

    // 앱 라우터와 같은 방식(인증 상태 → refreshListenable → redirect)의 최소 라우터.
    final authStatus = ValueNotifier(AuthStatus.authenticated);
    addTearDown(authStatus.dispose);
    container.listen(authControllerProvider, (_, next) => authStatus.value = next.status);
    final router = GoRouter(
      refreshListenable: authStatus,
      redirect: (_, state) => authStatus.value == AuthStatus.unauthenticated ? '/sign-in' : null,
      routes: [
        GoRoute(path: '/', builder: (_, _) => const SettingScreen()),
        GoRoute(
          path: '/sign-in',
          builder: (_, _) => const Scaffold(body: Text('로그인 화면')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(theme: buildAppTheme(), routerConfig: router),
      ),
    );
    await tester.pump();

    await tester.tap(find.text(SettingStrings.signOut));
    await tester.pumpAndSettle();
    await tester.tap(find.text(SettingStrings.signOut).last); // 확인 모달의 로그아웃 버튼
    await tester.pump(const Duration(milliseconds: 500)); // 모달 닫힘 + 로그아웃 요청·토큰 삭제
    await tester.pump(const Duration(milliseconds: 500)); // 토스트 삽입 후 redirect 반영

    expect(find.text('로그인 화면'), findsOneWidget);
    expect(find.byType(SettingScreen), findsNothing);
    expect(find.text(SettingStrings.signedOut), findsOneWidget);
    await tester.pump(const Duration(seconds: 3)); // 토스트 자동 소멸 타이머 소진
  });
}
