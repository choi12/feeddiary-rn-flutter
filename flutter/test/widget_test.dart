// 스모크 테스트 — 앱이 ProviderScope 아래 크래시 없이 렌더되고 unauthenticated 시 SignIn 화면에 도달하는지 검증.
import 'package:feeddiary/app.dart';
import 'package:feeddiary/ui/features/auth/sign_in_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('앱이 크래시 없이 렌더되고 SignIn 화면으로 redirect 된다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FeedDiaryApp()));
    await tester.pumpAndSettle();

    // 토큰이 없어 세션 복원 결과 unauthenticated → SignIn 화면 도달.
    expect(find.byType(SignInScreen), findsOneWidget);
    expect(find.text('Sign in with Google'), findsOneWidget);
    expect(find.text('Sign in with Apple'), findsOneWidget);
  });
}
