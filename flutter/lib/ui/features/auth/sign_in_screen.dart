// 로그인 화면 — 구글/애플 소셜 로그인 진입. RN screens/start/SignIn 대응(OAuth 데모 우회).
import 'dart:async';

import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 소셜 로그인 진입 화면. 버튼 탭 → [AuthController.signIn] → 신규 사용자면 CreateProfile 로 분기,
/// 기존 사용자면 redirect 가 home 으로 이동시킨다.
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.displayMessage)));
      }
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.padding),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.eco, size: 88, color: context.colors.primary),
                      const SizedBox(height: 20),
                      Text('새싹일기', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text('하루 한 줄, 마음을 심어요', style: TextStyle(color: context.colors.textSecondary)),
                    ],
                  ),
                ),
              ),
              for (final type in order) ...[
                _SocialButton(type: type, onPressed: _loading ? null : () => _signIn(type)),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 소셜 로그인 버튼. RN SignInButton + data.ts(색상/라벨) 대응.
class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.type, required this.onPressed});

  final SignInType type;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isApple = type == SignInType.apple;
    final background = isApple ? FeedPalette.darkBlack : context.colors.surface;
    final foreground = isApple ? FeedPalette.white : context.colors.textPrimary;
    final label = isApple ? 'Sign in with Apple' : 'Sign in with Google';
    final icon = isApple ? Icons.apple : Icons.account_circle;

    return SizedBox(
      width: double.infinity,
      height: AppDimens.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          elevation: 0,
          side: isApple ? null : BorderSide(color: context.colors.outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.borderRadius)),
        ),
        icon: Icon(icon, size: 22),
        label: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
