// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Letter _$LetterFromJson(Map<String, dynamic> json) => _Letter(
  idx: (json['idx'] as num).toInt(),
  text: json['text'] as String,
  createdAt: DateTime.parse(json['created_time'] as String),
);

Map<String, dynamic> _$LetterToJson(_Letter instance) => <String, dynamic>{
  'idx': instance.idx,
  'text': instance.text,
  'created_time': instance.createdAt.toIso8601String(),
};
