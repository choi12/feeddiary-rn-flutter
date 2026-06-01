// API 통신 상수 — 타임아웃·HTTP 상태코드·헤더·페이지 크기. RN constants/api/config + ui/pagination 대응.

/// 네트워크 통신 상수. RN `API_CONFIG` + `ITEMS_PER_PAGE` 매핑.
abstract final class ApiConfig {
  /// 요청 타임아웃(연결/수신/송신 공통). RN `API_CONFIG.TIMEOUT`.
  static const Duration timeout = Duration(seconds: 8);

  /// 기본 Content-Type.
  static const String contentType = 'application/json';

  /// 인증 헤더 접두사.
  static const String authPrefix = 'Bearer';

  /// offset 페이지네이션 한 페이지 항목 수. RN `ITEMS_PER_PAGE`.
  static const int itemsPerPage = 10;

  // HTTP 상태코드 (도메인 에러 매핑에 사용) — RN `API_CONFIG.STATUS`.
  static const int unauthorized = 401;
  static const int conflict = 409;
  static const int serverError = 500;
}
