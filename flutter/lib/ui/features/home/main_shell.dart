// 메인 하단 탭 셸 — 5탭(화분/일기/공유/편지/설정) FeedTabBar + IndexedStack. RN BottomTabNavigation 대응.
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/widgets/feed_tab_bar.dart';
import 'package:feeddiary/ui/features/community/community_screen.dart';
import 'package:feeddiary/ui/features/diary/my_diary_screen.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_screen.dart';
import 'package:feeddiary/ui/features/letter/letters_screen.dart';
import 'package:feeddiary/ui/features/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 인증 후 진입하는 메인 셸. 5개 탭(화분/일기/공유/편지/설정)을 IndexedStack 으로 상태 보존하고,
/// RN 커스텀 하단 탭바([FeedTabBar])로 표시한다. RN React Navigation bottom-tabs → IndexedStack.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  // RN 초기 탭은 화분(index 0). PR⑥에서 화분이 실화면이 되어 RN 과 동일하게 화분으로 시작한다.
  int _index = 0;

  // RN BOTTOM_TAB_ICON + TAB_SCREENS 라벨. Letters 만 아이콘 23(나머지 21).
  static const List<FeedTabItem> _tabs = [
    FeedTabItem(icon: FeedIcons.tabFlowerpot, label: '나의 화분'),
    FeedTabItem(icon: FeedIcons.tabDiary, label: '나의 일기'),
    FeedTabItem(icon: FeedIcons.tabCommunity, label: '공유 일기'),
    FeedTabItem(icon: FeedIcons.tabLetters, label: '나의 편지', iconSize: 23),
    FeedTabItem(icon: FeedIcons.tabSetting, label: '설정'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    // RN 탭바는 absolute 오버레이라 화면이 탭바 뒤까지 풀블리드로 깔린다(화분 풀 캔버스가 대표) → extendBody 로 동일하게.
    // 화분 외 탭은 RN `Container isMain`(paddingBottom 75)처럼 탭바+안전영역만큼 하단을 비워 콘텐츠가 가리지 않게 한다.
    Widget belowTabBar(Widget child) => MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: AppDimens.bottomTabHeight + bottomInset),
        child: child,
      ),
    );
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: [
          const FlowerpotScreen(),
          belowTabBar(const MyDiaryScreen()),
          belowTabBar(const CommunityScreen()),
          belowTabBar(const LettersScreen()),
          belowTabBar(const SettingScreen()),
        ],
      ),
      bottomNavigationBar: FeedTabBar(
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        items: _tabs,
      ),
    );
  }
}
