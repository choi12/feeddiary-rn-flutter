// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_diary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommunityDiary {

 int get idx;@JsonKey(name: 'user_idx') int get userIdx; String get nickname; String get sticker; String get text; String? get image;@JsonKey(name: 'created_time') DateTime get createdAt;@JsonKey(name: 'updated_time') DateTime? get updatedAt;@JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) bool get isVisible;@JsonKey(name: 'like_count') int get likeCount; int get commentCount;@JsonKey(name: 'user_image') String get userImage; String get background; String get character; bool get isLike;
/// Create a copy of CommunityDiary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityDiaryCopyWith<CommunityDiary> get copyWith => _$CommunityDiaryCopyWithImpl<CommunityDiary>(this as CommunityDiary, _$identity);

  /// Serializes this CommunityDiary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunityDiary&&(identical(other.idx, idx) || other.idx == idx)&&(identical(other.userIdx, userIdx) || other.userIdx == userIdx)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.text, text) || other.text == text)&&(identical(other.image, image) || other.image == image)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.userImage, userImage) || other.userImage == userImage)&&(identical(other.background, background) || other.background == background)&&(identical(other.character, character) || other.character == character)&&(identical(other.isLike, isLike) || other.isLike == isLike));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idx,userIdx,nickname,sticker,text,image,createdAt,updatedAt,isVisible,likeCount,commentCount,userImage,background,character,isLike);

@override
String toString() {
  return 'CommunityDiary(idx: $idx, userIdx: $userIdx, nickname: $nickname, sticker: $sticker, text: $text, image: $image, createdAt: $createdAt, updatedAt: $updatedAt, isVisible: $isVisible, likeCount: $likeCount, commentCount: $commentCount, userImage: $userImage, background: $background, character: $character, isLike: $isLike)';
}


}

/// @nodoc
abstract mixin class $CommunityDiaryCopyWith<$Res>  {
  factory $CommunityDiaryCopyWith(CommunityDiary value, $Res Function(CommunityDiary) _then) = _$CommunityDiaryCopyWithImpl;
@useResult
$Res call({
 int idx,@JsonKey(name: 'user_idx') int userIdx, String nickname, String sticker, String text, String? image,@JsonKey(name: 'created_time') DateTime createdAt,@JsonKey(name: 'updated_time') DateTime? updatedAt,@JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) bool isVisible,@JsonKey(name: 'like_count') int likeCount, int commentCount,@JsonKey(name: 'user_image') String userImage, String background, String character, bool isLike
});




}
/// @nodoc
class _$CommunityDiaryCopyWithImpl<$Res>
    implements $CommunityDiaryCopyWith<$Res> {
  _$CommunityDiaryCopyWithImpl(this._self, this._then);

  final CommunityDiary _self;
  final $Res Function(CommunityDiary) _then;

/// Create a copy of CommunityDiary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idx = null,Object? userIdx = null,Object? nickname = null,Object? sticker = null,Object? text = null,Object? image = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? isVisible = null,Object? likeCount = null,Object? commentCount = null,Object? userImage = null,Object? background = null,Object? character = null,Object? isLike = null,}) {
  return _then(_self.copyWith(
idx: null == idx ? _self.idx : idx // ignore: cast_nullable_to_non_nullable
as int,userIdx: null == userIdx ? _self.userIdx : userIdx // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,sticker: null == sticker ? _self.sticker : sticker // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,userImage: null == userImage ? _self.userImage : userImage // ignore: cast_nullable_to_non_nullable
as String,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,isLike: null == isLike ? _self.isLike : isLike // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CommunityDiary].
extension CommunityDiaryPatterns on CommunityDiary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommunityDiary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommunityDiary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommunityDiary value)  $default,){
final _that = this;
switch (_that) {
case _CommunityDiary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommunityDiary value)?  $default,){
final _that = this;
switch (_that) {
case _CommunityDiary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idx, @JsonKey(name: 'user_idx')  int userIdx,  String nickname,  String sticker,  String text,  String? image, @JsonKey(name: 'created_time')  DateTime createdAt, @JsonKey(name: 'updated_time')  DateTime? updatedAt, @JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool)  bool isVisible, @JsonKey(name: 'like_count')  int likeCount,  int commentCount, @JsonKey(name: 'user_image')  String userImage,  String background,  String character,  bool isLike)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommunityDiary() when $default != null:
return $default(_that.idx,_that.userIdx,_that.nickname,_that.sticker,_that.text,_that.image,_that.createdAt,_that.updatedAt,_that.isVisible,_that.likeCount,_that.commentCount,_that.userImage,_that.background,_that.character,_that.isLike);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idx, @JsonKey(name: 'user_idx')  int userIdx,  String nickname,  String sticker,  String text,  String? image, @JsonKey(name: 'created_time')  DateTime createdAt, @JsonKey(name: 'updated_time')  DateTime? updatedAt, @JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool)  bool isVisible, @JsonKey(name: 'like_count')  int likeCount,  int commentCount, @JsonKey(name: 'user_image')  String userImage,  String background,  String character,  bool isLike)  $default,) {final _that = this;
switch (_that) {
case _CommunityDiary():
return $default(_that.idx,_that.userIdx,_that.nickname,_that.sticker,_that.text,_that.image,_that.createdAt,_that.updatedAt,_that.isVisible,_that.likeCount,_that.commentCount,_that.userImage,_that.background,_that.character,_that.isLike);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idx, @JsonKey(name: 'user_idx')  int userIdx,  String nickname,  String sticker,  String text,  String? image, @JsonKey(name: 'created_time')  DateTime createdAt, @JsonKey(name: 'updated_time')  DateTime? updatedAt, @JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool)  bool isVisible, @JsonKey(name: 'like_count')  int likeCount,  int commentCount, @JsonKey(name: 'user_image')  String userImage,  String background,  String character,  bool isLike)?  $default,) {final _that = this;
switch (_that) {
case _CommunityDiary() when $default != null:
return $default(_that.idx,_that.userIdx,_that.nickname,_that.sticker,_that.text,_that.image,_that.createdAt,_that.updatedAt,_that.isVisible,_that.likeCount,_that.commentCount,_that.userImage,_that.background,_that.character,_that.isLike);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommunityDiary implements CommunityDiary {
  const _CommunityDiary({required this.idx, @JsonKey(name: 'user_idx') required this.userIdx, required this.nickname, required this.sticker, required this.text, this.image, @JsonKey(name: 'created_time') required this.createdAt, @JsonKey(name: 'updated_time') this.updatedAt, @JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) required this.isVisible, @JsonKey(name: 'like_count') required this.likeCount, required this.commentCount, @JsonKey(name: 'user_image') required this.userImage, required this.background, required this.character, required this.isLike});
  factory _CommunityDiary.fromJson(Map<String, dynamic> json) => _$CommunityDiaryFromJson(json);

@override final  int idx;
@override@JsonKey(name: 'user_idx') final  int userIdx;
@override final  String nickname;
@override final  String sticker;
@override final  String text;
@override final  String? image;
@override@JsonKey(name: 'created_time') final  DateTime createdAt;
@override@JsonKey(name: 'updated_time') final  DateTime? updatedAt;
@override@JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) final  bool isVisible;
@override@JsonKey(name: 'like_count') final  int likeCount;
@override final  int commentCount;
@override@JsonKey(name: 'user_image') final  String userImage;
@override final  String background;
@override final  String character;
@override final  bool isLike;

/// Create a copy of CommunityDiary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommunityDiaryCopyWith<_CommunityDiary> get copyWith => __$CommunityDiaryCopyWithImpl<_CommunityDiary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommunityDiaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommunityDiary&&(identical(other.idx, idx) || other.idx == idx)&&(identical(other.userIdx, userIdx) || other.userIdx == userIdx)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.text, text) || other.text == text)&&(identical(other.image, image) || other.image == image)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.userImage, userImage) || other.userImage == userImage)&&(identical(other.background, background) || other.background == background)&&(identical(other.character, character) || other.character == character)&&(identical(other.isLike, isLike) || other.isLike == isLike));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idx,userIdx,nickname,sticker,text,image,createdAt,updatedAt,isVisible,likeCount,commentCount,userImage,background,character,isLike);

@override
String toString() {
  return 'CommunityDiary(idx: $idx, userIdx: $userIdx, nickname: $nickname, sticker: $sticker, text: $text, image: $image, createdAt: $createdAt, updatedAt: $updatedAt, isVisible: $isVisible, likeCount: $likeCount, commentCount: $commentCount, userImage: $userImage, background: $background, character: $character, isLike: $isLike)';
}


}

/// @nodoc
abstract mixin class _$CommunityDiaryCopyWith<$Res> implements $CommunityDiaryCopyWith<$Res> {
  factory _$CommunityDiaryCopyWith(_CommunityDiary value, $Res Function(_CommunityDiary) _then) = __$CommunityDiaryCopyWithImpl;
@override @useResult
$Res call({
 int idx,@JsonKey(name: 'user_idx') int userIdx, String nickname, String sticker, String text, String? image,@JsonKey(name: 'created_time') DateTime createdAt,@JsonKey(name: 'updated_time') DateTime? updatedAt,@JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) bool isVisible,@JsonKey(name: 'like_count') int likeCount, int commentCount,@JsonKey(name: 'user_image') String userImage, String background, String character, bool isLike
});




}
/// @nodoc
class __$CommunityDiaryCopyWithImpl<$Res>
    implements _$CommunityDiaryCopyWith<$Res> {
  __$CommunityDiaryCopyWithImpl(this._self, this._then);

  final _CommunityDiary _self;
  final $Res Function(_CommunityDiary) _then;

/// Create a copy of CommunityDiary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idx = null,Object? userIdx = null,Object? nickname = null,Object? sticker = null,Object? text = null,Object? image = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? isVisible = null,Object? likeCount = null,Object? commentCount = null,Object? userImage = null,Object? background = null,Object? character = null,Object? isLike = null,}) {
  return _then(_CommunityDiary(
idx: null == idx ? _self.idx : idx // ignore: cast_nullable_to_non_nullable
as int,userIdx: null == userIdx ? _self.userIdx : userIdx // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,sticker: null == sticker ? _self.sticker : sticker // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,userImage: null == userImage ? _self.userImage : userImage // ignore: cast_nullable_to_non_nullable
as String,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,isLike: null == isLike ? _self.isLike : isLike // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
