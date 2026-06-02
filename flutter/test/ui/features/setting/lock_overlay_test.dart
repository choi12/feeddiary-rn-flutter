// LockOverlay 위젯 — 비밀번호 입력→검증→해제(정답)·에러 표시(오답). A-6 핵심 흐름 (widget test, secure 채널 mock).
import 'package:feeddiary/data/services/lock_storage.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/setting/lock_overlay.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  final store = <String, String>{};

  setUp(() {
    store.clear();
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
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  Future<LockStorage> lockWithPassword(String password) async {
    final lock = LockStorage(const FlutterSecureStorage());
    await lock.setPassword(password);
    return lock;
  }

  Future<void> pumpOverlay(WidgetTester tester, LockStorage lock, {required void Function() onUnlocked}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [lockStorageProvider.overrideWithValue(lock)],
        child: MaterialApp(
          theme: buildAppTheme(),
          home: Scaffold(body: LockOverlay(onUnlocked: onUnlocked)),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> enter(WidgetTester tester, String digits) async {
    for (final d in digits.split('')) {
      await tester.tap(find.text(d));
      await tester.pump();
    }
  }

  testWidgets('정확한 비밀번호 입력 시 해제 콜백이 호출된다', (tester) async {
    final lock = await lockWithPassword('1234');
    var unlocked = false;
    await pumpOverlay(tester, lock, onUnlocked: () => unlocked = true);

    await enter(tester, '1234');
    expect(unlocked, isTrue);
  });

  testWidgets('틀린 비밀번호는 해제하지 않고 에러를 보여 준다', (tester) async {
    final lock = await lockWithPassword('1234');
    var unlocked = false;
    await pumpOverlay(tester, lock, onUnlocked: () => unlocked = true);

    await enter(tester, '0000');
    expect(unlocked, isFalse);
    expect(find.text(SettingStrings.passwordMismatch), findsOneWidget);
  });
}
