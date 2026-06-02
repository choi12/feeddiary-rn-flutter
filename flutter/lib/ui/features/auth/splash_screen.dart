// 부트스트랩 화면 — 세션 복원(자동 로그인)을 트리거하고 결과를 기다린다. RN screens/start/Update 대응.
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 앱 진입 직후의 스플래시. [AuthController.restore]로 토큰 기반 세션 복원을 시작하고,
/// 인증 상태가 정해지면 GoRouter redirect 가 SignIn/Home 으로 이동시킨다. RN `Update` 화면 1:1.
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
      backgroundColor: FeedPalette.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Image.asset(AppAssets.logo, height: 37, fit: BoxFit.contain),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FeedIcons.alert, size: 15, color: FeedPalette.main),
                  SizedBox(width: 5),
                  Text(
                    '앱 버전 확인 중...',
                    style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.main),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
