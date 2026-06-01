// 공통 API 응답 envelope — { status, message?, resData? }. RN api/types.ts(APIResponse<T>) 대응.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// 백엔드 공통 응답 래퍼. 실제 페이로드는 [resData]에 담긴다.
/// 제네릭 직렬화를 위해 fromJson 에 `fromJsonT` 변환 함수를 받는다(`genericArgumentFactories`).
@Freezed(genericArgumentFactories: true)
abstract class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({required String status, String? message, T? resData}) = _ApiResponse<T>;

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ApiResponseFromJson(json, fromJsonT);
}
