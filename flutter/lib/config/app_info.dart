// 앱 메타 정보 — 현재 앱 버전 상수. AppVersion 화면이 서버 최신 버전과 비교한다.

/// 빌드된 앱의 현재 버전. `pubspec.yaml`의 `version:`(현재 1.0.0+1)을 미러한다.
///
/// package_info_plus(네이티브 플러그인) 대신 상수로 두어 의존성을 줄였다. 값은 pubspec 와
/// 수동 동기화하며, RN `getVersion()`(앱 빌드 버전)에 대응한다.
abstract final class AppInfo {
  /// 현재 앱 버전(semver). pubspec `version` 의 build 번호(+1)는 제외한 표기용 버전.
  static const String version = '1.0.0';
}
