// 앱 버전 저장소 + 서버상태 provider — core 대표 슬라이스. RN etc/APIGetAppVersion + React Query 대응.
import 'package:dio/dio.dart';
import 'package:feeddiary/data/models/api_response.dart';
import 'package:feeddiary/data/models/app_version.dart';
import 'package:feeddiary/data/services/api_guard.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/utils/cache_policy.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_version_repository.g.dart';

/// 앱 버전 조회 저장소. Dio 로 호출하고 envelope 를 언랩해 현재 플랫폼 버전을 반환한다.
class AppVersionRepository {
  AppVersionRepository(this._dio);

  static const String _operation = '앱 버전';

  final Dio _dio;

  /// 현재 플랫폼의 최신 버전 문자열. RN `APIGetAppVersion`.
  Future<String> fetchLatestVersion() {
    return guardApiCall(_operation, () async {
      final response = await _dio.get<Map<String, dynamic>>('/etc/app-version');
      final envelope = ApiResponse.fromJson(
        response.data!,
        (json) => AppVersion.fromJson(json! as Map<String, dynamic>),
      );
      final version = envelope.resData!;
      return defaultTargetPlatform == TargetPlatform.android ? version.android : version.ios;
    });
  }
}

@riverpod
AppVersionRepository appVersionRepository(Ref ref) => AppVersionRepository(ref.watch(dioProvider));

/// 최신 앱 버전(서버상태). RN React Query 패턴 대응 — cacheFor 로 gcTime 을 적용하고,
/// 갱신은 `ref.invalidate(latestAppVersionProvider)`로 수행한다.
@riverpod
Future<String> latestAppVersion(Ref ref) {
  ref.cacheFor(CachePolicy.standardGcTime);
  return ref.watch(appVersionRepositoryProvider).fetchLatestVersion();
}
