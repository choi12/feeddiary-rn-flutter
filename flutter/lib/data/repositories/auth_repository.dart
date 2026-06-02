// 인증 저장소 — 로그인/자동로그인/회원가입/닉네임검사/로그아웃. RN api/auth/APIxxx 1:1 (core Dio+guardApiCall 위).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/models/api_response.dart';
import 'package:feeddiary/data/models/user.dart';
import 'package:feeddiary/data/services/api_guard.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

/// 자체 백엔드 인증 API 저장소. 모든 호출을 core [guardApiCall]로 감싸 에러를 도메인 예외로
/// 정규화하고, 응답 envelope([ApiResponse])를 언랩해 [User]로 반환한다.
class AuthRepository {
  AuthRepository(this._dio);

  final Dio _dio;

  /// 자체 백엔드 로그인. OAuth 로 얻은 [userId](UID)로 access token 을 발급받는다. RN `APISignIn`.
  /// 신규 사용자는 401 → `UnauthorizedException`이 그대로 전파(상위에서 CreateProfile 분기).
  Future<User> signIn({required String userId, required String fcmToken}) {
    return guardApiCall('로그인', () async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/sign-in',
        data: {'user_id': userId, 'fcm_token': fcmToken},
      );
      return _unwrapUser(response.data!);
    });
  }

  /// 저장된 토큰으로 세션을 복원한다. RN `APIAutoSignIn`.
  Future<User> autoSignIn({required String accessToken}) {
    return guardApiCall('자동 로그인', () async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/sign-in-auto/v2',
        data: {'access_token': accessToken},
      );
      return _unwrapUser(response.data!);
    });
  }

  /// 프로필을 포함한 회원가입(multipart). RN `APISignUp` + useSignUp.prepareFormData.
  Future<User> signUp({
    required String userId,
    required String email,
    required SignInType type,
    required String nickname,
    required String image,
    required String background,
    required String character,
    required String fcmToken,
  }) {
    return guardApiCall('회원가입', () async {
      final form = FormData.fromMap({
        'type': type.name,
        'account': email,
        'user_id': userId,
        'nickname': nickname,
        'image': image,
        'background': background,
        'character': character,
        'fcm_token': fcmToken,
      });
      final response = await _dio.post<Map<String, dynamic>>('/auth/sign-up', data: form);
      return _unwrapUser(response.data!);
    });
  }

  /// 닉네임 중복 검사. 사용 가능하면 정상 반환, 중복(409)이면 `ConflictException`. RN `APICheckNickname`.
  Future<void> checkNickname(String nickname) {
    return guardApiCall('닉네임 중복 검사', () async {
      await _dio.post<dynamic>('/auth/check-nickname', data: {'nickname': nickname});
    });
  }

  /// 로그아웃. RN `APISignOut`.
  Future<void> signOut() {
    return guardApiCall('로그아웃', () async {
      await _dio.post<dynamic>('/auth/sign-out');
    });
  }

  User _unwrapUser(Map<String, dynamic> json) {
    final envelope = ApiResponse.fromJson(json, (data) => User.fromJson(data! as Map<String, dynamic>));
    return envelope.resData!;
  }
}

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository(ref.watch(dioProvider));
