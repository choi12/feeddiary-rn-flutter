// chrome 위젯 골든 — FeedButton/FeedHeader/FeedTabBar/FeedMenuRow/FeedTextField 시각 스냅샷(실폰트·아이콘 글리프).
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/widgets/feed_button.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_menu_row.dart';
import 'package:feeddiary/ui/core/widgets/feed_tab_bar.dart';
import 'package:feeddiary/ui/core/widgets/feed_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _key = Key('golden');

Future<void> _pump(WidgetTester tester, {Widget? body, PreferredSizeWidget? appBar, Widget? bottomBar}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: FeedPalette.background,
        appBar: appBar,
        body: body,
        bottomNavigationBar: bottomBar,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// 본문 위젯을 흰 배경 위 RepaintBoundary 로 감싸 타이트한 골든 영역을 만든다.
Widget _boundary(Widget child) => Center(
  child: RepaintBoundary(
    key: _key,
    child: ColoredBox(color: FeedPalette.white, child: child),
  ),
);

void main() {
  testWidgets('FeedButton 활성/비활성 골든', (tester) async {
    await _pump(
      tester,
      body: _boundary(
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FeedButton(title: '저장하기', onPressed: () {}),
              const SizedBox(height: 16),
              FeedButton(title: '저장하기', onPressed: () {}, disabled: true),
            ],
          ),
        ),
      ),
    );
    await expectLater(find.byKey(_key), matchesGoldenFile('goldens/widget_feed_button.png'));
  });

  testWidgets('FeedHeader 골든', (tester) async {
    await _pump(
      tester,
      appBar: const FeedHeader(title: '나의 일기', hasBackButton: true),
      body: const SizedBox.shrink(),
    );
    await expectLater(find.byType(FeedHeader), matchesGoldenFile('goldens/widget_feed_header.png'));
  });

  testWidgets('FeedTabBar 골든', (tester) async {
    await _pump(
      tester,
      body: const SizedBox.shrink(),
      bottomBar: FeedTabBar(
        currentIndex: 0,
        onTap: (_) {},
        items: const [
          FeedTabItem(icon: FeedIcons.tabFlowerpot, label: '나의 화분'),
          FeedTabItem(icon: FeedIcons.tabDiary, label: '나의 일기'),
          FeedTabItem(icon: FeedIcons.tabCommunity, label: '공유 일기', iconOffset: Offset(-2, 0)),
          FeedTabItem(icon: FeedIcons.tabLetters, label: '나의 편지', iconSize: 23),
          FeedTabItem(icon: FeedIcons.tabSetting, label: '설정'),
        ],
      ),
    );
    await expectLater(find.byType(FeedTabBar), matchesGoldenFile('goldens/widget_feed_tab_bar.png'));
  });

  testWidgets('FeedMenuRow 골든', (tester) async {
    await _pump(
      tester,
      body: _boundary(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FeedMenuRow(icon: FeedIcons.settingLock, label: '앱 잠금', onTap: () {}),
            FeedMenuRow(icon: FeedIcons.settingSupport, label: '문의하기', onTap: () {}),
            FeedMenuRow(label: '라이선스', onTap: () {}),
          ],
        ),
      ),
    );
    await expectLater(find.byKey(_key), matchesGoldenFile('goldens/widget_feed_menu_row.png'));
  });

  testWidgets('FeedTextField 골든', (tester) async {
    await _pump(
      tester,
      body: _boundary(
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FeedTextField(hintText: '한글, 영어, 숫자 2~8자'),
              const SizedBox(height: 16),
              FeedTextField(controller: TextEditingController(text: '새싹이')),
            ],
          ),
        ),
      ),
    );
    await expectLater(find.byKey(_key), matchesGoldenFile('goldens/widget_feed_text_field.png'));
  });
}
