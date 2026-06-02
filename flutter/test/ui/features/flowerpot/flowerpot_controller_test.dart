// FlowerpotController — 화분 로드 + 물주기/사랑주기 후 재조회(비낙관) (Provider/Notifier test, http_mock_adapter).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_controller.dart';
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

  Map<String, dynamic> flowerpotReply() => {
    'status': 'success',
    'resData': {'level': 1, 'exp': 200, 'max_exp': 1000, 'watering_count': 2, 'love_count': 1, 'showBadge': false},
  };

  setUp(() {
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('build 가 화분을 로드한다', () async {
    adapter.onGet('/flowerpot', (server) => server.reply(200, flowerpotReply()));
    final container = makeContainer();
    final f = await container.read(flowerpotControllerProvider.future);
    expect(f.level, 1);
    expect(f.wateringCount, 2);
  });

  test('water 가 물주기 후 화분을 재조회한다(비낙관)', () async {
    adapter
      ..onGet('/flowerpot', (server) => server.reply(200, flowerpotReply()))
      ..onPost(
        '/flowerpot/watering',
        (server) => server.reply(200, {'status': 'success', 'resData': 'ok'}),
        data: Matchers.any,
      );
    final container = makeContainer();
    await container.read(flowerpotControllerProvider.future);
    await container.read(flowerpotControllerProvider.notifier).water();
    final after = await container.read(flowerpotControllerProvider.future);
    expect(after.level, 1);
  });

  test('love 가 사랑주기 후 화분을 재조회한다', () async {
    adapter
      ..onGet('/flowerpot', (server) => server.reply(200, flowerpotReply()))
      ..onPost(
        '/flowerpot/love',
        (server) => server.reply(200, {'status': 'success', 'resData': 'ok'}),
        data: Matchers.any,
      );
    final container = makeContainer();
    await container.read(flowerpotControllerProvider.future);
    await container.read(flowerpotControllerProvider.notifier).love();
    final after = await container.read(flowerpotControllerProvider.future);
    expect(after.loveCount, 1);
  });
}
