// 핵심 chrome 위젯 단위 테스트 — FeedButton(활성/비활성/로딩)·FeedHeader(제목·뒤로)·FeedTabBar(탭 콜백) (widget test).
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/core/widgets/feed_button.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget body, {PreferredSizeWidget? appBar, Widget? bottomBar}) => MaterialApp(
  theme: buildAppTheme(),
  home: Scaffold(appBar: appBar, body: body, bottomNavigationBar: bottomBar),
);

void main() {
  group('FeedButton', () {
    testWidgets('활성 시 탭하면 onPressed 가 호출된다', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(FeedButton(title: '저장', onPressed: () => tapped = true)));
      await tester.tap(find.text('저장'));
      expect(tapped, isTrue);
    });

    testWidgets('disabled 면 탭해도 onPressed 가 호출되지 않는다', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(FeedButton(title: '저장', onPressed: () => tapped = true, disabled: true)));
      await tester.tap(find.text('저장'));
      expect(tapped, isFalse);
    });

    testWidgets('로딩 시 라벨 대신 인디케이터를 보이고 탭이 막힌다', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(FeedButton(title: '저장', onPressed: () => tapped = true, isLoading: true)));
      expect(find.text('저장'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(FeedButton));
      expect(tapped, isFalse);
    });
  });

  group('FeedHeader', () {
    testWidgets('제목을 렌더한다', (tester) async {
      await tester.pumpWidget(_wrap(const SizedBox.shrink(), appBar: const FeedHeader(title: '설정')));
      expect(find.text('설정'), findsOneWidget);
    });

    testWidgets('뒤로 버튼 탭 시 이전 화면으로 pop 된다', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildAppTheme(),
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const Scaffold(appBar: FeedHeader(title: '상세', hasBackButton: true)),
                    ),
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('상세'), findsOneWidget);

      await tester.tap(find.byIcon(FeedIcons.back));
      await tester.pumpAndSettle();
      expect(find.text('상세'), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });
  });

  group('FeedTabBar', () {
    testWidgets('탭을 누르면 해당 인덱스로 onTap 이 호출된다', (tester) async {
      int? tappedIndex;
      await tester.pumpWidget(
        _wrap(
          const SizedBox.shrink(),
          bottomBar: FeedTabBar(
            currentIndex: 0,
            onTap: (i) => tappedIndex = i,
            items: const [
              FeedTabItem(icon: FeedIcons.tabFlowerpot, label: '나의 화분'),
              FeedTabItem(icon: FeedIcons.tabDiary, label: '나의 일기'),
            ],
          ),
        ),
      );
      expect(find.text('나의 화분'), findsOneWidget);
      expect(find.text('나의 일기'), findsOneWidget);

      await tester.tap(find.text('나의 일기'));
      expect(tappedIndex, 1);
    });
  });
}
