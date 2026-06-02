// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_profile_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateProfileState {

 String get initialNickname; String get initialCharacter; String get initialBackground; String get nickname; NicknameStatus? get nicknameStatus; String get character; String get background; ProfileImageType? get imageType; Uint8List? get imageBytes;
/// Create a copy of UpdateProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProfileStateCopyWith<UpdateProfileState> get copyWith => _$UpdateProfileStateCopyWithImpl<UpdateProfileState>(this as UpdateProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProfileState&&(identical(other.initialNickname, initialNickname) || other.initialNickname == initialNickname)&&(identical(other.initialCharacter, initialCharacter) || other.initialCharacter == initialCharacter)&&(identical(other.initialBackground, initialBackground) || other.initialBackground == initialBackground)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.nicknameStatus, nicknameStatus) || other.nicknameStatus == nicknameStatus)&&(identical(other.character, character) || other.character == character)&&(identical(other.background, background) || other.background == background)&&(identical(other.imageType, imageType) || other.imageType == imageType)&&const DeepCollectionEquality().equals(other.imageBytes, imageBytes));
}


@override
int get hashCode => Object.hash(runtimeType,initialNickname,initialCharacter,initialBackground,nickname,nicknameStatus,character,background,imageType,const DeepCollectionEquality().hash(imageBytes));

@override
String toString() {
  return 'UpdateProfileState(initialNickname: $initialNickname, initialCharacter: $initialCharacter, initialBackground: $initialBackground, nickname: $nickname, nicknameStatus: $nicknameStatus, character: $character, background: $background, imageType: $imageType, imageBytes: $imageBytes)';
}


}

/// @nodoc
abstract mixin class $UpdateProfileStateCopyWith<$Res>  {
  factory $UpdateProfileStateCopyWith(UpdateProfileState value, $Res Function(UpdateProfileState) _then) = _$UpdateProfileStateCopyWithImpl;
@useResult
$Res call({
 String initialNickname, String initialCharacter, String initialBackground, String nickname, NicknameStatus? nicknameStatus, String character, String background, ProfileImageType? imageType, Uint8List? imageBytes
});




}
/// @nodoc
class _$UpdateProfileStateCopyWithImpl<$Res>
    implements $UpdateProfileStateCopyWith<$Res> {
  _$UpdateProfileStateCopyWithImpl(this._self, this._then);

  final UpdateProfileState _self;
  final $Res Function(UpdateProfileState) _then;

/// Create a copy of UpdateProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? initialNickname = null,Object? initialCharacter = null,Object? initialBackground = null,Object? nickname = null,Object? nicknameStatus = freezed,Object? character = null,Object? background = null,Object? imageType = freezed,Object? imageBytes = freezed,}) {
  return _then(_self.copyWith(
initialNickname: null == initialNickname ? _self.initialNickname : initialNickname // ignore: cast_nullable_to_non_nullable
as String,initialCharacter: null == initialCharacter ? _self.initialCharacter : initialCharacter // ignore: cast_nullable_to_non_nullable
as String,initialBackground: null == initialBackground ? _self.initialBackground : initialBackground // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,nicknameStatus: freezed == nicknameStatus ? _self.nicknameStatus : nicknameStatus // ignore: cast_nullable_to_non_nullable
as NicknameStatus?,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,imageType: freezed == imageType ? _self.imageType : imageType // ignore: cast_nullable_to_non_nullable
as ProfileImageType?,imageBytes: freezed == imageBytes ? _self.imageBytes : imageBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateProfileState].
extension UpdateProfileStatePatterns on UpdateProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProfileState value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String initialNickname,  String initialCharacter,  String initialBackground,  String nickname,  NicknameStatus? nicknameStatus,  String character,  String background,  ProfileImageType? imageType,  Uint8List? imageBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProfileState() when $default != null:
return $default(_that.initialNickname,_that.initialCharacter,_that.initialBackground,_that.nickname,_that.nicknameStatus,_that.character,_that.background,_that.imageType,_that.imageBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String initialNickname,  String initialCharacter,  String initialBackground,  String nickname,  NicknameStatus? nicknameStatus,  String character,  String background,  ProfileImageType? imageType,  Uint8List? imageBytes)  $default,) {final _that = this;
switch (_that) {
case _UpdateProfileState():
return $default(_that.initialNickname,_that.initialCharacter,_that.initialBackground,_that.nickname,_that.nicknameStatus,_that.character,_that.background,_that.imageType,_that.imageBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String initialNickname,  String initialCharacter,  String initialBackground,  String nickname,  NicknameStatus? nicknameStatus,  String character,  String background,  ProfileImageType? imageType,  Uint8List? imageBytes)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProfileState() when $default != null:
return $default(_that.initialNickname,_that.initialCharacter,_that.initialBackground,_that.nickname,_that.nicknameStatus,_that.character,_that.background,_that.imageType,_that.imageBytes);case _:
  return null;

}
}

}

/// @nodoc


class _UpdateProfileState extends UpdateProfileState {
  const _UpdateProfileState({required this.initialNickname, required this.initialCharacter, required this.initialBackground, this.nickname = '', this.nicknameStatus, this.character = '', this.background = '', this.imageType, this.imageBytes}): super._();
  

@override final  String initialNickname;
@override final  String initialCharacter;
@override final  String initialBackground;
@override@JsonKey() final  String nickname;
@override final  NicknameStatus? nicknameStatus;
@override@JsonKey() final  String character;
@override@JsonKey() final  String background;
@override final  ProfileImageType? imageType;
@override final  Uint8List? imageBytes;

/// Create a copy of UpdateProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProfileStateCopyWith<_UpdateProfileState> get copyWith => __$UpdateProfileStateCopyWithImpl<_UpdateProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProfileState&&(identical(other.initialNickname, initialNickname) || other.initialNickname == initialNickname)&&(identical(other.initialCharacter, initialCharacter) || other.initialCharacter == initialCharacter)&&(identical(other.initialBackground, initialBackground) || other.initialBackground == initialBackground)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.nicknameStatus, nicknameStatus) || other.nicknameStatus == nicknameStatus)&&(identical(other.character, character) || other.character == character)&&(identical(other.background, background) || other.background == background)&&(identical(other.imageType, imageType) || other.imageType == imageType)&&const DeepCollectionEquality().equals(other.imageBytes, imageBytes));
}


@override
int get hashCode => Object.hash(runtimeType,initialNickname,initialCharacter,initialBackground,nickname,nicknameStatus,character,background,imageType,const DeepCollectionEquality().hash(imageBytes));

@override
String toString() {
  return 'UpdateProfileState(initialNickname: $initialNickname, initialCharacter: $initialCharacter, initialBackground: $initialBackground, nickname: $nickname, nicknameStatus: $nicknameStatus, character: $character, background: $background, imageType: $imageType, imageBytes: $imageBytes)';
}


}

/// @nodoc
abstract mixin class _$UpdateProfileStateCopyWith<$Res> implements $UpdateProfileStateCopyWith<$Res> {
  factory _$UpdateProfileStateCopyWith(_UpdateProfileState value, $Res Function(_UpdateProfileState) _then) = __$UpdateProfileStateCopyWithImpl;
@override @useResult
$Res call({
 String initialNickname, String initialCharacter, String initialBackground, String nickname, NicknameStatus? nicknameStatus, String character, String background, ProfileImageType? imageType, Uint8List? imageBytes
});




}
/// @nodoc
class __$UpdateProfileStateCopyWithImpl<$Res>
    implements _$UpdateProfileStateCopyWith<$Res> {
  __$UpdateProfileStateCopyWithImpl(this._self, this._then);

  final _UpdateProfileState _self;
  final $Res Function(_UpdateProfileState) _then;

/// Create a copy of UpdateProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? initialNickname = null,Object? initialCharacter = null,Object? initialBackground = null,Object? nickname = null,Object? nicknameStatus = freezed,Object? character = null,Object? background = null,Object? imageType = freezed,Object? imageBytes = freezed,}) {
  return _then(_UpdateProfileState(
initialNickname: null == initialNickname ? _self.initialNickname : initialNickname // ignore: cast_nullable_to_non_nullable
as String,initialCharacter: null == initialCharacter ? _self.initialCharacter : initialCharacter // ignore: cast_nullable_to_non_nullable
as String,initialBackground: null == initialBackground ? _self.initialBackground : initialBackground // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,nicknameStatus: freezed == nicknameStatus ? _self.nicknameStatus : nicknameStatus // ignore: cast_nullable_to_non_nullable
as NicknameStatus?,character: null == character ? _self.character : character // ignore: cast_nullable_to_non_nullable
as String,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as String,imageType: freezed == imageType ? _self.imageType : imageType // ignore: cast_nullable_to_non_nullable
as ProfileImageType?,imageBytes: freezed == imageBytes ? _self.imageBytes : imageBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,
  ));
}


}

// dart format on
