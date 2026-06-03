// 로그인 화면 — FIELD_GREEN 배경·캐릭터 캔버스(로고/해/물뿌리개/레모니)·소셜 로그인 버튼. RN screens/start/SignIn 대응.
import 'dart:async';

import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 소셜 로그인 진입 화면. 버튼 탭 → [AuthController.signIn] → 신규 사용자면 CreateProfile 로 분기,
/// 기존 사용자면 redirect 가 home 으로 이동시킨다. RN `SignIn`(CharacterCanvas + ButtonBox) 1:1.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  bool _loading = false;

  Future<void> _signIn(SignInType type) async {
    setState(() => _loading = true);
    try {
      final newUser = await ref.read(authControllerProvider.notifier).signIn(type);
      if (newUser != null && mounted) {
        unawaited(context.push(Routes.createProfile, extra: newUser));
      }
      // 성공(null)이면 인증 상태 전환으로 redirect 가 home 으로 이동.
    } on AppException catch (e) {
      if (mounted) showFeedToast(context, e.displayMessage, offset: FeedToastOffset.inner);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 플랫폼별 버튼 순서 — RN BUTTON_ORDER(iOS: apple 먼저 / 그 외: google 먼저).
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final order = isIOS ? const [SignInType.apple, SignInType.google] : const [SignInType.google, SignInType.apple];

    return Scaffold(
      // RN SafeAreaContainer 배경 fieldGreen — 하단 안전영역에만 노출(언덕과 블렌딩).
      backgroundColor: FeedPalette.fieldGreen,
      body: SafeArea(
        top: false,
        // RN Container 기본 흰 배경 — 콘텐츠(캐릭터 캔버스)는 흰색이고, 하단 언덕(field.png)만 녹색이다.
        child: ColoredBox(
          color: FeedPalette.white,
          // RN 은 CharacterCanvas 에 zIndex 1 을 줘 레모니(bottom −20)가 ButtonBox 언덕 위에 얹힌다.
          // Column 기본 순서는 ButtonBox 를 나중에(위에) 그려 레모니를 가리므로, verticalDirection.up + 순서를 뒤집어 CharacterCanvas 를 위에 그린다.
          child: Column(
            verticalDirection: VerticalDirection.up,
            children: [
              Expanded(
                flex: 10,
                child: _ButtonBox(order: order, onSignIn: _loading ? null : _signIn),
              ),
              const Expanded(flex: 14, child: _CharacterCanvas()),
            ],
          ),
        ),
      ),
    );
  }
}

/// 상단 캐릭터 캔버스 — 로고·해·물뿌리개·레모니 캐릭터를 배치한다. RN `CharacterCanvas`(absolute 배치) 대응.
class _CharacterCanvas extends StatelessWidget {
  const _CharacterCanvas();

  @override
  Widget build(BuildContext context) {
    // RN CharacterCanvas — 절대 px(logo bottom290·sun left20 bottom130·watering right15 bottom140·lemony bottom−20) 그대로 전사.
    // 폰 프레임 전제라 캔버스 높이 비율 환산을 쓰지 않는다(RN 1:1).
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: 290,
          left: 0,
          right: 0,
          child: Center(child: Image.asset(AppAssets.logo, height: 50, fit: BoxFit.contain)),
        ),
        Positioned(left: 20, bottom: 130, child: Image.asset(AppAssets.signInSun, width: 70, height: 70)),
        Positioned(
          right: 15,
          bottom: 140,
          child: Image.asset(AppAssets.signInWatering, height: 120, fit: BoxFit.contain),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: -20,
          child: Center(child: Image.asset(AppAssets.signInLemony, height: 180, fit: BoxFit.contain)),
        ),
      ],
    );
  }
}

/// 하단 버튼 영역 — 잔디밭 배경 위에 소셜 로그인 버튼을 세로로 쌓는다. RN `ButtonBox`(Field 배경 + buttonWrapper) 대응.
class _ButtonBox extends StatelessWidget {
  const _ButtonBox({required this.order, required this.onSignIn});

  final List<SignInType> order;
  final ValueChanged<SignInType>? onSignIn;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // RN ButtonBox.fieldImage — contentFit:'fill'(=BoxFit.fill). box(100%×100%)에 늘려 채운다(crop 없음).
        Positioned.fill(child: Image.asset(AppAssets.signInField, fit: BoxFit.fill)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final type in order) ...[
                  _SocialButton(type: type, onPressed: onSignIn == null ? null : () => onSignIn!(type)),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 소셜 로그인 버튼. RN SignInButton + ButtonContent(google=흰 배경·검정 글자 / apple=검정 배경·흰 글자) 1:1.
class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.type, required this.onPressed});

  final SignInType type;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isApple = type == SignInType.apple;
    final background = isApple ? FeedPalette.darkBlack : FeedPalette.white;
    final foreground = isApple ? FeedPalette.white : FeedPalette.black;
    final label = isApple ? 'Sign in with Apple' : 'Sign in with Google';
    final iconAsset = isApple ? AppAssets.appleIcon : AppAssets.googleIcon;

    return SizedBox(
      width: double.infinity,
      height: AppDimens.buttonHeight,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(AppDimens.borderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppDimens.borderRadius),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10, bottom: isApple ? 5 : 0),
                child: Image.asset(iconAsset, width: 21, height: 22, fit: BoxFit.contain),
              ),
              Text(
                label,
                style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 16, color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
