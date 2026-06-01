// 도메인 에러 한국어 메시지 — RN constants/api/errorMessage 대응.

/// 도메인 에러 사용자 메시지. RN `ERROR_MESSAGES`.
abstract final class ErrorMessages {
  static const String defaultMessage = '문제가 발생했습니다. 잠시 후 다시 시도해 주세요.';
  static const String network = '인터넷 연결을 확인해 주세요.';
  static const String timeout = '요청 시간이 초과되었습니다. 다시 시도해 주세요.';
  static const String unauthorized = '계정 정보를 확인해 주세요.';
  static const String conflict = '이미 존재하는 리소스입니다.';
  static const String serverError = '서버 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.';
}
