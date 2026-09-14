// 앱 라우트 경로 상수 — GoRouter 설정과 위젯이 공유.

/// GoRouter 경로. 화면이 늘면 여기에 추가한다.
abstract final class Routes {
  static const String splash = '/';
  static const String signIn = '/sign-in';
  static const String createProfile = '/create-profile';
  static const String home = '/home';

  /// 일기 작성/수정(생성=extra null, 수정=extra MyDiary). `diaryDetail`(:idx)보다 먼저 등록한다.
  static const String diaryWrite = '/diary/write';

  /// 일기 상세(:idx). 푸시 경로는 [diaryDetailPath].
  static const String diaryDetail = '/diary/:idx';

  /// 일기 상세 푸시 경로 생성. 예: `/diary/123`.
  static String diaryDetailPath(int idx) => '/diary/$idx';

  /// 일기 댓글(:idx). 푸시 경로는 [diaryCommentsPath].
  static const String diaryComments = '/diary/:idx/comments';

  /// 일기 댓글 푸시 경로 생성. 예: `/diary/123/comments`.
  static String diaryCommentsPath(int idx) => '/diary/$idx/comments';

  /// 일기 신고/차단(:idx). 푸시 경로는 [reportPath]. RN community `Report` 화면.
  static const String report = '/report/:idx';

  /// 일기 신고 푸시 경로 생성. 예: `/report/123`.
  static String reportPath(int idx) => '/report/$idx';

  /// 오늘의 미션(화분 화면에서 push). 파라미터 없음.
  static const String mission = '/mission';

  /// 편지 작성(편지함에서 push). 파라미터 없음.
  static const String letterWrite = '/letter/write';

  /// 프로필 수정(설정에서 push). 파라미터 없음.
  static const String settingProfile = '/settings/profile';

  /// 라이선스(설정에서 push). 파라미터 없음.
  static const String settingLicense = '/settings/license';

  /// 앱 버전 정보(설정에서 push). 파라미터 없음.
  static const String settingAppVersion = '/settings/app-version';

  /// 잠금 설정(설정에서 push). 파라미터 없음.
  static const String settingLockdown = '/settings/lockdown';

  /// 잠금 비밀번호 설정(잠금 설정에서 push). 파라미터 없음.
  static const String settingLockPassword = '/settings/lockdown/password';
}
