// SignInScreen 위젯 스모크 — 소셜 로그인 버튼·브랜드가 렌더되는지 (widget test).
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('소셜 로그인 버튼과 브랜드가 렌더된다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: buildAppTheme(), home: const SignInScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sign in with Google'), findsOneWidget);
    expect(find.text('Sign in with Apple'), findsOneWidget);
    expect(find.text('새싹일기'), findsOneWidget);
  });
}
