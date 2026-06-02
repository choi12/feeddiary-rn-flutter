// MissionRepository — 미션 목록/완료 + operation 라벨 (Provider/Notifier test, http_mock_adapter).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/repositories/mission_repository.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/domain/models/mission_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;

  MissionRepository makeRepo() {
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    return container.read(missionRepositoryProvider);
  }

  setUp(() {
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('getMissions 가 진행중/완료를 파싱한다', () async {
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
    final result = await makeRepo().getMissions();
    expect(result.inProgress.length, 1);
    expect(result.inProgress.first.type, MissionType.diary);
  });

  test('completeMission 이 보상과 갱신 미션을 반환한다', () async {
    adapter.onPost(
      '/mission',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': {
          'missions': {'completed': <dynamic>[], 'inProgress': <dynamic>[]},
          'reward': {'count': 2, 'item': 'watering'},
        },
      }),
      data: Matchers.any,
    );
    final result = await makeRepo().completeMission(missionIdx: 3, type: MissionType.visible);
    expect(result.reward.item, PlantAction.watering);
    expect(result.reward.count, 2);
  });

  test('서버 에러는 operation 라벨이 붙은 ApiException', () async {
    adapter.onGet('/mission/list', (server) => server.reply(500, {'message': '서버 오류'}));
    await expectLater(
      makeRepo().getMissions(),
      throwsA(isA<ApiException>().having((e) => e.displayMessage, 'displayMessage', startsWith('[미션 리스트]'))),
    );
  });
}
