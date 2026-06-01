// GoRouter 설정 — AuthState 기반 redirect 골격 + placeholder 라우트. (Riverpod 코드젠)
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/widgets/placeholder_page.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// 앱 전역 [GoRouter]. [AuthController]의 상태를 watch 해 redirect 로 분기한다.
/// PR① 골격 — 라우트 타겟은 모두 [PlaceholderPage]이고, 실제 화면은 기능 PR에서 채운다.
@riverpod
GoRouter appRouter(Ref ref) {
  // 인증 상태 변화를 GoRouter 의 refreshListenable 로 연결한다.
  // (provider 를 watch 하지 않고 listen 으로 다리만 놓아 라우터 인스턴스는 안정적으로 유지.)
  final authListenable = ValueNotifier<AuthStatus>(ref.read(authControllerProvider));
  ref
    ..listen(authControllerProvider, (_, next) => authListenable.value = next)
    ..onDispose(authListenable.dispose);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: authListenable,
    redirect: (_, state) {
      final status = authListenable.value;
      final atSignIn = state.matchedLocation == Routes.signIn;
      return switch (status) {
        AuthStatus.unknown => null, // 부팅 판별 중 — 현재 위치 유지
        AuthStatus.unauthenticated => atSignIn ? null : Routes.signIn,
        AuthStatus.authenticated => atSignIn ? Routes.home : null,
      };
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (_, _) => const PlaceholderPage(title: 'Splash'),
      ),
      GoRoute(
        path: Routes.signIn,
        builder: (_, _) => const PlaceholderPage(title: 'Sign In'),
      ),
      GoRoute(
        path: Routes.home,
        builder: (_, _) => const PlaceholderPage(title: 'Home'),
      ),
    ],
  );
}
