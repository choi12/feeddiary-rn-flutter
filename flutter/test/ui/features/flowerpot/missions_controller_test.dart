// MissionsController — 미션 로드 + 완료(보상 반환·서버 missions 로 state 교체) (Provider/Notifier test, http_mock_adapter).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/models/mission_type.dart';
import 'package:feeddiary/ui/features/flowerpot/mission_controller.dart';
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
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('build 가 미션 목록을 진행중/완료로 로드한다', () async {
    adapter.onGet(
      '/mission/list',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': {
          'completed': <dynamic>[],
          'inProgress': [
            {'idx': 1, 'type': 'diary', 'count': 1, 'max_count': 3, 'is_completed': 0},
          ],
        },
      }),
    );
    final container = makeContainer();
    final result = await container.read(missionsControllerProvider.future);
    expect(result.inProgress.length, 1);
    expect(result.inProgress.first.type, MissionType.diary);
  });

  test('complete 가 보상을 반환하고 서버 미션으로 state 를 교체한다', () async {
    adapter
      ..onGet(
        '/mission/list',
        (server) => server.reply(200, {
          'status': 'success',
          'resData': {
            'completed': <dynamic>[],
            'inProgress': [
              {'idx': 3, 'type': 'visible', 'count': 1, 'max_count': 1, 'is_completed': 0},
            ],
          },
        }),
      )
      ..onPost(
        '/mission',
        (server) => server.reply(200, {
          'status': 'success',
          'resData': {
            'missions': {
              'completed': [
                {'idx': 3, 'type': 'visible', 'count': 1, 'max_count': 1, 'is_completed': 1},
              ],
              'inProgress': <dynamic>[],
            },
            'reward': {'count': 1, 'item': 'watering'},
          },
        }),
        data: Matchers.any,
      );

    final container = makeContainer();
    await container.read(missionsControllerProvider.future);
    final reward = await container
        .read(missionsControllerProvider.notifier)
        .complete(missionIdx: 3, type: MissionType.visible);
    expect(reward.item, PlantAction.watering);
    expect(reward.count, 1);
    // 서버가 돌려준 missions 로 교체 — 진행중 비고 완료 1건.
    final state = container.read(missionsControllerProvider).value!;
    expect(state.inProgress, isEmpty);
    expect(state.completed.length, 1);
  });
}
