// FlowerpotRepository — 화분 조회/물주기/사랑주기 + operation 라벨 (Provider/Notifier test, http_mock_adapter).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/repositories/flowerpot_repository.dart';
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

  FlowerpotRepository makeRepo() {
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    return container.read(flowerpotRepositoryProvider);
  }

  setUp(() {
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('getFlowerpot 가 화분을 파싱한다', () async {
    adapter.onGet(
      '/flowerpot',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': {'level': 2, 'exp': 400, 'max_exp': 1000, 'watering_count': 3, 'love_count': 1, 'showBadge': true},
      }),
    );
    final f = await makeRepo().getFlowerpot();
    expect(f.level, 2);
    expect(f.wateringCount, 3);
  });

  test('wateringPlant / lovePlant 가 정상 완료된다', () async {
    adapter
      ..onPost(
        '/flowerpot/watering',
        (server) => server.reply(200, {'status': 'success', 'resData': 'ok'}),
        data: Matchers.any,
      )
      ..onPost(
        '/flowerpot/love',
        (server) => server.reply(200, {'status': 'success', 'resData': 'ok'}),
        data: Matchers.any,
      );
    await expectLater(makeRepo().wateringPlant(), completes);
    await expectLater(makeRepo().lovePlant(), completes);
  });

  test('서버 에러는 operation 라벨이 붙은 ApiException', () async {
    adapter.onGet('/flowerpot', (server) => server.reply(500, {'message': '서버 오류'}));
    await expectLater(
      makeRepo().getFlowerpot(),
      throwsA(isA<ApiException>().having((e) => e.displayMessage, 'displayMessage', startsWith('[나의 화분]'))),
    );
  });
}
