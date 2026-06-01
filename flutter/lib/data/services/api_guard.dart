// API 호출 가드 — DioException 을 도메인 에러로 언랩하고 operation 컨텍스트를 덧붙임. RN formatAPIError 대응.
import 'package:dio/dio.dart';
import 'package:feeddiary/config/api_config.dart';
import 'package:feeddiary/config/error_messages.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';

/// repository 호출을 감싸 에러를 [AppException]으로 정규화한다.
///
/// - ErrorInterceptor 가 DioException.error 에 실어둔 [AppException]을 꺼내 [operation] 라벨을 붙인다.
/// - [UnauthorizedException]만은 라벨 없이 그대로 통과시킨다(신규 유저 분기 등 타입 식별용 — RN APISignIn 패턴).
Future<T> guardApiCall<T>(String operation, Future<T> Function() body) async {
  try {
    return await body();
  } on DioException catch (e) {
    final mapped = e.error is AppException ? e.error! as AppException : NetworkException(cause: e);
    if (mapped is UnauthorizedException) {
      throw mapped;
    }
    throw mapped.withOperation(operation);
  } on AppException catch (e) {
    if (e is UnauthorizedException) {
      rethrow;
    }
    throw e.withOperation(operation);
  } catch (e) {
    throw ApiException(
      statusCode: ApiConfig.serverError,
      message: ErrorMessages.defaultMessage,
      cause: e,
    ).withOperation(operation);
  }
}
