// 미션 컨트롤러 — 미션 서버상태(keepAlive) + 미션 완료(비낙관, 보상 반환). RN useMissions+useCompleteMission 대응.
import 'package:feeddiary/data/models/mission.dart';
import 'package:feeddiary/data/repositories/mission_repository.dart';
import 'package:feeddiary/domain/models/mission_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mission_controller.g.dart';

/// 미션 목록(진행중/완료). 본인 액션으로만 변하므로 keepAlive 로 유지한다(RN INDEPENDENT_QUERY_CONFIG).
/// 진행중/완료 탭 선택·자동 전환은 화면 로컬 setState 가 담당한다(RN useMissions 의 useState).
@Riverpod(keepAlive: true)
class MissionsController extends _$MissionsController {
  @override
  Future<MissionsResult> build() {
    return ref.watch(missionRepositoryProvider).getMissions();
  }

  /// 미션 완료(보상 받기). 서버가 돌려준 최신 미션 묶음으로 state 를 교체하고(비낙관·재조회 절약) 보상을 반환한다.
  /// 화면은 반환된 [RewardItem]으로 보상 모달을 띄운다. 중복 호출 방지는 호출부(버튼 비활성)에서 처리. RN useCompleteMission.
  Future<RewardItem> complete({required int missionIdx, required MissionType type}) async {
    final result = await ref.read(missionRepositoryProvider).completeMission(missionIdx: missionIdx, type: type);
    state = AsyncData(result.missions);
    return result.reward;
  }
}
