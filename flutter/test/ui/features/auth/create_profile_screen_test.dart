// CreateProfileScreen 위젯 스모크 — 닉네임 입력·프로필 이미지 편집기(사진/캐릭터)·가입 버튼(초기 비활성) (widget test).
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/core/widgets/feed_button.dart';
import 'package:feeddiary/ui/features/auth/create_profile_screen.dart';
import 'package:feeddiary/ui/features/setting/widgets/profile_image_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('프로필 폼이 닉네임·이미지 편집기·가입 버튼(초기 비활성)을 렌더한다', (tester) async {
    const info = NewUserInfo(uid: 'u', email: 'e@e.com', type: SignInType.google);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const CreateProfileScreen(info: info),
        ),
      ),
    );
    // 캐릭터 그리드의 36 Image.asset 디코딩 대기를 피하려 pump 만 사용한다.
    await tester.pump();

    expect(find.byType(TextField), findsOneWidget);
    // 프로필 이미지 편집기(아바타 탭→사진/캐릭터 모달)가 렌더된다. RN ProfileImageSection 공유(가입도 사진 지원).
    expect(find.byType(ProfileImageEditor), findsOneWidget);
    expect(find.text('새싹일기 시작하기'), findsOneWidget);

    // canSubmit=false(닉네임 미검증 + 프로필 이미지 미선택) → 가입 버튼 비활성.
    final button = tester.widget<FeedButton>(find.byType(FeedButton));
    expect(button.disabled, isTrue);
  });
}
