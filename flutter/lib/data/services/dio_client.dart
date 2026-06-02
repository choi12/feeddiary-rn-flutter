// Dio HTTP 클라이언트 — BaseOptions + 인터셉터 조립 후 provider 로 노출. RN api/request.ts 대응.
import 'package:dio/dio.dart';
import 'package:feeddiary/config/api_config.dart';
import 'package:feeddiary/config/app_config.dart';
import 'package:feeddiary/data/services/demo_api_adapter.dart';
import 'package:feeddiary/data/services/dio_interceptors.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

/// 공용 [Dio] 인스턴스를 만든다. 인터셉터 순서: 토큰 주입 → 로깅(디버그) → 도메인 에러 변환.
/// (테스트는 이 함수로 동일 구성의 Dio 를 만들고 mock 어댑터를 부착한다.)
Dio buildDio(TokenStorage tokenStorage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiServer,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      sendTimeout: ApiConfig.timeout,
      headers: {Headers.contentTypeHeader: ApiConfig.contentType},
    ),
  );
  dio.interceptors.addAll([
    AuthInterceptor(tokenStorage),
    if (kDebugMode) const LoggingInterceptor(),
    const ErrorInterceptor(),
  ]);
  return dio;
}

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = buildDio(ref.watch(tokenStorageProvider));
  // 데모 모드: 네트워크 경계를 mock 어댑터로 교체(키 없이 실행). 테스트는 dioProvider 를 override 하므로 무관.
  if (AppConfig.useMock) {
    dio.httpClientAdapter = DemoApiAdapter();
  }
  return dio;
}
