// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyDiary {

 int get idx;@JsonKey(name: 'user_idx') int get userIdx; String get nickname; String get sticker; String get text; String? get image;@JsonKey(name: 'created_time') DateTime get createdAt;@JsonKey(name: 'updated_time') DateTime? get updatedAt;@JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) bool get isVisible;@JsonKey(name: 'like_count') int get likeCount; int get commentCount;
/// Create a copy of MyDiary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyDiaryCopyWith<MyDiary> get copyWith => _$MyDiaryCopyWithImpl<MyDiary>(this as MyDiary, _$identity);

  /// Serializes this MyDiary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyDiary&&(identical(other.idx, idx) || other.idx == idx)&&(identical(other.userIdx, userIdx) || other.userIdx == userIdx)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.text, text) || other.text == text)&&(identical(other.image, image) || other.image == image)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idx,userIdx,nickname,sticker,text,image,createdAt,updatedAt,isVisible,likeCount,commentCount);

@override
String toString() {
  return 'MyDiary(idx: $idx, userIdx: $userIdx, nickname: $nickname, sticker: $sticker, text: $text, image: $image, createdAt: $createdAt, updatedAt: $updatedAt, isVisible: $isVisible, likeCount: $likeCount, commentCount: $commentCount)';
}


}

/// @nodoc
abstract mixin class $MyDiaryCopyWith<$Res>  {
  factory $MyDiaryCopyWith(MyDiary value, $Res Function(MyDiary) _then) = _$MyDiaryCopyWithImpl;
@useResult
$Res call({
 int idx,@JsonKey(name: 'user_idx') int userIdx, String nickname, String sticker, String text, String? image,@JsonKey(name: 'created_time') DateTime createdAt,@JsonKey(name: 'updated_time') DateTime? updatedAt,@JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) bool isVisible,@JsonKey(name: 'like_count') int likeCount, int commentCount
});




}
/// @nodoc
class _$MyDiaryCopyWithImpl<$Res>
    implements $MyDiaryCopyWith<$Res> {
  _$MyDiaryCopyWithImpl(this._self, this._then);

  final MyDiary _self;
  final $Res Function(MyDiary) _then;

/// Create a copy of MyDiary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idx = null,Object? userIdx = null,Object? nickname = null,Object? sticker = null,Object? text = null,Object? image = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? isVisible = null,Object? likeCount = null,Object? commentCount = null,}) {
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
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MyDiary].
extension MyDiaryPatterns on MyDiary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyDiary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyDiary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyDiary value)  $default,){
final _that = this;
switch (_that) {
case _MyDiary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyDiary value)?  $default,){
final _that = this;
switch (_that) {
case _MyDiary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idx, @JsonKey(name: 'user_idx')  int userIdx,  String nickname,  String sticker,  String text,  String? image, @JsonKey(name: 'created_time')  DateTime createdAt, @JsonKey(name: 'updated_time')  DateTime? updatedAt, @JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool)  bool isVisible, @JsonKey(name: 'like_count')  int likeCount,  int commentCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyDiary() when $default != null:
return $default(_that.idx,_that.userIdx,_that.nickname,_that.sticker,_that.text,_that.image,_that.createdAt,_that.updatedAt,_that.isVisible,_that.likeCount,_that.commentCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idx, @JsonKey(name: 'user_idx')  int userIdx,  String nickname,  String sticker,  String text,  String? image, @JsonKey(name: 'created_time')  DateTime createdAt, @JsonKey(name: 'updated_time')  DateTime? updatedAt, @JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool)  bool isVisible, @JsonKey(name: 'like_count')  int likeCount,  int commentCount)  $default,) {final _that = this;
switch (_that) {
case _MyDiary():
return $default(_that.idx,_that.userIdx,_that.nickname,_that.sticker,_that.text,_that.image,_that.createdAt,_that.updatedAt,_that.isVisible,_that.likeCount,_that.commentCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idx, @JsonKey(name: 'user_idx')  int userIdx,  String nickname,  String sticker,  String text,  String? image, @JsonKey(name: 'created_time')  DateTime createdAt, @JsonKey(name: 'updated_time')  DateTime? updatedAt, @JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool)  bool isVisible, @JsonKey(name: 'like_count')  int likeCount,  int commentCount)?  $default,) {final _that = this;
switch (_that) {
case _MyDiary() when $default != null:
return $default(_that.idx,_that.userIdx,_that.nickname,_that.sticker,_that.text,_that.image,_that.createdAt,_that.updatedAt,_that.isVisible,_that.likeCount,_that.commentCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyDiary implements MyDiary {
  const _MyDiary({required this.idx, @JsonKey(name: 'user_idx') required this.userIdx, required this.nickname, required this.sticker, required this.text, this.image, @JsonKey(name: 'created_time') required this.createdAt, @JsonKey(name: 'updated_time') this.updatedAt, @JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) required this.isVisible, @JsonKey(name: 'like_count') required this.likeCount, required this.commentCount});
  factory _MyDiary.fromJson(Map<String, dynamic> json) => _$MyDiaryFromJson(json);

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

/// Create a copy of MyDiary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyDiaryCopyWith<_MyDiary> get copyWith => __$MyDiaryCopyWithImpl<_MyDiary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyDiaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyDiary&&(identical(other.idx, idx) || other.idx == idx)&&(identical(other.userIdx, userIdx) || other.userIdx == userIdx)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.text, text) || other.text == text)&&(identical(other.image, image) || other.image == image)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idx,userIdx,nickname,sticker,text,image,createdAt,updatedAt,isVisible,likeCount,commentCount);

@override
String toString() {
  return 'MyDiary(idx: $idx, userIdx: $userIdx, nickname: $nickname, sticker: $sticker, text: $text, image: $image, createdAt: $createdAt, updatedAt: $updatedAt, isVisible: $isVisible, likeCount: $likeCount, commentCount: $commentCount)';
}


}

/// @nodoc
abstract mixin class _$MyDiaryCopyWith<$Res> implements $MyDiaryCopyWith<$Res> {
  factory _$MyDiaryCopyWith(_MyDiary value, $Res Function(_MyDiary) _then) = __$MyDiaryCopyWithImpl;
@override @useResult
$Res call({
 int idx,@JsonKey(name: 'user_idx') int userIdx, String nickname, String sticker, String text, String? image,@JsonKey(name: 'created_time') DateTime createdAt,@JsonKey(name: 'updated_time') DateTime? updatedAt,@JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) bool isVisible,@JsonKey(name: 'like_count') int likeCount, int commentCount
});




}
/// @nodoc
class __$MyDiaryCopyWithImpl<$Res>
    implements _$MyDiaryCopyWith<$Res> {
  __$MyDiaryCopyWithImpl(this._self, this._then);

  final _MyDiary _self;
  final $Res Function(_MyDiary) _then;

/// Create a copy of MyDiary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idx = null,Object? userIdx = null,Object? nickname = null,Object? sticker = null,Object? text = null,Object? image = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? isVisible = null,Object? likeCount = null,Object? commentCount = null,}) {
  return _then(_MyDiary(
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
as int,
  ));
}


}


/// @nodoc
mixin _$DailyDiary {

 int get idx; String get sticker; String get text; String? get image;@JsonKey(name: 'created_time') DateTime get createdAt;@JsonKey(name: 'updated_time') DateTime? get updatedAt;@JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) bool get isVisible;
/// Create a copy of DailyDiary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyDiaryCopyWith<DailyDiary> get copyWith => _$DailyDiaryCopyWithImpl<DailyDiary>(this as DailyDiary, _$identity);

  /// Serializes this DailyDiary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyDiary&&(identical(other.idx, idx) || other.idx == idx)&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.text, text) || other.text == text)&&(identical(other.image, image) || other.image == image)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idx,sticker,text,image,createdAt,updatedAt,isVisible);

@override
String toString() {
  return 'DailyDiary(idx: $idx, sticker: $sticker, text: $text, image: $image, createdAt: $createdAt, updatedAt: $updatedAt, isVisible: $isVisible)';
}


}

/// @nodoc
abstract mixin class $DailyDiaryCopyWith<$Res>  {
  factory $DailyDiaryCopyWith(DailyDiary value, $Res Function(DailyDiary) _then) = _$DailyDiaryCopyWithImpl;
@useResult
$Res call({
 int idx, String sticker, String text, String? image,@JsonKey(name: 'created_time') DateTime createdAt,@JsonKey(name: 'updated_time') DateTime? updatedAt,@JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) bool isVisible
});




}
/// @nodoc
class _$DailyDiaryCopyWithImpl<$Res>
    implements $DailyDiaryCopyWith<$Res> {
  _$DailyDiaryCopyWithImpl(this._self, this._then);

  final DailyDiary _self;
  final $Res Function(DailyDiary) _then;

/// Create a copy of DailyDiary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idx = null,Object? sticker = null,Object? text = null,Object? image = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? isVisible = null,}) {
  return _then(_self.copyWith(
idx: null == idx ? _self.idx : idx // ignore: cast_nullable_to_non_nullable
as int,sticker: null == sticker ? _self.sticker : sticker // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyDiary].
extension DailyDiaryPatterns on DailyDiary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyDiary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyDiary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyDiary value)  $default,){
final _that = this;
switch (_that) {
case _DailyDiary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyDiary value)?  $default,){
final _that = this;
switch (_that) {
case _DailyDiary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idx,  String sticker,  String text,  String? image, @JsonKey(name: 'created_time')  DateTime createdAt, @JsonKey(name: 'updated_time')  DateTime? updatedAt, @JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool)  bool isVisible)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyDiary() when $default != null:
return $default(_that.idx,_that.sticker,_that.text,_that.image,_that.createdAt,_that.updatedAt,_that.isVisible);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idx,  String sticker,  String text,  String? image, @JsonKey(name: 'created_time')  DateTime createdAt, @JsonKey(name: 'updated_time')  DateTime? updatedAt, @JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool)  bool isVisible)  $default,) {final _that = this;
switch (_that) {
case _DailyDiary():
return $default(_that.idx,_that.sticker,_that.text,_that.image,_that.createdAt,_that.updatedAt,_that.isVisible);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idx,  String sticker,  String text,  String? image, @JsonKey(name: 'created_time')  DateTime createdAt, @JsonKey(name: 'updated_time')  DateTime? updatedAt, @JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool)  bool isVisible)?  $default,) {final _that = this;
switch (_that) {
case _DailyDiary() when $default != null:
return $default(_that.idx,_that.sticker,_that.text,_that.image,_that.createdAt,_that.updatedAt,_that.isVisible);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyDiary implements DailyDiary {
  const _DailyDiary({required this.idx, required this.sticker, required this.text, this.image, @JsonKey(name: 'created_time') required this.createdAt, @JsonKey(name: 'updated_time') this.updatedAt, @JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) required this.isVisible});
  factory _DailyDiary.fromJson(Map<String, dynamic> json) => _$DailyDiaryFromJson(json);

@override final  int idx;
@override final  String sticker;
@override final  String text;
@override final  String? image;
@override@JsonKey(name: 'created_time') final  DateTime createdAt;
@override@JsonKey(name: 'updated_time') final  DateTime? updatedAt;
@override@JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) final  bool isVisible;

/// Create a copy of DailyDiary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyDiaryCopyWith<_DailyDiary> get copyWith => __$DailyDiaryCopyWithImpl<_DailyDiary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyDiaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyDiary&&(identical(other.idx, idx) || other.idx == idx)&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.text, text) || other.text == text)&&(identical(other.image, image) || other.image == image)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idx,sticker,text,image,createdAt,updatedAt,isVisible);

@override
String toString() {
  return 'DailyDiary(idx: $idx, sticker: $sticker, text: $text, image: $image, createdAt: $createdAt, updatedAt: $updatedAt, isVisible: $isVisible)';
}


}

/// @nodoc
abstract mixin class _$DailyDiaryCopyWith<$Res> implements $DailyDiaryCopyWith<$Res> {
  factory _$DailyDiaryCopyWith(_DailyDiary value, $Res Function(_DailyDiary) _then) = __$DailyDiaryCopyWithImpl;
@override @useResult
$Res call({
 int idx, String sticker, String text, String? image,@JsonKey(name: 'created_time') DateTime createdAt,@JsonKey(name: 'updated_time') DateTime? updatedAt,@JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) bool isVisible
});




}
/// @nodoc
class __$DailyDiaryCopyWithImpl<$Res>
    implements _$DailyDiaryCopyWith<$Res> {
  __$DailyDiaryCopyWithImpl(this._self, this._then);

  final _DailyDiary _self;
  final $Res Function(_DailyDiary) _then;

/// Create a copy of DailyDiary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idx = null,Object? sticker = null,Object? text = null,Object? image = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? isVisible = null,}) {
  return _then(_DailyDiary(
idx: null == idx ? _self.idx : idx // ignore: cast_nullable_to_non_nullable
as int,sticker: null == sticker ? _self.sticker : sticker // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CreateDiaryResult {

 int get diaryIdx;
/// Create a copy of CreateDiaryResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateDiaryResultCopyWith<CreateDiaryResult> get copyWith => _$CreateDiaryResultCopyWithImpl<CreateDiaryResult>(this as CreateDiaryResult, _$identity);

  /// Serializes this CreateDiaryResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateDiaryResult&&(identical(other.diaryIdx, diaryIdx) || other.diaryIdx == diaryIdx));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,diaryIdx);

@override
String toString() {
  return 'CreateDiaryResult(diaryIdx: $diaryIdx)';
}


}

/// @nodoc
abstract mixin class $CreateDiaryResultCopyWith<$Res>  {
  factory $CreateDiaryResultCopyWith(CreateDiaryResult value, $Res Function(CreateDiaryResult) _then) = _$CreateDiaryResultCopyWithImpl;
@useResult
$Res call({
 int diaryIdx
});




}
/// @nodoc
class _$CreateDiaryResultCopyWithImpl<$Res>
    implements $CreateDiaryResultCopyWith<$Res> {
  _$CreateDiaryResultCopyWithImpl(this._self, this._then);

  final CreateDiaryResult _self;
  final $Res Function(CreateDiaryResult) _then;

/// Create a copy of CreateDiaryResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? diaryIdx = null,}) {
  return _then(_self.copyWith(
diaryIdx: null == diaryIdx ? _self.diaryIdx : diaryIdx // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateDiaryResult].
extension CreateDiaryResultPatterns on CreateDiaryResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateDiaryResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateDiaryResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateDiaryResult value)  $default,){
final _that = this;
switch (_that) {
case _CreateDiaryResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateDiaryResult value)?  $default,){
final _that = this;
switch (_that) {
case _CreateDiaryResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int diaryIdx)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateDiaryResult() when $default != null:
return $default(_that.diaryIdx);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int diaryIdx)  $default,) {final _that = this;
switch (_that) {
case _CreateDiaryResult():
return $default(_that.diaryIdx);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int diaryIdx)?  $default,) {final _that = this;
switch (_that) {
case _CreateDiaryResult() when $default != null:
return $default(_that.diaryIdx);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateDiaryResult implements CreateDiaryResult {
  const _CreateDiaryResult({required this.diaryIdx});
  factory _CreateDiaryResult.fromJson(Map<String, dynamic> json) => _$CreateDiaryResultFromJson(json);

@override final  int diaryIdx;

/// Create a copy of CreateDiaryResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateDiaryResultCopyWith<_CreateDiaryResult> get copyWith => __$CreateDiaryResultCopyWithImpl<_CreateDiaryResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateDiaryResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateDiaryResult&&(identical(other.diaryIdx, diaryIdx) || other.diaryIdx == diaryIdx));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,diaryIdx);

@override
String toString() {
  return 'CreateDiaryResult(diaryIdx: $diaryIdx)';
}


}

/// @nodoc
abstract mixin class _$CreateDiaryResultCopyWith<$Res> implements $CreateDiaryResultCopyWith<$Res> {
  factory _$CreateDiaryResultCopyWith(_CreateDiaryResult value, $Res Function(_CreateDiaryResult) _then) = __$CreateDiaryResultCopyWithImpl;
@override @useResult
$Res call({
 int diaryIdx
});




}
/// @nodoc
class __$CreateDiaryResultCopyWithImpl<$Res>
    implements _$CreateDiaryResultCopyWith<$Res> {
  __$CreateDiaryResultCopyWithImpl(this._self, this._then);

  final _CreateDiaryResult _self;
  final $Res Function(_CreateDiaryResult) _then;

/// Create a copy of CreateDiaryResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? diaryIdx = null,}) {
  return _then(_CreateDiaryResult(
diaryIdx: null == diaryIdx ? _self.diaryIdx : diaryIdx // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LikeResult {

@JsonKey(name: 'like_count') int get likeCount; bool get isLike;
/// Create a copy of LikeResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LikeResultCopyWith<LikeResult> get copyWith => _$LikeResultCopyWithImpl<LikeResult>(this as LikeResult, _$identity);

  /// Serializes this LikeResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LikeResult&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.isLike, isLike) || other.isLike == isLike));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,likeCount,isLike);

@override
String toString() {
  return 'LikeResult(likeCount: $likeCount, isLike: $isLike)';
}


}

/// @nodoc
abstract mixin class $LikeResultCopyWith<$Res>  {
  factory $LikeResultCopyWith(LikeResult value, $Res Function(LikeResult) _then) = _$LikeResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'like_count') int likeCount, bool isLike
});




}
/// @nodoc
class _$LikeResultCopyWithImpl<$Res>
    implements $LikeResultCopyWith<$Res> {
  _$LikeResultCopyWithImpl(this._self, this._then);

  final LikeResult _self;
  final $Res Function(LikeResult) _then;

/// Create a copy of LikeResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? likeCount = null,Object? isLike = null,}) {
  return _then(_self.copyWith(
likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,isLike: null == isLike ? _self.isLike : isLike // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LikeResult].
extension LikeResultPatterns on LikeResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LikeResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LikeResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LikeResult value)  $default,){
final _that = this;
switch (_that) {
case _LikeResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LikeResult value)?  $default,){
final _that = this;
switch (_that) {
case _LikeResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'like_count')  int likeCount,  bool isLike)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LikeResult() when $default != null:
return $default(_that.likeCount,_that.isLike);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'like_count')  int likeCount,  bool isLike)  $default,) {final _that = this;
switch (_that) {
case _LikeResult():
return $default(_that.likeCount,_that.isLike);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'like_count')  int likeCount,  bool isLike)?  $default,) {final _that = this;
switch (_that) {
case _LikeResult() when $default != null:
return $default(_that.likeCount,_that.isLike);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LikeResult implements LikeResult {
  const _LikeResult({@JsonKey(name: 'like_count') required this.likeCount, required this.isLike});
  factory _LikeResult.fromJson(Map<String, dynamic> json) => _$LikeResultFromJson(json);

@override@JsonKey(name: 'like_count') final  int likeCount;
@override final  bool isLike;

/// Create a copy of LikeResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LikeResultCopyWith<_LikeResult> get copyWith => __$LikeResultCopyWithImpl<_LikeResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LikeResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LikeResult&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.isLike, isLike) || other.isLike == isLike));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,likeCount,isLike);

@override
String toString() {
  return 'LikeResult(likeCount: $likeCount, isLike: $isLike)';
}


}

/// @nodoc
abstract mixin class _$LikeResultCopyWith<$Res> implements $LikeResultCopyWith<$Res> {
  factory _$LikeResultCopyWith(_LikeResult value, $Res Function(_LikeResult) _then) = __$LikeResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'like_count') int likeCount, bool isLike
});




}
/// @nodoc
class __$LikeResultCopyWithImpl<$Res>
    implements _$LikeResultCopyWith<$Res> {
  __$LikeResultCopyWithImpl(this._self, this._then);

  final _LikeResult _self;
  final $Res Function(_LikeResult) _then;

/// Create a copy of LikeResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? likeCount = null,Object? isLike = null,}) {
  return _then(_LikeResult(
likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,isLike: null == isLike ? _self.isLike : isLike // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
