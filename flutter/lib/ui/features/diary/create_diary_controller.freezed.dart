// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_diary_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateDiaryFormState {

 String get sticker; String get text; DateTime get date;
/// Create a copy of CreateDiaryFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateDiaryFormStateCopyWith<CreateDiaryFormState> get copyWith => _$CreateDiaryFormStateCopyWithImpl<CreateDiaryFormState>(this as CreateDiaryFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateDiaryFormState&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.text, text) || other.text == text)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,sticker,text,date);

@override
String toString() {
  return 'CreateDiaryFormState(sticker: $sticker, text: $text, date: $date)';
}


}

/// @nodoc
abstract mixin class $CreateDiaryFormStateCopyWith<$Res>  {
  factory $CreateDiaryFormStateCopyWith(CreateDiaryFormState value, $Res Function(CreateDiaryFormState) _then) = _$CreateDiaryFormStateCopyWithImpl;
@useResult
$Res call({
 String sticker, String text, DateTime date
});




}
/// @nodoc
class _$CreateDiaryFormStateCopyWithImpl<$Res>
    implements $CreateDiaryFormStateCopyWith<$Res> {
  _$CreateDiaryFormStateCopyWithImpl(this._self, this._then);

  final CreateDiaryFormState _self;
  final $Res Function(CreateDiaryFormState) _then;

/// Create a copy of CreateDiaryFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sticker = null,Object? text = null,Object? date = null,}) {
  return _then(_self.copyWith(
sticker: null == sticker ? _self.sticker : sticker // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateDiaryFormState].
extension CreateDiaryFormStatePatterns on CreateDiaryFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateDiaryFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateDiaryFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateDiaryFormState value)  $default,){
final _that = this;
switch (_that) {
case _CreateDiaryFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateDiaryFormState value)?  $default,){
final _that = this;
switch (_that) {
case _CreateDiaryFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sticker,  String text,  DateTime date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateDiaryFormState() when $default != null:
return $default(_that.sticker,_that.text,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sticker,  String text,  DateTime date)  $default,) {final _that = this;
switch (_that) {
case _CreateDiaryFormState():
return $default(_that.sticker,_that.text,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sticker,  String text,  DateTime date)?  $default,) {final _that = this;
switch (_that) {
case _CreateDiaryFormState() when $default != null:
return $default(_that.sticker,_that.text,_that.date);case _:
  return null;

}
}

}

/// @nodoc


class _CreateDiaryFormState extends CreateDiaryFormState {
  const _CreateDiaryFormState({required this.sticker, required this.text, required this.date}): super._();
  

@override final  String sticker;
@override final  String text;
@override final  DateTime date;

/// Create a copy of CreateDiaryFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateDiaryFormStateCopyWith<_CreateDiaryFormState> get copyWith => __$CreateDiaryFormStateCopyWithImpl<_CreateDiaryFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateDiaryFormState&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.text, text) || other.text == text)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,sticker,text,date);

@override
String toString() {
  return 'CreateDiaryFormState(sticker: $sticker, text: $text, date: $date)';
}


}

/// @nodoc
abstract mixin class _$CreateDiaryFormStateCopyWith<$Res> implements $CreateDiaryFormStateCopyWith<$Res> {
  factory _$CreateDiaryFormStateCopyWith(_CreateDiaryFormState value, $Res Function(_CreateDiaryFormState) _then) = __$CreateDiaryFormStateCopyWithImpl;
@override @useResult
$Res call({
 String sticker, String text, DateTime date
});




}
/// @nodoc
class __$CreateDiaryFormStateCopyWithImpl<$Res>
    implements _$CreateDiaryFormStateCopyWith<$Res> {
  __$CreateDiaryFormStateCopyWithImpl(this._self, this._then);

  final _CreateDiaryFormState _self;
  final $Res Function(_CreateDiaryFormState) _then;

/// Create a copy of CreateDiaryFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sticker = null,Object? text = null,Object? date = null,}) {
  return _then(_CreateDiaryFormState(
sticker: null == sticker ? _self.sticker : sticker // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
