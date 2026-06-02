// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_profile_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateProfileState {

 String get nickname; NicknameStatus? get nicknameStatus; String? get character; String get background; ProfileImageType? get imageType; Uint8List? get imageBytes;
/// Create a copy of CreateProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProfileStateCopyWith<CreateProfileState> get copyWith => _$CreateProfileStateCopyWithImpl<CreateProfileState>(this as CreateProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProfileState&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.nicknameStatus, nicknameStatus) || other.nicknameStatus == nicknameStatus)&&(identical(other.character, character) || other.character == character)&&(identical(other.background, background) || other.background == background)&&(identical(other.imageType, imageType) || other.imageType == imageType)&&const DeepCollectionEquality().equals(other.imageBytes, imageBytes));
}


@override
int get hashCode => Object.hash(runtimeType,nickname,nicknameStatus,character,background,imageType,const DeepCollectionEquality().hash(imageBytes));

@override
String toString() {
  return 'CreateProfileState(nickname: $nickname, nicknameStatus: $nicknameStatus, character: $character, background: $background, imageType: $imageType, imageBytes: $imageBytes)';
}


}

/// @nodoc
abstract mixin class $CreateProfileStateCopyWith<$Res>  {
  factory $CreateProfileStateCopyWith(CreateProfileState value, $Res Function(CreateProfileState) _then) = _$CreateProfileStateCopyWithImpl;
@useResult
$Res call({
 String nickname, NicknameStatus? nicknameStatus, String? character, String background, ProfileImageType? imageType, Uint8List? imageBytes
});




}
/// @nodoc
class _$CreateProfileStateCopyWithImpl<$Res>
    implements $CreateProfileStateCopyWith<$Res> {
  _$CreateProfileStateCopyWithImpl(this._self, this._then);

  final CreateProfileState _self;
  final $Res Function(CreateProfileState) _then;

/// Create a copy of CreateProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nickname = null,Object? nicknameStatus = freezed,Object? character = freezed,Object? background = null,Object? imageType = freezed,Object? imageBytes = freezed,}) {
  return _then(_self.copyWith(
nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,nicknameStatus: freezed == nicknameStatus ? _self.nicknameStatus : nicknameStatus // ignore: cast_nullable_to_non_nullable
as NicknameStatus?,character: freezed == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String?,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,imageType: freezed == imageType ? _self.imageType : imageType // ignore: cast_nullable_to_non_nullable
as ProfileImageType?,imageBytes: freezed == imageBytes ? _self.imageBytes : imageBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateProfileState].
extension CreateProfileStatePatterns on CreateProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateProfileState value)  $default,){
final _that = this;
switch (_that) {
case _CreateProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _CreateProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nickname,  NicknameStatus? nicknameStatus,  String? character,  String background,  ProfileImageType? imageType,  Uint8List? imageBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProfileState() when $default != null:
return $default(_that.nickname,_that.nicknameStatus,_that.character,_that.background,_that.imageType,_that.imageBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nickname,  NicknameStatus? nicknameStatus,  String? character,  String background,  ProfileImageType? imageType,  Uint8List? imageBytes)  $default,) {final _that = this;
switch (_that) {
case _CreateProfileState():
return $default(_that.nickname,_that.nicknameStatus,_that.character,_that.background,_that.imageType,_that.imageBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nickname,  NicknameStatus? nicknameStatus,  String? character,  String background,  ProfileImageType? imageType,  Uint8List? imageBytes)?  $default,) {final _that = this;
switch (_that) {
case _CreateProfileState() when $default != null:
return $default(_that.nickname,_that.nicknameStatus,_that.character,_that.background,_that.imageType,_that.imageBytes);case _:
  return null;

}
}

}

/// @nodoc


class _CreateProfileState extends CreateProfileState {
  const _CreateProfileState({this.nickname = '', this.nicknameStatus, this.character, this.background = '', this.imageType, this.imageBytes}): super._();
  

@override@JsonKey() final  String nickname;
@override final  NicknameStatus? nicknameStatus;
@override final  String? character;
@override@JsonKey() final  String background;
@override final  ProfileImageType? imageType;
@override final  Uint8List? imageBytes;

/// Create a copy of CreateProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateProfileStateCopyWith<_CreateProfileState> get copyWith => __$CreateProfileStateCopyWithImpl<_CreateProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProfileState&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.nicknameStatus, nicknameStatus) || other.nicknameStatus == nicknameStatus)&&(identical(other.character, character) || other.character == character)&&(identical(other.background, background) || other.background == background)&&(identical(other.imageType, imageType) || other.imageType == imageType)&&const DeepCollectionEquality().equals(other.imageBytes, imageBytes));
}


@override
int get hashCode => Object.hash(runtimeType,nickname,nicknameStatus,character,background,imageType,const DeepCollectionEquality().hash(imageBytes));

@override
String toString() {
  return 'CreateProfileState(nickname: $nickname, nicknameStatus: $nicknameStatus, character: $character, background: $background, imageType: $imageType, imageBytes: $imageBytes)';
}


}

/// @nodoc
abstract mixin class _$CreateProfileStateCopyWith<$Res> implements $CreateProfileStateCopyWith<$Res> {
  factory _$CreateProfileStateCopyWith(_CreateProfileState value, $Res Function(_CreateProfileState) _then) = __$CreateProfileStateCopyWithImpl;
@override @useResult
$Res call({
 String nickname, NicknameStatus? nicknameStatus, String? character, String background, ProfileImageType? imageType, Uint8List? imageBytes
});




}
/// @nodoc
class __$CreateProfileStateCopyWithImpl<$Res>
    implements _$CreateProfileStateCopyWith<$Res> {
  __$CreateProfileStateCopyWithImpl(this._self, this._then);

  final _CreateProfileState _self;
  final $Res Function(_CreateProfileState) _then;

/// Create a copy of CreateProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nickname = null,Object? nicknameStatus = freezed,Object? character = freezed,Object? background = null,Object? imageType = freezed,Object? imageBytes = freezed,}) {
  return _then(_CreateProfileState(
nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,nicknameStatus: freezed == nicknameStatus ? _self.nicknameStatus : nicknameStatus // ignore: cast_nullable_to_non_nullable
as NicknameStatus?,character: freezed == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String?,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,imageType: freezed == imageType ? _self.imageType : imageType // ignore: cast_nullable_to_non_nullable
as ProfileImageType?,imageBytes: freezed == imageBytes ? _self.imageBytes : imageBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,
  ));
}


}

// dart format on
