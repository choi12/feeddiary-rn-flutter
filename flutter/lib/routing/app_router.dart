// GoRouter 설정 — AuthState 기반 redirect + 인증/일기 라우트(splash/signIn/createProfile/home/diary). (Riverpod 코드젠)
import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/routing/extra_codec.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/features/auth/create_profile_screen.dart';
import 'package:feeddiary/ui/features/auth/sign_in_screen.dart';
import 'package:feeddiary/ui/features/auth/splash_screen.dart';
import 'package:feeddiary/ui/features/community/comments_screen.dart';
import 'package:feeddiary/ui/features/community/report_screen.dart';
import 'package:feeddiary/ui/features/diary/create_diary_screen.dart';
import 'package:feeddiary/ui/features/diary/diary_detail_screen.dart';
import 'package:feeddiary/ui/features/flowerpot/mission_screen.dart';
import 'package:feeddiary/ui/features/home/main_shell.dart';
import 'package:feeddiary/ui/features/letter/create_letter_screen.dart';
import 'package:feeddiary/ui/features/setting/app_version_screen.dart';
import 'package:feeddiary/ui/features/setting/license_screen.dart';
import 'package:feeddiary/ui/features/setting/lock_password_screen.dart';
import 'package:feeddiary/ui/features/setting/lockdown_settings_screen.dart';
import 'package:feeddiary/ui/features/setting/update_profile_screen.dart';
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
    // 웹 뒤로/앞으로 가기로 복원되는 extra 를 원래 타입으로 되돌린다(없으면 Map 이 와서 캐스팅이 깨짐).
    extraCodec: const ExtraCodec(),
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
      GoRoute(
        path: Routes.report,
        builder: (_, state) => ReportScreen(diaryIdx: int.parse(state.pathParameters['idx']!)),
      ),
      GoRoute(path: Routes.mission, builder: (_, _) => const MissionScreen()),
      GoRoute(path: Routes.letterWrite, builder: (_, _) => const CreateLetterScreen()),
      GoRoute(path: Routes.settingProfile, builder: (_, _) => const UpdateProfileScreen()),
      GoRoute(path: Routes.settingLicense, builder: (_, _) => const LicenseScreen()),
      GoRoute(path: Routes.settingAppVersion, builder: (_, _) => const AppVersionScreen()),
      GoRoute(path: Routes.settingLockdown, builder: (_, _) => const LockdownSettingsScreen()),
      GoRoute(path: Routes.settingLockPassword, builder: (_, _) => const LockPasswordScreen()),
    ],
  );
}
