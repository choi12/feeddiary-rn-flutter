// 사용자 모델 — 인증 응답을 앱 도메인 모델로 매핑. RN api/auth/types(UserResponse→UserDTO) 대응.
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// 인증된 사용자. 백엔드 snake_case 응답을 camelCase 필드로 매핑(@JsonKey)해
/// 백엔드 계약을 앱 모델과 분리한다(RN 의 손수 `toUserDTO` 변환과 동일 역할).
@freezed
abstract class User with _$User {
  const factory User({
    required int idx,
    required String account,
    @JsonKey(name: 'user_id') required String userId,
    required String nickname,
    required String image,
    required String background,
    required String character,
    required SignInType type,
    @JsonKey(name: 'created_time') required DateTime createdAt,
    required String token,
    @JsonKey(name: 'fcm_token') String? fcmToken,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
