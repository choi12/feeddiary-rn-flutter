// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyDiary _$MyDiaryFromJson(Map<String, dynamic> json) => _MyDiary(
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
);

Map<String, dynamic> _$MyDiaryToJson(_MyDiary instance) => <String, dynamic>{
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
};

_DailyDiary _$DailyDiaryFromJson(Map<String, dynamic> json) => _DailyDiary(
  idx: (json['idx'] as num).toInt(),
  sticker: json['sticker'] as String,
  text: json['text'] as String,
  image: json['image'] as String?,
  createdAt: DateTime.parse(json['created_time'] as String),
  updatedAt: json['updated_time'] == null ? null : DateTime.parse(json['updated_time'] as String),
  isVisible: boolFromInt((json['is_visible'] as num).toInt()),
);

Map<String, dynamic> _$DailyDiaryToJson(_DailyDiary instance) => <String, dynamic>{
  'idx': instance.idx,
  'sticker': instance.sticker,
  'text': instance.text,
  'image': instance.image,
  'created_time': instance.createdAt.toIso8601String(),
  'updated_time': instance.updatedAt?.toIso8601String(),
  'is_visible': intFromBool(instance.isVisible),
};

_CreateDiaryResult _$CreateDiaryResultFromJson(Map<String, dynamic> json) =>
    _CreateDiaryResult(diaryIdx: (json['diaryIdx'] as num).toInt());

Map<String, dynamic> _$CreateDiaryResultToJson(_CreateDiaryResult instance) => <String, dynamic>{
  'diaryIdx': instance.diaryIdx,
};

_LikeResult _$LikeResultFromJson(Map<String, dynamic> json) =>
    _LikeResult(likeCount: (json['like_count'] as num).toInt(), isLike: json['isLike'] as bool);

Map<String, dynamic> _$LikeResultToJson(_LikeResult instance) => <String, dynamic>{
  'like_count': instance.likeCount,
  'isLike': instance.isLike,
};
