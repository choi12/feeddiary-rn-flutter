// 도메인 에러 계층 — 네트워크/HTTP 상태를 앱 도메인 언어로 정규화. RN types/errors.ts 대응.
import 'package:feeddiary/config/error_messages.dart';

/// 앱 전역 도메인 예외의 sealed 베이스. RN `BaseError` 계층 대응.
///
/// [operation]은 RN `formatAPIError`의 `[작업명]` 라벨에 해당하며, [withOperation]으로
/// 원본 타입을 유지한 채 컨텍스트를 덧붙인다(예외는 불변이라 새 인스턴스를 반환).
sealed class AppException implements Exception {
  const AppException({required this.message, this.operation, this.cause});

  /// 사용자에게 보여줄 도메인 메시지.
  final String message;

  /// 실패한 작업 라벨(예: `로그인`). RN formatAPIError 의 operation.
  final String? operation;

  /// 원본 에러(디버깅/로깅용). RN `originalError`.
  final Object? cause;

  /// 화면 표시용 메시지. operation 이 있으면 `[작업명] 메시지`.
  String get displayMessage => operation == null ? message : '[$operation] $message';

  /// 원본 타입을 유지한 채 [operation]을 덧붙인 새 인스턴스.
  AppException withOperation(String operation);

  @override
  String toString() => '$runtimeType: $displayMessage';
}

/// 네트워크 연결 실패. RN `NetworkError`.
final class NetworkException extends AppException {
  const NetworkException({super.operation, super.cause}) : super(message: ErrorMessages.network);

  @override
  NetworkException withOperation(String operation) => NetworkException(operation: operation, cause: cause);
}

/// 요청 시간 초과. RN `TimeoutError`(dart:async 의 TimeoutException 과 충돌 회피로 개명).
final class RequestTimeoutException extends AppException {
  const RequestTimeoutException({super.operation, super.cause}) : super(message: ErrorMessages.timeout);

  @override
  RequestTimeoutException withOperation(String operation) =>
      RequestTimeoutException(operation: operation, cause: cause);
}

/// 인증 실패(401). 신규 유저 분기 등에서 타입으로 식별. RN `UnauthorizedError`.
final class UnauthorizedException extends AppException {
  const UnauthorizedException({super.operation, super.cause}) : super(message: ErrorMessages.unauthorized);

  @override
  UnauthorizedException withOperation(String operation) => UnauthorizedException(operation: operation, cause: cause);
}

/// 리소스 충돌(409). RN `ConflictError`.
final class ConflictException extends AppException {
  const ConflictException({super.operation, super.cause}) : super(message: ErrorMessages.conflict);

  @override
  ConflictException withOperation(String operation) => ConflictException(operation: operation, cause: cause);
}

/// 그 외 HTTP 에러. [statusCode]와 서버 메시지를 보존. RN `APIError`.
final class ApiException extends AppException {
  const ApiException({required this.statusCode, required super.message, super.operation, super.cause});

  final int statusCode;

  @override
  ApiException withOperation(String operation) =>
      ApiException(statusCode: statusCode, message: message, operation: operation, cause: cause);
}
