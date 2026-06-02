// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Mission {

 int get idx; MissionType get type; int get count;@JsonKey(name: 'max_count') int get maxCount;@JsonKey(name: 'is_completed', fromJson: boolFromInt, toJson: intFromBool) bool get isCompleted;
/// Create a copy of Mission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionCopyWith<Mission> get copyWith => _$MissionCopyWithImpl<Mission>(this as Mission, _$identity);

  /// Serializes this Mission to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Mission&&(identical(other.idx, idx) || other.idx == idx)&&(identical(other.type, type) || other.type == type)&&(identical(other.count, count) || other.count == count)&&(identical(other.maxCount, maxCount) || other.maxCount == maxCount)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idx,type,count,maxCount,isCompleted);

@override
String toString() {
  return 'Mission(idx: $idx, type: $type, count: $count, maxCount: $maxCount, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $MissionCopyWith<$Res>  {
  factory $MissionCopyWith(Mission value, $Res Function(Mission) _then) = _$MissionCopyWithImpl;
@useResult
$Res call({
 int idx, MissionType type, int count,@JsonKey(name: 'max_count') int maxCount,@JsonKey(name: 'is_completed', fromJson: boolFromInt, toJson: intFromBool) bool isCompleted
});




}
/// @nodoc
class _$MissionCopyWithImpl<$Res>
    implements $MissionCopyWith<$Res> {
  _$MissionCopyWithImpl(this._self, this._then);

  final Mission _self;
  final $Res Function(Mission) _then;

/// Create a copy of Mission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idx = null,Object? type = null,Object? count = null,Object? maxCount = null,Object? isCompleted = null,}) {
  return _then(_self.copyWith(
idx: null == idx ? _self.idx : idx // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MissionType,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,maxCount: null == maxCount ? _self.maxCount : maxCount // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Mission].
extension MissionPatterns on Mission {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Mission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Mission() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Mission value)  $default,){
final _that = this;
switch (_that) {
case _Mission():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Mission value)?  $default,){
final _that = this;
switch (_that) {
case _Mission() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idx,  MissionType type,  int count, @JsonKey(name: 'max_count')  int maxCount, @JsonKey(name: 'is_completed', fromJson: boolFromInt, toJson: intFromBool)  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Mission() when $default != null:
return $default(_that.idx,_that.type,_that.count,_that.maxCount,_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idx,  MissionType type,  int count, @JsonKey(name: 'max_count')  int maxCount, @JsonKey(name: 'is_completed', fromJson: boolFromInt, toJson: intFromBool)  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _Mission():
return $default(_that.idx,_that.type,_that.count,_that.maxCount,_that.isCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idx,  MissionType type,  int count, @JsonKey(name: 'max_count')  int maxCount, @JsonKey(name: 'is_completed', fromJson: boolFromInt, toJson: intFromBool)  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _Mission() when $default != null:
return $default(_that.idx,_that.type,_that.count,_that.maxCount,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Mission extends Mission {
  const _Mission({required this.idx, required this.type, required this.count, @JsonKey(name: 'max_count') required this.maxCount, @JsonKey(name: 'is_completed', fromJson: boolFromInt, toJson: intFromBool) required this.isCompleted}): super._();
  factory _Mission.fromJson(Map<String, dynamic> json) => _$MissionFromJson(json);

@override final  int idx;
@override final  MissionType type;
@override final  int count;
@override@JsonKey(name: 'max_count') final  int maxCount;
@override@JsonKey(name: 'is_completed', fromJson: boolFromInt, toJson: intFromBool) final  bool isCompleted;

/// Create a copy of Mission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionCopyWith<_Mission> get copyWith => __$MissionCopyWithImpl<_Mission>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Mission&&(identical(other.idx, idx) || other.idx == idx)&&(identical(other.type, type) || other.type == type)&&(identical(other.count, count) || other.count == count)&&(identical(other.maxCount, maxCount) || other.maxCount == maxCount)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idx,type,count,maxCount,isCompleted);

@override
String toString() {
  return 'Mission(idx: $idx, type: $type, count: $count, maxCount: $maxCount, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$MissionCopyWith<$Res> implements $MissionCopyWith<$Res> {
  factory _$MissionCopyWith(_Mission value, $Res Function(_Mission) _then) = __$MissionCopyWithImpl;
@override @useResult
$Res call({
 int idx, MissionType type, int count,@JsonKey(name: 'max_count') int maxCount,@JsonKey(name: 'is_completed', fromJson: boolFromInt, toJson: intFromBool) bool isCompleted
});




}
/// @nodoc
class __$MissionCopyWithImpl<$Res>
    implements _$MissionCopyWith<$Res> {
  __$MissionCopyWithImpl(this._self, this._then);

  final _Mission _self;
  final $Res Function(_Mission) _then;

/// Create a copy of Mission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idx = null,Object? type = null,Object? count = null,Object? maxCount = null,Object? isCompleted = null,}) {
  return _then(_Mission(
idx: null == idx ? _self.idx : idx // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MissionType,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,maxCount: null == maxCount ? _self.maxCount : maxCount // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MissionsResult {

 List<Mission> get completed; List<Mission> get inProgress;
/// Create a copy of MissionsResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MissionsResultCopyWith<MissionsResult> get copyWith => _$MissionsResultCopyWithImpl<MissionsResult>(this as MissionsResult, _$identity);

  /// Serializes this MissionsResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MissionsResult&&const DeepCollectionEquality().equals(other.completed, completed)&&const DeepCollectionEquality().equals(other.inProgress, inProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(completed),const DeepCollectionEquality().hash(inProgress));

@override
String toString() {
  return 'MissionsResult(completed: $completed, inProgress: $inProgress)';
}


}

/// @nodoc
abstract mixin class $MissionsResultCopyWith<$Res>  {
  factory $MissionsResultCopyWith(MissionsResult value, $Res Function(MissionsResult) _then) = _$MissionsResultCopyWithImpl;
@useResult
$Res call({
 List<Mission> completed, List<Mission> inProgress
});




}
/// @nodoc
class _$MissionsResultCopyWithImpl<$Res>
    implements $MissionsResultCopyWith<$Res> {
  _$MissionsResultCopyWithImpl(this._self, this._then);

  final MissionsResult _self;
  final $Res Function(MissionsResult) _then;

/// Create a copy of MissionsResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? completed = null,Object? inProgress = null,}) {
  return _then(_self.copyWith(
completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as List<Mission>,inProgress: null == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as List<Mission>,
  ));
}

}


/// Adds pattern-matching-related methods to [MissionsResult].
extension MissionsResultPatterns on MissionsResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MissionsResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MissionsResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MissionsResult value)  $default,){
final _that = this;
switch (_that) {
case _MissionsResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MissionsResult value)?  $default,){
final _that = this;
switch (_that) {
case _MissionsResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Mission> completed,  List<Mission> inProgress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MissionsResult() when $default != null:
return $default(_that.completed,_that.inProgress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Mission> completed,  List<Mission> inProgress)  $default,) {final _that = this;
switch (_that) {
case _MissionsResult():
return $default(_that.completed,_that.inProgress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Mission> completed,  List<Mission> inProgress)?  $default,) {final _that = this;
switch (_that) {
case _MissionsResult() when $default != null:
return $default(_that.completed,_that.inProgress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MissionsResult implements MissionsResult {
  const _MissionsResult({required final  List<Mission> completed, required final  List<Mission> inProgress}): _completed = completed,_inProgress = inProgress;
  factory _MissionsResult.fromJson(Map<String, dynamic> json) => _$MissionsResultFromJson(json);

 final  List<Mission> _completed;
@override List<Mission> get completed {
  if (_completed is EqualUnmodifiableListView) return _completed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completed);
}

 final  List<Mission> _inProgress;
@override List<Mission> get inProgress {
  if (_inProgress is EqualUnmodifiableListView) return _inProgress;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inProgress);
}


/// Create a copy of MissionsResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MissionsResultCopyWith<_MissionsResult> get copyWith => __$MissionsResultCopyWithImpl<_MissionsResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MissionsResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MissionsResult&&const DeepCollectionEquality().equals(other._completed, _completed)&&const DeepCollectionEquality().equals(other._inProgress, _inProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_completed),const DeepCollectionEquality().hash(_inProgress));

@override
String toString() {
  return 'MissionsResult(completed: $completed, inProgress: $inProgress)';
}


}

/// @nodoc
abstract mixin class _$MissionsResultCopyWith<$Res> implements $MissionsResultCopyWith<$Res> {
  factory _$MissionsResultCopyWith(_MissionsResult value, $Res Function(_MissionsResult) _then) = __$MissionsResultCopyWithImpl;
@override @useResult
$Res call({
 List<Mission> completed, List<Mission> inProgress
});




}
/// @nodoc
class __$MissionsResultCopyWithImpl<$Res>
    implements _$MissionsResultCopyWith<$Res> {
  __$MissionsResultCopyWithImpl(this._self, this._then);

  final _MissionsResult _self;
  final $Res Function(_MissionsResult) _then;

/// Create a copy of MissionsResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? completed = null,Object? inProgress = null,}) {
  return _then(_MissionsResult(
completed: null == completed ? _self._completed : completed // ignore: cast_nullable_to_non_nullable
as List<Mission>,inProgress: null == inProgress ? _self._inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as List<Mission>,
  ));
}


}


/// @nodoc
mixin _$RewardItem {

 int get count; PlantAction get item;
/// Create a copy of RewardItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RewardItemCopyWith<RewardItem> get copyWith => _$RewardItemCopyWithImpl<RewardItem>(this as RewardItem, _$identity);

  /// Serializes this RewardItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RewardItem&&(identical(other.count, count) || other.count == count)&&(identical(other.item, item) || other.item == item));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,item);

@override
String toString() {
  return 'RewardItem(count: $count, item: $item)';
}


}

/// @nodoc
abstract mixin class $RewardItemCopyWith<$Res>  {
  factory $RewardItemCopyWith(RewardItem value, $Res Function(RewardItem) _then) = _$RewardItemCopyWithImpl;
@useResult
$Res call({
 int count, PlantAction item
});




}
/// @nodoc
class _$RewardItemCopyWithImpl<$Res>
    implements $RewardItemCopyWith<$Res> {
  _$RewardItemCopyWithImpl(this._self, this._then);

  final RewardItem _self;
  final $Res Function(RewardItem) _then;

/// Create a copy of RewardItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? item = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as PlantAction,
  ));
}

}


/// Adds pattern-matching-related methods to [RewardItem].
extension RewardItemPatterns on RewardItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RewardItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RewardItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RewardItem value)  $default,){
final _that = this;
switch (_that) {
case _RewardItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RewardItem value)?  $default,){
final _that = this;
switch (_that) {
case _RewardItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  PlantAction item)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RewardItem() when $default != null:
return $default(_that.count,_that.item);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  PlantAction item)  $default,) {final _that = this;
switch (_that) {
case _RewardItem():
return $default(_that.count,_that.item);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  PlantAction item)?  $default,) {final _that = this;
switch (_that) {
case _RewardItem() when $default != null:
return $default(_that.count,_that.item);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RewardItem implements RewardItem {
  const _RewardItem({required this.count, required this.item});
  factory _RewardItem.fromJson(Map<String, dynamic> json) => _$RewardItemFromJson(json);

@override final  int count;
@override final  PlantAction item;

/// Create a copy of RewardItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RewardItemCopyWith<_RewardItem> get copyWith => __$RewardItemCopyWithImpl<_RewardItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RewardItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RewardItem&&(identical(other.count, count) || other.count == count)&&(identical(other.item, item) || other.item == item));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,item);

@override
String toString() {
  return 'RewardItem(count: $count, item: $item)';
}


}

/// @nodoc
abstract mixin class _$RewardItemCopyWith<$Res> implements $RewardItemCopyWith<$Res> {
  factory _$RewardItemCopyWith(_RewardItem value, $Res Function(_RewardItem) _then) = __$RewardItemCopyWithImpl;
@override @useResult
$Res call({
 int count, PlantAction item
});




}
/// @nodoc
class __$RewardItemCopyWithImpl<$Res>
    implements _$RewardItemCopyWith<$Res> {
  __$RewardItemCopyWithImpl(this._self, this._then);

  final _RewardItem _self;
  final $Res Function(_RewardItem) _then;

/// Create a copy of RewardItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? item = null,}) {
  return _then(_RewardItem(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as PlantAction,
  ));
}


}


/// @nodoc
mixin _$CompleteMissionResult {

 MissionsResult get missions; RewardItem get reward;
/// Create a copy of CompleteMissionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompleteMissionResultCopyWith<CompleteMissionResult> get copyWith => _$CompleteMissionResultCopyWithImpl<CompleteMissionResult>(this as CompleteMissionResult, _$identity);

  /// Serializes this CompleteMissionResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompleteMissionResult&&(identical(other.missions, missions) || other.missions == missions)&&(identical(other.reward, reward) || other.reward == reward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,missions,reward);

@override
String toString() {
  return 'CompleteMissionResult(missions: $missions, reward: $reward)';
}


}

/// @nodoc
abstract mixin class $CompleteMissionResultCopyWith<$Res>  {
  factory $CompleteMissionResultCopyWith(CompleteMissionResult value, $Res Function(CompleteMissionResult) _then) = _$CompleteMissionResultCopyWithImpl;
@useResult
$Res call({
 MissionsResult missions, RewardItem reward
});


$MissionsResultCopyWith<$Res> get missions;$RewardItemCopyWith<$Res> get reward;

}
/// @nodoc
class _$CompleteMissionResultCopyWithImpl<$Res>
    implements $CompleteMissionResultCopyWith<$Res> {
  _$CompleteMissionResultCopyWithImpl(this._self, this._then);

  final CompleteMissionResult _self;
  final $Res Function(CompleteMissionResult) _then;

/// Create a copy of CompleteMissionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? missions = null,Object? reward = null,}) {
  return _then(_self.copyWith(
missions: null == missions ? _self.missions : missions // ignore: cast_nullable_to_non_nullable
as MissionsResult,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as RewardItem,
  ));
}
/// Create a copy of CompleteMissionResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MissionsResultCopyWith<$Res> get missions {
  
  return $MissionsResultCopyWith<$Res>(_self.missions, (value) {
    return _then(_self.copyWith(missions: value));
  });
}/// Create a copy of CompleteMissionResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RewardItemCopyWith<$Res> get reward {
  
  return $RewardItemCopyWith<$Res>(_self.reward, (value) {
    return _then(_self.copyWith(reward: value));
  });
}
}


/// Adds pattern-matching-related methods to [CompleteMissionResult].
extension CompleteMissionResultPatterns on CompleteMissionResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompleteMissionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompleteMissionResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompleteMissionResult value)  $default,){
final _that = this;
switch (_that) {
case _CompleteMissionResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompleteMissionResult value)?  $default,){
final _that = this;
switch (_that) {
case _CompleteMissionResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MissionsResult missions,  RewardItem reward)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompleteMissionResult() when $default != null:
return $default(_that.missions,_that.reward);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MissionsResult missions,  RewardItem reward)  $default,) {final _that = this;
switch (_that) {
case _CompleteMissionResult():
return $default(_that.missions,_that.reward);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MissionsResult missions,  RewardItem reward)?  $default,) {final _that = this;
switch (_that) {
case _CompleteMissionResult() when $default != null:
return $default(_that.missions,_that.reward);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompleteMissionResult implements CompleteMissionResult {
  const _CompleteMissionResult({required this.missions, required this.reward});
  factory _CompleteMissionResult.fromJson(Map<String, dynamic> json) => _$CompleteMissionResultFromJson(json);

@override final  MissionsResult missions;
@override final  RewardItem reward;

/// Create a copy of CompleteMissionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompleteMissionResultCopyWith<_CompleteMissionResult> get copyWith => __$CompleteMissionResultCopyWithImpl<_CompleteMissionResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompleteMissionResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompleteMissionResult&&(identical(other.missions, missions) || other.missions == missions)&&(identical(other.reward, reward) || other.reward == reward));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,missions,reward);

@override
String toString() {
  return 'CompleteMissionResult(missions: $missions, reward: $reward)';
}


}

/// @nodoc
abstract mixin class _$CompleteMissionResultCopyWith<$Res> implements $CompleteMissionResultCopyWith<$Res> {
  factory _$CompleteMissionResultCopyWith(_CompleteMissionResult value, $Res Function(_CompleteMissionResult) _then) = __$CompleteMissionResultCopyWithImpl;
@override @useResult
$Res call({
 MissionsResult missions, RewardItem reward
});


@override $MissionsResultCopyWith<$Res> get missions;@override $RewardItemCopyWith<$Res> get reward;

}
/// @nodoc
class __$CompleteMissionResultCopyWithImpl<$Res>
    implements _$CompleteMissionResultCopyWith<$Res> {
  __$CompleteMissionResultCopyWithImpl(this._self, this._then);

  final _CompleteMissionResult _self;
  final $Res Function(_CompleteMissionResult) _then;

/// Create a copy of CompleteMissionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? missions = null,Object? reward = null,}) {
  return _then(_CompleteMissionResult(
missions: null == missions ? _self.missions : missions // ignore: cast_nullable_to_non_nullable
as MissionsResult,reward: null == reward ? _self.reward : reward // ignore: cast_nullable_to_non_nullable
as RewardItem,
  ));
}

/// Create a copy of CompleteMissionResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MissionsResultCopyWith<$Res> get missions {
  
  return $MissionsResultCopyWith<$Res>(_self.missions, (value) {
    return _then(_self.copyWith(missions: value));
  });
}/// Create a copy of CompleteMissionResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RewardItemCopyWith<$Res> get reward {
  
  return $RewardItemCopyWith<$Res>(_self.reward, (value) {
    return _then(_self.copyWith(reward: value));
  });
}
}

// dart format on
