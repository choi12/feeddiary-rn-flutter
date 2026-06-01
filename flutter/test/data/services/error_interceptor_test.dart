// ErrorInterceptor — DioException 을 도메인 AppException 으로 변환하는지 (http_mock_adapter).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/services/dio_interceptors.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://test.local'));
    dio.interceptors.add(const ErrorInterceptor());
    adapter = DioAdapter(dio: dio);
  });

  Future<AppException> captureError(String path) async {
    try {
      await dio.get<dynamic>(path);
      fail('에러가 발생해야 한다');
    } on DioException catch (e) {
      return e.error! as AppException;
    }
  }

  test('401 → UnauthorizedException', () async {
    adapter.onGet('/401', (server) => server.reply(401, {'message': '인증 실패'}));
    expect(await captureError('/401'), isA<UnauthorizedException>());
  });

  test('409 → ConflictException', () async {
    adapter.onGet('/409', (server) => server.reply(409, {'message': '중복'}));
    expect(await captureError('/409'), isA<ConflictException>());
  });

  test('500 → ApiException(서버 메시지 보존)', () async {
    adapter.onGet('/500', (server) => server.reply(500, {'message': '서버 오류 발생'}));
    final e = await captureError('/500');
    expect(e, isA<ApiException>());
    expect((e as ApiException).statusCode, 500);
    expect(e.message, '서버 오류 발생');
  });

  test('연결 에러 → NetworkException', () async {
    adapter.onGet(
      '/network',
      (server) => server.throws(
        0,
        DioException.connectionError(
          requestOptions: RequestOptions(path: '/network'),
          reason: 'no internet',
        ),
      ),
    );
    expect(await captureError('/network'), isA<NetworkException>());
  });

  test('타임아웃 → RequestTimeoutException', () async {
    adapter.onGet(
      '/timeout',
      (server) => server.throws(
        0,
        DioException.receiveTimeout(
          timeout: const Duration(seconds: 1),
          requestOptions: RequestOptions(path: '/timeout'),
        ),
      ),
    );
    expect(await captureError('/timeout'), isA<RequestTimeoutException>());
  });
}
