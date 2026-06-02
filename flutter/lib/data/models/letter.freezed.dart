// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'letter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Letter {

 int get idx; String get text;@JsonKey(name: 'created_time') DateTime get createdAt;
/// Create a copy of Letter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LetterCopyWith<Letter> get copyWith => _$LetterCopyWithImpl<Letter>(this as Letter, _$identity);

  /// Serializes this Letter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Letter&&(identical(other.idx, idx) || other.idx == idx)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idx,text,createdAt);

@override
String toString() {
  return 'Letter(idx: $idx, text: $text, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $LetterCopyWith<$Res>  {
  factory $LetterCopyWith(Letter value, $Res Function(Letter) _then) = _$LetterCopyWithImpl;
@useResult
$Res call({
 int idx, String text,@JsonKey(name: 'created_time') DateTime createdAt
});




}
/// @nodoc
class _$LetterCopyWithImpl<$Res>
    implements $LetterCopyWith<$Res> {
  _$LetterCopyWithImpl(this._self, this._then);

  final Letter _self;
  final $Res Function(Letter) _then;

/// Create a copy of Letter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idx = null,Object? text = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
idx: null == idx ? _self.idx : idx // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Letter].
extension LetterPatterns on Letter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Letter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Letter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Letter value)  $default,){
final _that = this;
switch (_that) {
case _Letter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Letter value)?  $default,){
final _that = this;
switch (_that) {
case _Letter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idx,  String text, @JsonKey(name: 'created_time')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Letter() when $default != null:
return $default(_that.idx,_that.text,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idx,  String text, @JsonKey(name: 'created_time')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Letter():
return $default(_that.idx,_that.text,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idx,  String text, @JsonKey(name: 'created_time')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Letter() when $default != null:
return $default(_that.idx,_that.text,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Letter implements Letter {
  const _Letter({required this.idx, required this.text, @JsonKey(name: 'created_time') required this.createdAt});
  factory _Letter.fromJson(Map<String, dynamic> json) => _$LetterFromJson(json);

@override final  int idx;
@override final  String text;
@override@JsonKey(name: 'created_time') final  DateTime createdAt;

/// Create a copy of Letter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LetterCopyWith<_Letter> get copyWith => __$LetterCopyWithImpl<_Letter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LetterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Letter&&(identical(other.idx, idx) || other.idx == idx)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idx,text,createdAt);

@override
String toString() {
  return 'Letter(idx: $idx, text: $text, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LetterCopyWith<$Res> implements $LetterCopyWith<$Res> {
  factory _$LetterCopyWith(_Letter value, $Res Function(_Letter) _then) = __$LetterCopyWithImpl;
@override @useResult
$Res call({
 int idx, String text,@JsonKey(name: 'created_time') DateTime createdAt
});




}
/// @nodoc
class __$LetterCopyWithImpl<$Res>
    implements _$LetterCopyWith<$Res> {
  __$LetterCopyWithImpl(this._self, this._then);

  final _Letter _self;
  final $Res Function(_Letter) _then;

/// Create a copy of Letter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idx = null,Object? text = null,Object? createdAt = null,}) {
  return _then(_Letter(
idx: null == idx ? _self.idx : idx // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
