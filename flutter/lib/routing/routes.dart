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
}
