// Dio 인터셉터 3종 — 토큰 주입·로깅·도메인 에러 변환. RN api/request.ts 인터셉터 대응.
import 'package:dio/dio.dart';
import 'package:feeddiary/config/api_config.dart';
import 'package:feeddiary/config/error_messages.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/utils/logger.dart';

/// 요청에 `Authorization: Bearer <token>` 헤더를 주입. RN 요청 인터셉터.
/// 토큰은 [TokenStorage]의 sync 캐시에서 읽는다(매 요청 async I/O 회피).
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenStorage.token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = '${ApiConfig.authPrefix} $token';
    }
    handler.next(options);
  }
}

/// 요청/응답/에러를 디버그 로그로 남긴다(디버그 빌드 전용).
class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.network('→ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    AppLogger.network('← ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.network('✗ ${err.requestOptions.uri} (${err.type.name})');
    handler.next(err);
  }
}

/// DioException 을 도메인 [AppException]으로 변환해 reject. RN 응답 인터셉터.
/// 변환된 예외는 DioException.error 에 실어 전파하고, repository 의 guardApiCall 이 언랩한다.
class ErrorInterceptor extends Interceptor {
  const ErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: _toAppException(err),
      ),
    );
  }

  AppException _toAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return RequestTimeoutException(cause: err);
      case DioExceptionType.badResponse:
        return _fromStatus(err);
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return NetworkException(cause: err);
    }
  }

  AppException _fromStatus(DioException err) {
    final status = err.response?.statusCode ?? ApiConfig.serverError;
    return switch (status) {
      ApiConfig.unauthorized => UnauthorizedException(cause: err),
      ApiConfig.conflict => ConflictException(cause: err),
      _ => ApiException(
        statusCode: status,
        message: _serverMessage(err.response?.data) ?? '[$status] ${ErrorMessages.defaultMessage}',
        cause: err,
      ),
    };
  }

  /// 서버가 내려준 에러 메시지를 안전하게 추출(비-JSON/빈 바디 대비). RN `data?.message`.
  String? _serverMessage(Object? data) {
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
  }
}
