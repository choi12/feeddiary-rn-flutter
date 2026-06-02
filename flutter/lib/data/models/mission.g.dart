// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Mission _$MissionFromJson(Map<String, dynamic> json) => _Mission(
  idx: (json['idx'] as num).toInt(),
  type: $enumDecode(_$MissionTypeEnumMap, json['type']),
  count: (json['count'] as num).toInt(),
  maxCount: (json['max_count'] as num).toInt(),
  isCompleted: boolFromInt((json['is_completed'] as num).toInt()),
);

Map<String, dynamic> _$MissionToJson(_Mission instance) => <String, dynamic>{
  'idx': instance.idx,
  'type': _$MissionTypeEnumMap[instance.type]!,
  'count': instance.count,
  'max_count': instance.maxCount,
  'is_completed': intFromBool(instance.isCompleted),
};

const _$MissionTypeEnumMap = {
  MissionType.diary: 'diary',
  MissionType.comment: 'comment',
  MissionType.visible: 'visible',
  MissionType.like: 'like',
};

_MissionsResult _$MissionsResultFromJson(Map<String, dynamic> json) => _MissionsResult(
  completed: (json['completed'] as List<dynamic>).map((e) => Mission.fromJson(e as Map<String, dynamic>)).toList(),
  inProgress: (json['inProgress'] as List<dynamic>).map((e) => Mission.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$MissionsResultToJson(_MissionsResult instance) => <String, dynamic>{
  'completed': instance.completed,
  'inProgress': instance.inProgress,
};

_RewardItem _$RewardItemFromJson(Map<String, dynamic> json) =>
    _RewardItem(count: (json['count'] as num).toInt(), item: $enumDecode(_$PlantActionEnumMap, json['item']));

Map<String, dynamic> _$RewardItemToJson(_RewardItem instance) => <String, dynamic>{
  'count': instance.count,
  'item': _$PlantActionEnumMap[instance.item]!,
};

const _$PlantActionEnumMap = {PlantAction.watering: 'watering', PlantAction.love: 'love'};

_CompleteMissionResult _$CompleteMissionResultFromJson(Map<String, dynamic> json) => _CompleteMissionResult(
  missions: MissionsResult.fromJson(json['missions'] as Map<String, dynamic>),
  reward: RewardItem.fromJson(json['reward'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CompleteMissionResultToJson(_CompleteMissionResult instance) => <String, dynamic>{
  'missions': instance.missions,
  'reward': instance.reward,
};
