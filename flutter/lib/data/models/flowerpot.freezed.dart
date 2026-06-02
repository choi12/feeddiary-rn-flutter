// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flowerpot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Flowerpot {

 int get level; int get exp;@JsonKey(name: 'max_exp') int get maxExp;@JsonKey(name: 'watering_count') int get wateringCount;@JsonKey(name: 'love_count') int get loveCount; bool get showBadge;
/// Create a copy of Flowerpot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlowerpotCopyWith<Flowerpot> get copyWith => _$FlowerpotCopyWithImpl<Flowerpot>(this as Flowerpot, _$identity);

  /// Serializes this Flowerpot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Flowerpot&&(identical(other.level, level) || other.level == level)&&(identical(other.exp, exp) || other.exp == exp)&&(identical(other.maxExp, maxExp) || other.maxExp == maxExp)&&(identical(other.wateringCount, wateringCount) || other.wateringCount == wateringCount)&&(identical(other.loveCount, loveCount) || other.loveCount == loveCount)&&(identical(other.showBadge, showBadge) || other.showBadge == showBadge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,exp,maxExp,wateringCount,loveCount,showBadge);

@override
String toString() {
  return 'Flowerpot(level: $level, exp: $exp, maxExp: $maxExp, wateringCount: $wateringCount, loveCount: $loveCount, showBadge: $showBadge)';
}


}

/// @nodoc
abstract mixin class $FlowerpotCopyWith<$Res>  {
  factory $FlowerpotCopyWith(Flowerpot value, $Res Function(Flowerpot) _then) = _$FlowerpotCopyWithImpl;
@useResult
$Res call({
 int level, int exp,@JsonKey(name: 'max_exp') int maxExp,@JsonKey(name: 'watering_count') int wateringCount,@JsonKey(name: 'love_count') int loveCount, bool showBadge
});




}
/// @nodoc
class _$FlowerpotCopyWithImpl<$Res>
    implements $FlowerpotCopyWith<$Res> {
  _$FlowerpotCopyWithImpl(this._self, this._then);

  final Flowerpot _self;
  final $Res Function(Flowerpot) _then;

/// Create a copy of Flowerpot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? exp = null,Object? maxExp = null,Object? wateringCount = null,Object? loveCount = null,Object? showBadge = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,exp: null == exp ? _self.exp : exp // ignore: cast_nullable_to_non_nullable
as int,maxExp: null == maxExp ? _self.maxExp : maxExp // ignore: cast_nullable_to_non_nullable
as int,wateringCount: null == wateringCount ? _self.wateringCount : wateringCount // ignore: cast_nullable_to_non_nullable
as int,loveCount: null == loveCount ? _self.loveCount : loveCount // ignore: cast_nullable_to_non_nullable
as int,showBadge: null == showBadge ? _self.showBadge : showBadge // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Flowerpot].
extension FlowerpotPatterns on Flowerpot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Flowerpot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Flowerpot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Flowerpot value)  $default,){
final _that = this;
switch (_that) {
case _Flowerpot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Flowerpot value)?  $default,){
final _that = this;
switch (_that) {
case _Flowerpot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int level,  int exp, @JsonKey(name: 'max_exp')  int maxExp, @JsonKey(name: 'watering_count')  int wateringCount, @JsonKey(name: 'love_count')  int loveCount,  bool showBadge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Flowerpot() when $default != null:
return $default(_that.level,_that.exp,_that.maxExp,_that.wateringCount,_that.loveCount,_that.showBadge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int level,  int exp, @JsonKey(name: 'max_exp')  int maxExp, @JsonKey(name: 'watering_count')  int wateringCount, @JsonKey(name: 'love_count')  int loveCount,  bool showBadge)  $default,) {final _that = this;
switch (_that) {
case _Flowerpot():
return $default(_that.level,_that.exp,_that.maxExp,_that.wateringCount,_that.loveCount,_that.showBadge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int level,  int exp, @JsonKey(name: 'max_exp')  int maxExp, @JsonKey(name: 'watering_count')  int wateringCount, @JsonKey(name: 'love_count')  int loveCount,  bool showBadge)?  $default,) {final _that = this;
switch (_that) {
case _Flowerpot() when $default != null:
return $default(_that.level,_that.exp,_that.maxExp,_that.wateringCount,_that.loveCount,_that.showBadge);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Flowerpot implements Flowerpot {
  const _Flowerpot({required this.level, required this.exp, @JsonKey(name: 'max_exp') required this.maxExp, @JsonKey(name: 'watering_count') required this.wateringCount, @JsonKey(name: 'love_count') required this.loveCount, required this.showBadge});
  factory _Flowerpot.fromJson(Map<String, dynamic> json) => _$FlowerpotFromJson(json);

@override final  int level;
@override final  int exp;
@override@JsonKey(name: 'max_exp') final  int maxExp;
@override@JsonKey(name: 'watering_count') final  int wateringCount;
@override@JsonKey(name: 'love_count') final  int loveCount;
@override final  bool showBadge;

/// Create a copy of Flowerpot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlowerpotCopyWith<_Flowerpot> get copyWith => __$FlowerpotCopyWithImpl<_Flowerpot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlowerpotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Flowerpot&&(identical(other.level, level) || other.level == level)&&(identical(other.exp, exp) || other.exp == exp)&&(identical(other.maxExp, maxExp) || other.maxExp == maxExp)&&(identical(other.wateringCount, wateringCount) || other.wateringCount == wateringCount)&&(identical(other.loveCount, loveCount) || other.loveCount == loveCount)&&(identical(other.showBadge, showBadge) || other.showBadge == showBadge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,exp,maxExp,wateringCount,loveCount,showBadge);

@override
String toString() {
  return 'Flowerpot(level: $level, exp: $exp, maxExp: $maxExp, wateringCount: $wateringCount, loveCount: $loveCount, showBadge: $showBadge)';
}


}

/// @nodoc
abstract mixin class _$FlowerpotCopyWith<$Res> implements $FlowerpotCopyWith<$Res> {
  factory _$FlowerpotCopyWith(_Flowerpot value, $Res Function(_Flowerpot) _then) = __$FlowerpotCopyWithImpl;
@override @useResult
$Res call({
 int level, int exp,@JsonKey(name: 'max_exp') int maxExp,@JsonKey(name: 'watering_count') int wateringCount,@JsonKey(name: 'love_count') int loveCount, bool showBadge
});




}
/// @nodoc
class __$FlowerpotCopyWithImpl<$Res>
    implements _$FlowerpotCopyWith<$Res> {
  __$FlowerpotCopyWithImpl(this._self, this._then);

  final _Flowerpot _self;
  final $Res Function(_Flowerpot) _then;

/// Create a copy of Flowerpot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? exp = null,Object? maxExp = null,Object? wateringCount = null,Object? loveCount = null,Object? showBadge = null,}) {
  return _then(_Flowerpot(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,exp: null == exp ? _self.exp : exp // ignore: cast_nullable_to_non_nullable
as int,maxExp: null == maxExp ? _self.maxExp : maxExp // ignore: cast_nullable_to_non_nullable
as int,wateringCount: null == wateringCount ? _self.wateringCount : wateringCount // ignore: cast_nullable_to_non_nullable
as int,loveCount: null == loveCount ? _self.loveCount : loveCount // ignore: cast_nullable_to_non_nullable
as int,showBadge: null == showBadge ? _self.showBadge : showBadge // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
