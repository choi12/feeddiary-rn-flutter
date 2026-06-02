// 미션 도메인 모델 — 미션·진행/완료 묶음·보상·완료 결과. RN api/mission/types 대응.
import 'package:feeddiary/data/models/json_converters.dart';
import 'package:feeddiary/domain/models/mission_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission.freezed.dart';
part 'mission.g.dart';

/// 미션 한 건. is_completed 0/1 정수를 bool 로 매핑(boolFromInt 재사용)하고 max_count→maxCount. RN `MissionDTO`.
@freezed
abstract class Mission with _$Mission {
  const factory Mission({
    required int idx,
    required MissionType type,
    required int count,
    @JsonKey(name: 'max_count') required int maxCount,
    @JsonKey(name: 'is_completed', fromJson: boolFromInt, toJson: intFromBool) required bool isCompleted,
  }) = _Mission;

  const Mission._();

  factory Mission.fromJson(Map<String, dynamic> json) => _$MissionFromJson(json);

  /// 보상을 받을 수 있는 상태(진행도가 목표 도달). RN MissionBox `count === maxCount`.
  bool get isAchieved => count >= maxCount;
}

/// 진행중/완료로 분류된 미션 묶음. RN `MissionsDTO`.
@freezed
abstract class MissionsResult with _$MissionsResult {
  const factory MissionsResult({required List<Mission> completed, required List<Mission> inProgress}) = _MissionsResult;

  factory MissionsResult.fromJson(Map<String, dynamic> json) => _$MissionsResultFromJson(json);
}

/// 미션 완료 보상 아이템(물주기/사랑주기 충전). RN `RewardItem`.
@freezed
abstract class RewardItem with _$RewardItem {
  const factory RewardItem({required int count, required PlantAction item}) = _RewardItem;

  factory RewardItem.fromJson(Map<String, dynamic> json) => _$RewardItemFromJson(json);
}

/// 미션 완료 응답 — 갱신된 미션 묶음 + 받은 보상. RN `CompleteMissionResponse`.
@freezed
abstract class CompleteMissionResult with _$CompleteMissionResult {
  const factory CompleteMissionResult({required MissionsResult missions, required RewardItem reward}) =
      _CompleteMissionResult;

  factory CompleteMissionResult.fromJson(Map<String, dynamic> json) => _$CompleteMissionResultFromJson(json);
}
