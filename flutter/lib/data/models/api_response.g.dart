// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiResponse<T> _$ApiResponseFromJson<T>(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
    _ApiResponse<T>(
      status: json['status'] as String,
      message: json['message'] as String?,
      resData: _$nullableGenericFromJson(json['resData'], fromJsonT),
    );

Map<String, dynamic> _$ApiResponseToJson<T>(_ApiResponse<T> instance, Object? Function(T value) toJsonT) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'resData': _$nullableGenericToJson(instance.resData, toJsonT),
    };

T? _$nullableGenericFromJson<T>(Object? input, T Function(Object? json) fromJson) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(T? input, Object? Function(T value) toJson) => input == null ? null : toJson(input);
