// 스모크 테스트 — 앱이 ProviderScope 아래에서 크래시 없이 렌더되고 초기 라우트에 도달하는지 검증.
import 'package:feeddiary/app.dart';
import 'package:feeddiary/ui/core/widgets/placeholder_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('앱이 크래시 없이 렌더되고 Sign In placeholder 로 redirect 된다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FeedDiaryApp()));
    await tester.pumpAndSettle();

    // 앱이 마운트되고 화면이 렌더된다.
    expect(find.byType(FeedDiaryApp), findsOneWidget);
    expect(find.byType(PlaceholderPage), findsOneWidget);

    // 인증 placeholder 가 unauthenticated 라 redirect 로 Sign In 화면에 도달한다.
    expect(find.text('Sign In'), findsWidgets);
  });
}
