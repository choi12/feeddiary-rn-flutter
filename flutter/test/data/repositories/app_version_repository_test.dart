// AppVersionRepository / latestAppVersionProvider — ProviderContainer + overrideWith + http_mock_adapter.
import 'package:dio/dio.dart';
import 'package:feeddiary/data/repositories/app_version_repository.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;

  ProviderContainer makeContainer() {
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    // dioProvider 와 동일 구성(인터셉터 포함)으로 빌드 후 mock 어댑터 부착 — 에러 매핑까지 실경로로 검증.
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('성공 시 envelope 를 언랩해 버전 문자열을 반환한다', () async {
    adapter.onGet(
      '/etc/app-version',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': {'app_version_android': '2.0.0', 'app_version_ios': '2.0.1'},
      }),
    );
    final container = makeContainer();
    final version = await container.read(latestAppVersionProvider.future);
    // 테스트는 호스트 플랫폼에서 도므로 두 값 중 하나면 통과.
    expect(['2.0.0', '2.0.1'], contains(version));
  });

  test('에러 시 operation 라벨이 붙은 AppException 으로 변환된다', () async {
    adapter.onGet('/etc/app-version', (server) => server.reply(500, {'message': '서버 오류'}));
    final container = makeContainer();
    await expectLater(
      container.read(latestAppVersionProvider.future),
      throwsA(isA<ApiException>().having((e) => e.displayMessage, 'displayMessage', startsWith('[앱 버전]'))),
    );
  });

  test('401 은 operation 라벨 없이 UnauthorizedException 으로 통과한다', () async {
    adapter.onGet('/etc/app-version', (server) => server.reply(401, {'message': '인증 실패'}));
    final container = makeContainer();
    await expectLater(
      container.read(latestAppVersionProvider.future),
      throwsA(isA<UnauthorizedException>().having((e) => e.operation, 'operation', isNull)),
    );
  });
}
