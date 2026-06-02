// 게임 루프 교차 무효화 — 좋아요 토글이 미션·화분을 무효화해 재조회시키는지 (Provider/Notifier test). RN invalidateQueries MISSION_GROUP.
import 'package:feeddiary/data/models/flowerpot.dart';
import 'package:feeddiary/data/models/mission.dart';
import 'package:feeddiary/data/repositories/flowerpot_repository.dart';
import 'package:feeddiary/data/repositories/mission_repository.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/models/mission_type.dart';
import 'package:feeddiary/ui/features/community/diary_likes.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_controller.dart';
import 'package:feeddiary/ui/features/flowerpot/mission_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

/// getFlowerpot 호출 수를 세는 가짜 저장소(무효화→재조회 증명용).
class _CountingFlowerpotRepository implements FlowerpotRepository {
  int getCalls = 0;

  @override
  Future<Flowerpot> getFlowerpot() async {
    getCalls++;
    return const Flowerpot(level: 1, exp: 0, maxExp: 1000, wateringCount: 1, loveCount: 1, showBadge: false);
  }

  @override
  Future<void> wateringPlant() async {}

  @override
  Future<void> lovePlant() async {}
}

/// getMissions 호출 수를 세는 가짜 저장소.
class _CountingMissionRepository implements MissionRepository {
  int getCalls = 0;

  @override
  Future<MissionsResult> getMissions() async {
    getCalls++;
    return const MissionsResult(completed: [], inProgress: []);
  }

  @override
  Future<CompleteMissionResult> completeMission({required int missionIdx, required MissionType type}) =>
      throw UnimplementedError();
}

void main() {
  test('좋아요 토글이 미션·화분을 교차 무효화해 재조회한다', () async {
    final dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    final adapter = DioAdapter(dio: dio);
    adapter.onPost(
      '/diary/like',
      (server) => server.reply(200, {
        'status': 'success',
        'resData': {'like_count': 1, 'isLike': true},
      }),
      data: Matchers.any,
    );

    final flowerpotRepo = _CountingFlowerpotRepository();
    final missionRepo = _CountingMissionRepository();
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        dioProvider.overrideWithValue(dio),
        flowerpotRepositoryProvider.overrideWithValue(flowerpotRepo),
        missionRepositoryProvider.overrideWithValue(missionRepo),
      ],
    );
    addTearDown(container.dispose);

    // 초기 로드.
    await container.read(flowerpotControllerProvider.future);
    await container.read(missionsControllerProvider.future);
    expect(flowerpotRepo.getCalls, 1);
    expect(missionRepo.getCalls, 1);

    // 좋아요 토글 → missions·flowerpot invalidate(게임 루프 교차).
    await container.read(diaryLikesProvider.notifier).toggle(idx: 1, baseIsLike: false, baseLikeCount: 0);

    // 무효화로 재조회되어 호출 수가 늘어난다.
    await container.read(flowerpotControllerProvider.future);
    await container.read(missionsControllerProvider.future);
    expect(flowerpotRepo.getCalls, 2);
    expect(missionRepo.getCalls, 2);
  });
}
