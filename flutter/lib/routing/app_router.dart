// GoRouter 설정 — AuthState 기반 redirect + 인증/일기 라우트(splash/signIn/createProfile/home/diary). (Riverpod 코드젠)
import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/features/auth/create_profile_screen.dart';
import 'package:feeddiary/ui/features/auth/sign_in_screen.dart';
import 'package:feeddiary/ui/features/auth/splash_screen.dart';
import 'package:feeddiary/ui/features/community/comments_screen.dart';
import 'package:feeddiary/ui/features/diary/create_diary_screen.dart';
import 'package:feeddiary/ui/features/diary/diary_detail_screen.dart';
import 'package:feeddiary/ui/features/home/main_shell.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// 앱 전역 [GoRouter]. [AuthController]의 상태를 watch 해 redirect 로 분기한다.
/// 인증 흐름: splash(부트스트랩) → unauthenticated 면 signIn/createProfile, authenticated 면 home.
@riverpod
GoRouter appRouter(Ref ref) {
  // 인증 상태 변화를 GoRouter 의 refreshListenable 로 연결한다.
  // (provider 를 watch 하지 않고 listen 으로 다리만 놓아 라우터 인스턴스는 안정적으로 유지.)
  final authListenable = ValueNotifier<AuthStatus>(ref.read(authControllerProvider).status);
  ref
    ..listen(authControllerProvider, (_, next) => authListenable.value = next.status)
    ..onDispose(authListenable.dispose);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: authListenable,
    redirect: (_, state) {
      final status = authListenable.value;
      final location = state.matchedLocation;
      switch (status) {
        case AuthStatus.unknown:
          // 부팅 판별 중 — splash 유지.
          return location == Routes.splash ? null : Routes.splash;
        case AuthStatus.unauthenticated:
          // 로그인/회원가입 흐름만 허용, 그 외엔 signIn 으로.
          const allowed = {Routes.signIn, Routes.createProfile};
          return allowed.contains(location) ? null : Routes.signIn;
        case AuthStatus.authenticated:
          // 인증됨 — 인증 흐름 화면에 머물러 있으면 home 으로.
          const authFlow = {Routes.splash, Routes.signIn, Routes.createProfile};
          return authFlow.contains(location) ? Routes.home : null;
      }
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.signIn, builder: (_, _) => const SignInScreen()),
      GoRoute(
        path: Routes.createProfile,
        builder: (_, state) => CreateProfileScreen(info: state.extra! as NewUserInfo),
      ),
      GoRoute(path: Routes.home, builder: (_, _) => const MainShell()),
      // diaryWrite(정적)를 diaryDetail(:idx)보다 먼저 등록해 'write'가 idx 로 매칭되지 않게 한다.
      GoRoute(
        path: Routes.diaryWrite,
        builder: (_, state) => CreateDiaryScreen(initial: state.extra as MyDiary?),
      ),
      GoRoute(
        path: Routes.diaryDetail,
        builder: (_, state) => DiaryDetailScreen(diaryIdx: int.parse(state.pathParameters['idx']!)),
      ),
      GoRoute(
        path: Routes.diaryComments,
        builder: (_, state) =>
            CommentsScreen(diaryIdx: int.parse(state.pathParameters['idx']!), author: state.extra as String?),
      ),
    ],
  );
}
