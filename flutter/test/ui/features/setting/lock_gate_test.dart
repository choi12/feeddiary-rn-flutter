// LockGate — 잠금 오버레이(Navigator 밖)가 떠 있는 동안 Android 시스템 뒤로가기를 소비하는지 (widget test, secure 채널 mock).
import 'dart:async';

import 'package:feeddiary/data/services/lock_storage.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:feeddiary/ui/features/setting/widgets/lock_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// 로그인된 상태로 고정한 AuthController(잠금 오버레이는 인증 상태에서만 뜬다).
class _SignedIn extends AuthController {
  @override
  AuthState build() => const AuthState(status: AuthStatus.authenticated);
}

void main() {
  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  final store = <String, String>{};
  final platformCalls = <MethodCall>[];

  setUp(() {
    store.clear();
    platformCalls.clear();
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(channel, (call) async {
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
      }
      return null;
    });
    // SystemNavigator.pop(앱 종료) · setFrameworkHandlesBack 호출을 기록한다.
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      platformCalls.add(call);
      return null;
    });
  });

  tearDown(() {
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(channel, null);
    messenger.setMockMethodCallHandler(SystemChannels.platform, null);
  });

  bool appExited() => platformCalls.any((c) => c.method == 'SystemNavigator.pop');

  /// 마지막으로 플랫폼에 알린 「프레임워크가 뒤로가기를 받는가」(Android predictive back 에서 시스템이 먼저 가로채는지 결정).
  bool? frameworkHandlesBack() => platformCalls
      .where((c) => c.method == 'SystemNavigator.setFrameworkHandlesBack')
      .map((c) => c.arguments as bool)
      .lastOrNull;

  /// 앱과 같은 배치 — MaterialApp.router 의 builder 에서 LockGate 가 라우터(Navigator)를 감싼다.
  Future<GoRouter> pumpLockedApp(WidgetTester tester) async {
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    final lock = LockStorage(const FlutterSecureStorage());
    await lock.setPassword('1234');
    await lock.enableLock();
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('home')),
        ),
        GoRoute(
          path: '/detail',
          builder: (_, _) => const Scaffold(body: Text('detail')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [lockStorageProvider.overrideWithValue(lock), authControllerProvider.overrideWith(_SignedIn.new)],
        child: MaterialApp.router(
          theme: buildAppTheme(),
          routerConfig: router,
          builder: (_, child) => LockGate(child: child!),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(SettingStrings.unlockTitle), findsOneWidget);
    return router;
  }

  testWidgets('잠금 중 뒤로가기는 오버레이 아래 화면을 빼지 않는다', (tester) async {
    final router = await pumpLockedApp(tester);
    unawaited(router.push('/detail'));
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(router.canPop(), isTrue);
    expect(find.text(SettingStrings.unlockTitle), findsOneWidget);
  });

  testWidgets('첫 화면에서 잠금 중 뒤로가기는 앱을 내보내지 않는다', (tester) async {
    await pumpLockedApp(tester);
    expect(frameworkHandlesBack(), isTrue);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(appExited(), isFalse);
    expect(find.text(SettingStrings.unlockTitle), findsOneWidget);
  });

  testWidgets('해제하면 뒤로가기가 다시 라우터로 간다', (tester) async {
    final router = await pumpLockedApp(tester);
    unawaited(router.push('/detail'));
    await tester.pumpAndSettle();
    for (final d in '1234'.split('')) {
      await tester.tap(find.text(d));
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(find.text(SettingStrings.unlockTitle), findsNothing);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(router.canPop(), isFalse);
  });
}
