// SettingScreen 위젯 스모크 — 프로필(닉네임)·메뉴 4종·로그아웃 렌더 (widget test).
import 'package:feeddiary/data/models/user.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/setting/setting_screen.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
