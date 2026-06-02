// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  idx: (json['idx'] as num).toInt(),
  account: json['account'] as String,
  userId: json['user_id'] as String,
  nickname: json['nickname'] as String,
  image: json['image'] as String,
  background: json['background'] as String,
  character: json['character'] as String,
  type: $enumDecode(_$SignInTypeEnumMap, json['type']),
  createdAt: DateTime.parse(json['created_time'] as String),
  token: json['token'] as String,
  fcmToken: json['fcm_token'] as String?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'idx': instance.idx,
  'account': instance.account,
  'user_id': instance.userId,
  'nickname': instance.nickname,
  'image': instance.image,
  'background': instance.background,
  'character': instance.character,
  'type': _$SignInTypeEnumMap[instance.type]!,
  'created_time': instance.createdAt.toIso8601String(),
  'token': instance.token,
  'fcm_token': instance.fcmToken,
};

const _$SignInTypeEnumMap = {SignInType.google: 'google', SignInType.apple: 'apple'};
