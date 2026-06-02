// UpdateProfileScreen 위젯 스모크 — 닉네임 입력·저장 버튼(초기 비활성)·탈퇴 버튼 렌더 (widget test).
import 'package:feeddiary/data/models/user.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:feeddiary/ui/features/setting/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  testWidgets('프로필 수정 화면이 폼·저장 버튼(초기 비활성)·탈퇴 버튼을 렌더한다', (tester) async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    container.read(authControllerProvider.notifier).setUser(testUser);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: buildAppTheme(), home: const UpdateProfileScreen()),
      ),
    );
    await tester.pump();

    // 사진/캐릭터 토글(상단·항상 빌드)·탈퇴(AppBar)·저장(bottomNav)을 확인한다.
    // 닉네임 TextField 는 36개 캐릭터 그리드 아래라 lazy ListView 에서 뷰포트 밖 → 폼 로직은 컨트롤러 테스트가 커버.
    expect(find.text(SettingStrings.pickCharacter), findsOneWidget);
    expect(find.text(SettingStrings.save), findsOneWidget);
    expect(find.text(SettingStrings.deleteAccount), findsOneWidget);

    // 변경 전이라 저장 버튼 비활성(canSubmit=false).
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });
}
