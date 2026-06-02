// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 int get idx; String get account;@JsonKey(name: 'user_id') String get userId; String get nickname; String get image; String get background; String get character; SignInType get type;@JsonKey(name: 'created_time') DateTime get createdAt; String get token;@JsonKey(name: 'fcm_token') String? get fcmToken;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.idx, idx) || other.idx == idx)&&(identical(other.account, account) || other.account == account)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.image, image) || other.image == image)&&(identical(other.background, background) || other.background == background)&&(identical(other.character, character) || other.character == character)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.token, token) || other.token == token)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idx,account,userId,nickname,image,background,character,type,createdAt,token,fcmToken);

@override
String toString() {
  return 'User(idx: $idx, account: $account, userId: $userId, nickname: $nickname, image: $image, background: $background, character: $character, type: $type, createdAt: $createdAt, token: $token, fcmToken: $fcmToken)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 int idx, String account,@JsonKey(name: 'user_id') String userId, String nickname, String image, String background, String character, SignInType type,@JsonKey(name: 'created_time') DateTime createdAt, String token,@JsonKey(name: 'fcm_token') String? fcmToken
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idx = null,Object? account = null,Object? userId = null,Object? nickname = null,Object? image = null,Object? background = null,Object? character = null,Object? type = null,Object? createdAt = null,Object? token = null,Object? fcmToken = freezed,}) {
  return _then(_self.copyWith(
idx: null == idx ? _self.idx : idx // ignore: cast_nullable_to_non_nullable
as int,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SignInType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idx,  String account, @JsonKey(name: 'user_id')  String userId,  String nickname,  String image,  String background,  String character,  SignInType type, @JsonKey(name: 'created_time')  DateTime createdAt,  String token, @JsonKey(name: 'fcm_token')  String? fcmToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.idx,_that.account,_that.userId,_that.nickname,_that.image,_that.background,_that.character,_that.type,_that.createdAt,_that.token,_that.fcmToken);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idx,  String account, @JsonKey(name: 'user_id')  String userId,  String nickname,  String image,  String background,  String character,  SignInType type, @JsonKey(name: 'created_time')  DateTime createdAt,  String token, @JsonKey(name: 'fcm_token')  String? fcmToken)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.idx,_that.account,_that.userId,_that.nickname,_that.image,_that.background,_that.character,_that.type,_that.createdAt,_that.token,_that.fcmToken);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idx,  String account, @JsonKey(name: 'user_id')  String userId,  String nickname,  String image,  String background,  String character,  SignInType type, @JsonKey(name: 'created_time')  DateTime createdAt,  String token, @JsonKey(name: 'fcm_token')  String? fcmToken)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.idx,_that.account,_that.userId,_that.nickname,_that.image,_that.background,_that.character,_that.type,_that.createdAt,_that.token,_that.fcmToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({required this.idx, required this.account, @JsonKey(name: 'user_id') required this.userId, required this.nickname, required this.image, required this.background, required this.character, required this.type, @JsonKey(name: 'created_time') required this.createdAt, required this.token, @JsonKey(name: 'fcm_token') this.fcmToken});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  int idx;
@override final  String account;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String nickname;
@override final  String image;
@override final  String background;
@override final  String character;
@override final  SignInType type;
@override@JsonKey(name: 'created_time') final  DateTime createdAt;
@override final  String token;
@override@JsonKey(name: 'fcm_token') final  String? fcmToken;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.idx, idx) || other.idx == idx)&&(identical(other.account, account) || other.account == account)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.image, image) || other.image == image)&&(identical(other.background, background) || other.background == background)&&(identical(other.character, character) || other.character == character)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.token, token) || other.token == token)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idx,account,userId,nickname,image,background,character,type,createdAt,token,fcmToken);

@override
String toString() {
  return 'User(idx: $idx, account: $account, userId: $userId, nickname: $nickname, image: $image, background: $background, character: $character, type: $type, createdAt: $createdAt, token: $token, fcmToken: $fcmToken)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 int idx, String account,@JsonKey(name: 'user_id') String userId, String nickname, String image, String background, String character, SignInType type,@JsonKey(name: 'created_time') DateTime createdAt, String token,@JsonKey(name: 'fcm_token') String? fcmToken
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idx = null,Object? account = null,Object? userId = null,Object? nickname = null,Object? image = null,Object? background = null,Object? character = null,Object? type = null,Object? createdAt = null,Object? token = null,Object? fcmToken = freezed,}) {
  return _then(_User(
idx: null == idx ? _self.idx : idx // ignore: cast_nullable_to_non_nullable
as int,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SignInType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
