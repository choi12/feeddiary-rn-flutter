// 부트스트랩 화면 — 세션 복원(자동 로그인)을 트리거하고 결과를 기다린다. RN Update 화면 대응(버전체크는 후속).
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 앱 진입 직후의 스플래시. [AuthController.restore]로 토큰 기반 세션 복원을 시작하고,
/// 인증 상태가 정해지면 GoRouter redirect 가 SignIn/Home 으로 이동시킨다.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 첫 프레임 후 세션 복원 시작(빌드 중 provider 변경 회피). RN Update 의 useAppUpdate 트리거 대응.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authControllerProvider.notifier).restore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.eco, size: 72, color: context.colors.primary),
            const SizedBox(height: 16),
            Text('새싹일기', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
