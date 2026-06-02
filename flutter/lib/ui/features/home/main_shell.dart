// 메인 하단 탭 셸 — 5탭(화분/일기/공유/편지/설정) NavigationBar + IndexedStack. RN BottomTabNavigation 대응.
import 'package:feeddiary/ui/features/community/community_screen.dart';
import 'package:feeddiary/ui/features/diary/my_diary_screen.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_screen.dart';
import 'package:feeddiary/ui/features/letter/letters_screen.dart';
import 'package:feeddiary/ui/features/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 인증 후 진입하는 메인 셸. 5개 탭(화분/일기/공유/편지/설정)을 IndexedStack 으로 상태 보존한다.
/// 전 탭이 실화면이다. RN React Navigation bottom-tabs → IndexedStack.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  // RN 초기 탭은 화분(index 0). PR⑥에서 화분이 실화면이 되어 RN 과 동일하게 화분으로 시작한다.
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [FlowerpotScreen(), MyDiaryScreen(), CommunityScreen(), LettersScreen(), SettingScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_florist_outlined),
            selectedIcon: Icon(Icons.local_florist),
            label: '화분',
          ),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: '일기'),
          NavigationDestination(
            icon: Icon(Icons.people_alt_outlined),
            selectedIcon: Icon(Icons.people_alt),
            label: '공유',
          ),
          NavigationDestination(icon: Icon(Icons.mail_outline), selectedIcon: Icon(Icons.mail), label: '편지'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}
