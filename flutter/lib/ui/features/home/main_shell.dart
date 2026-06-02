// 메인 하단 탭 셸 — 5탭(화분/일기/공유/편지/설정) NavigationBar + IndexedStack. RN BottomTabNavigation 대응.
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/features/community/community_screen.dart';
import 'package:feeddiary/ui/features/diary/my_diary_screen.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 인증 후 진입하는 메인 셸. 5개 탭을 IndexedStack 으로 상태 보존하며, 현재는 일기 탭만 실화면이고
/// 나머지(화분/공유/편지/설정)는 후속 PR 에서 대체할 placeholder 다. RN React Navigation bottom-tabs → IndexedStack.
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
        children: const [
          FlowerpotScreen(),
          MyDiaryScreen(),
          CommunityScreen(),
          _PlaceholderTab(icon: Icons.mail_outline, label: '나의 편지'),
          _SettingPlaceholder(),
        ],
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

/// 후속 PR 에서 실화면으로 대체할 탭 placeholder.
class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: context.colors.outline),
            const SizedBox(height: 12),
            Text('$label 화면은 다음 PR에서 구현됩니다.', style: TextStyle(color: context.colors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

/// 설정 탭 placeholder — 로그아웃을 제공해 인증 흐름 데모를 유지한다(기존 home_screen 역할 흡수).
class _SettingPlaceholder extends ConsumerWidget {
  const _SettingPlaceholder();

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authControllerProvider.notifier).signOut();
    } on AppException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.displayMessage)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nickname = ref.watch(authControllerProvider).user?.nickname ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.eco, size: 56, color: context.colors.primary),
            const SizedBox(height: 12),
            Text('$nickname님', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => _signOut(context, ref),
              icon: const Icon(Icons.logout),
              label: const Text('로그아웃'),
            ),
          ],
        ),
      ),
    );
  }
}
