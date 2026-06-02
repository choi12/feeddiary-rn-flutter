// 임시 홈 화면 — 인증 후 진입점. 환영 메시지 + 로그아웃. 다음 PR(flowerpot/diary)에서 실화면으로 대체.
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 인증 후 진입하는 임시 홈. 인증 상태 전환(로그인→home, 로그아웃→signIn)을 시연하기 위한 최소 화면이며,
/// 실제 홈(화분/일기)은 다음 PR에서 대체한다.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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
      appBar: AppBar(title: const Text('새싹일기')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.eco, size: 56, color: context.colors.primary),
            const SizedBox(height: 16),
            Text('$nickname님, 환영합니다!', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('로그인 흐름 데모 — 실제 홈은 다음 PR에서 구현됩니다.', style: TextStyle(color: context.colors.textSecondary)),
            const SizedBox(height: 32),
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
