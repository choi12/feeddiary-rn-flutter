// 앱 환경 설정 — --dart-define-from-file 로 주입된 컴파일타임 상수를 typed 로 노출.

/// 빌드 시 `--dart-define-from-file=config/<env>.json` 으로 주입되는 환경값.
///
/// RN `react-native-config`(env/.env.*)의 Flutter 대응. 모든 값은 컴파일타임 const라
/// 트리셰이킹되며, 무인자(`flutter test`)에서도 fromEnvironment 의 기본값으로 동작한다.
abstract final class AppConfig {
  /// 실행 환경. `DEVELOPMENT`(mock 데모) 또는 `PRODUCTION`.
  static const String appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'DEVELOPMENT');

  /// mock 데모 모드 여부. true면 네트워크 경계를 mock 으로 가로챈다(키 없이 실행).
  static const bool useMock = bool.fromEnvironment('USE_MOCK', defaultValue: true);

  /// API 서버 base URL.
  static const String apiServer = String.fromEnvironment('API_SERVER', defaultValue: 'https://mock.example.com');

  /// 문의 메일 주소.
  static const String emailAddress = String.fromEnvironment('EMAIL_ADDRESS', defaultValue: 'demo@example.com');

  /// Sentry DSN. 비어 있으면 비활성(데모/테스트).
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN', defaultValue: '');

  /// 개발(mock) 환경 여부.
  static bool get isDevelopment => appEnv == 'DEVELOPMENT';
}
