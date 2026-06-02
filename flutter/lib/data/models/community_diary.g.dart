// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_diary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommunityDiary _$CommunityDiaryFromJson(Map<String, dynamic> json) => _CommunityDiary(
  idx: (json['idx'] as num).toInt(),
  userIdx: (json['user_idx'] as num).toInt(),
  nickname: json['nickname'] as String,
  sticker: json['sticker'] as String,
  text: json['text'] as String,
  image: json['image'] as String?,
  createdAt: DateTime.parse(json['created_time'] as String),
  updatedAt: json['updated_time'] == null ? null : DateTime.parse(json['updated_time'] as String),
  isVisible: boolFromInt((json['is_visible'] as num).toInt()),
  likeCount: (json['like_count'] as num).toInt(),
  commentCount: (json['commentCount'] as num).toInt(),
  userImage: json['user_image'] as String,
  background: json['background'] as String,
  character: json['character'] as String,
  isLike: json['isLike'] as bool,
);

Map<String, dynamic> _$CommunityDiaryToJson(_CommunityDiary instance) => <String, dynamic>{
  'idx': instance.idx,
  'user_idx': instance.userIdx,
  'nickname': instance.nickname,
  'sticker': instance.sticker,
  'text': instance.text,
  'image': instance.image,
  'created_time': instance.createdAt.toIso8601String(),
  'updated_time': instance.updatedAt?.toIso8601String(),
  'is_visible': intFromBool(instance.isVisible),
  'like_count': instance.likeCount,
  'commentCount': instance.commentCount,
  'user_image': instance.userImage,
  'background': instance.background,
  'character': instance.character,
  'isLike': instance.isLike,
};
