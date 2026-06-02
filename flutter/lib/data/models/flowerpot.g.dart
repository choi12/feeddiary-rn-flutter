// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flowerpot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Flowerpot _$FlowerpotFromJson(Map<String, dynamic> json) => _Flowerpot(
  level: (json['level'] as num).toInt(),
  exp: (json['exp'] as num).toInt(),
  maxExp: (json['max_exp'] as num).toInt(),
  wateringCount: (json['watering_count'] as num).toInt(),
  loveCount: (json['love_count'] as num).toInt(),
  showBadge: json['showBadge'] as bool,
);

Map<String, dynamic> _$FlowerpotToJson(_Flowerpot instance) => <String, dynamic>{
  'level': instance.level,
  'exp': instance.exp,
  'max_exp': instance.maxExp,
  'watering_count': instance.wateringCount,
  'love_count': instance.loveCount,
  'showBadge': instance.showBadge,
};
