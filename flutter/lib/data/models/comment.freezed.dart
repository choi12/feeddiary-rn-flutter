// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Comment {

 int get idx; String get nickname; String get background; String get character; String get text;@JsonKey(name: 'created_time') DateTime get createdAt;@JsonKey(name: 'user_image') String get userImage;
/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentCopyWith<Comment> get copyWith => _$CommentCopyWithImpl<Comment>(this as Comment, _$identity);

  /// Serializes this Comment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Comment&&(identical(other.idx, idx) || other.idx == idx)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.background, background) || other.background == background)&&(identical(other.character, character) || other.character == character)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.userImage, userImage) || other.userImage == userImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idx,nickname,background,character,text,createdAt,userImage);

@override
String toString() {
  return 'Comment(idx: $idx, nickname: $nickname, background: $background, character: $character, text: $text, createdAt: $createdAt, userImage: $userImage)';
}


}

/// @nodoc
abstract mixin class $CommentCopyWith<$Res>  {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) _then) = _$CommentCopyWithImpl;
@useResult
$Res call({
 int idx, String nickname, String background, String character, String text,@JsonKey(name: 'created_time') DateTime createdAt,@JsonKey(name: 'user_image') String userImage
});




}
/// @nodoc
class _$CommentCopyWithImpl<$Res>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._self, this._then);

  final Comment _self;
  final $Res Function(Comment) _then;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idx = null,Object? nickname = null,Object? background = null,Object? character = null,Object? text = null,Object? createdAt = null,Object? userImage = null,}) {
  return _then(_self.copyWith(
idx: null == idx ? _self.idx : idx // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,userImage: null == userImage ? _self.userImage : userImage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Comment].
extension CommentPatterns on Comment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Comment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Comment value)  $default,){
final _that = this;
switch (_that) {
case _Comment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Comment value)?  $default,){
final _that = this;
switch (_that) {
case _Comment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idx,  String nickname,  String background,  String character,  String text, @JsonKey(name: 'created_time')  DateTime createdAt, @JsonKey(name: 'user_image')  String userImage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.idx,_that.nickname,_that.background,_that.character,_that.text,_that.createdAt,_that.userImage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idx,  String nickname,  String background,  String character,  String text, @JsonKey(name: 'created_time')  DateTime createdAt, @JsonKey(name: 'user_image')  String userImage)  $default,) {final _that = this;
switch (_that) {
case _Comment():
return $default(_that.idx,_that.nickname,_that.background,_that.character,_that.text,_that.createdAt,_that.userImage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idx,  String nickname,  String background,  String character,  String text, @JsonKey(name: 'created_time')  DateTime createdAt, @JsonKey(name: 'user_image')  String userImage)?  $default,) {final _that = this;
switch (_that) {
case _Comment() when $default != null:
return $default(_that.idx,_that.nickname,_that.background,_that.character,_that.text,_that.createdAt,_that.userImage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Comment implements Comment {
  const _Comment({required this.idx, required this.nickname, required this.background, required this.character, required this.text, @JsonKey(name: 'created_time') required this.createdAt, @JsonKey(name: 'user_image') required this.userImage});
  factory _Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

@override final  int idx;
@override final  String nickname;
@override final  String background;
@override final  String character;
@override final  String text;
@override@JsonKey(name: 'created_time') final  DateTime createdAt;
@override@JsonKey(name: 'user_image') final  String userImage;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentCopyWith<_Comment> get copyWith => __$CommentCopyWithImpl<_Comment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Comment&&(identical(other.idx, idx) || other.idx == idx)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.background, background) || other.background == background)&&(identical(other.character, character) || other.character == character)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.userImage, userImage) || other.userImage == userImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idx,nickname,background,character,text,createdAt,userImage);

@override
String toString() {
  return 'Comment(idx: $idx, nickname: $nickname, background: $background, character: $character, text: $text, createdAt: $createdAt, userImage: $userImage)';
}


}

/// @nodoc
abstract mixin class _$CommentCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$CommentCopyWith(_Comment value, $Res Function(_Comment) _then) = __$CommentCopyWithImpl;
@override @useResult
$Res call({
 int idx, String nickname, String background, String character, String text,@JsonKey(name: 'created_time') DateTime createdAt,@JsonKey(name: 'user_image') String userImage
});




}
/// @nodoc
class __$CommentCopyWithImpl<$Res>
    implements _$CommentCopyWith<$Res> {
  __$CommentCopyWithImpl(this._self, this._then);

  final _Comment _self;
  final $Res Function(_Comment) _then;

/// Create a copy of Comment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idx = null,Object? nickname = null,Object? background = null,Object? character = null,Object? text = null,Object? createdAt = null,Object? userImage = null,}) {
  return _then(_Comment(
idx: null == idx ? _self.idx : idx // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,userImage: null == userImage ? _self.userImage : userImage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
