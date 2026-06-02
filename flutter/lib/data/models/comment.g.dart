// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Comment _$CommentFromJson(Map<String, dynamic> json) => _Comment(
  idx: (json['idx'] as num).toInt(),
  nickname: json['nickname'] as String,
  background: json['background'] as String,
  character: json['character'] as String,
  text: json['text'] as String,
  createdAt: DateTime.parse(json['created_time'] as String),
  userImage: json['user_image'] as String,
);

Map<String, dynamic> _$CommentToJson(_Comment instance) => <String, dynamic>{
  'idx': instance.idx,
  'nickname': instance.nickname,
  'background': instance.background,
  'character': instance.character,
  'text': instance.text,
  'created_time': instance.createdAt.toIso8601String(),
  'user_image': instance.userImage,
};
