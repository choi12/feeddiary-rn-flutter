// CreateProfileScreen 위젯 스모크 — 닉네임 입력·캐릭터 칩·가입 버튼(초기 비활성) (widget test).
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/auth/create_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('프로필 폼이 렌더되고 가입 버튼이 초기 비활성이다', (tester) async {
    const info = NewUserInfo(uid: 'u', email: 'e@e.com', type: SignInType.google);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const CreateProfileScreen(info: info),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Chick'), findsOneWidget);
    expect(find.text('새싹일기 시작하기'), findsOneWidget);

    // canSubmit=false(닉네임 미검증 + 캐릭터 미선택) → 가입 버튼 비활성.
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });
}
