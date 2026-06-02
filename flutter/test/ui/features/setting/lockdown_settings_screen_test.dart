// LockdownSettingsScreen 위젯 스모크 — 잠금 토글 + 비밀번호 재설정 행 렌더 (widget test, secure 채널 mock).
import 'package:feeddiary/data/services/lock_storage.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/setting/lockdown_settings_screen.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (call) async => null,
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  testWidgets('잠금 설정 화면이 토글과 재설정 행을 렌더한다', (tester) async {
    final lock = LockStorage(const FlutterSecureStorage());
    await lock.load();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [lockStorageProvider.overrideWithValue(lock)],
        child: MaterialApp(theme: buildAppTheme(), home: const LockdownSettingsScreen()),
      ),
    );
    await tester.pump();

    expect(find.text(SettingStrings.lockUseSwitch), findsOneWidget);
    expect(find.text(SettingStrings.lockResetPassword), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
  });
}
