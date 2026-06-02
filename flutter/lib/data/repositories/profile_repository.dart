// 프로필 저장소 — 프로필 수정(multipart)/계정 탈퇴. RN api/user/APIUpdateProfile·APIDeleteAccount 1:1 (core Dio+guardApiCall 위).
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:feeddiary/data/models/api_response.dart';
import 'package:feeddiary/data/models/user.dart';
import 'package:feeddiary/data/services/api_guard.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

/// 프로필 수정/계정 탈퇴 API 저장소. 닉네임 중복 검사는 `AuthRepository.checkNickname`을 재사용한다.
class ProfileRepository {
  ProfileRepository(this._dio);

  final Dio _dio;

  /// 프로필 수정(multipart). 사진([imageBytes])이 있으면 파일로, 없으면 빈 문자열로 보낸다. RN `APIUpdateProfile`.
  Future<User> updateProfile({
    required String nickname,
    required String background,
    required String character,
    Uint8List? imageBytes,
  }) {
    return guardApiCall('프로필 수정', () async {
      final form = FormData.fromMap({
        'nickname': nickname,
        'background': background,
        'character': character,
        'image': imageBytes != null ? MultipartFile.fromBytes(imageBytes, filename: 'profile.jpg') : '',
      });
      final response = await _dio.put<Map<String, dynamic>>('/user', data: form);
      return _unwrapUser(response.data!);
    });
  }

  /// 계정 탈퇴. RN `APIDeleteAccount`(DELETE /user).
  Future<void> deleteAccount() {
    return guardApiCall('계정 탈퇴', () async {
      await _dio.delete<dynamic>('/user');
    });
  }

  User _unwrapUser(Map<String, dynamic> json) {
    final envelope = ApiResponse.fromJson(json, (data) => User.fromJson(data! as Map<String, dynamic>));
    return envelope.resData!;
  }
}

@riverpod
ProfileRepository profileRepository(Ref ref) => ProfileRepository(ref.watch(dioProvider));
