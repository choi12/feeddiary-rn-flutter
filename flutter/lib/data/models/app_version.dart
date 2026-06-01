// 앱 최신 버전 응답 모델 — 플랫폼별 버전. RN etc/AppVersionResponse + DTO 매핑 대응.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_version.freezed.dart';
part 'app_version.g.dart';

/// 서버가 내려주는 플랫폼별 최신 버전. snake_case JSON 키를 camelCase 필드로 매핑
/// (RN 의 손수 DTO 변환과 동일 역할 — 백엔드 계약을 앱 모델과 분리).
@freezed
abstract class AppVersion with _$AppVersion {
  const factory AppVersion({
    @JsonKey(name: 'app_version_android') required String android,
    @JsonKey(name: 'app_version_ios') required String ios,
  }) = _AppVersion;

  factory AppVersion.fromJson(Map<String, dynamic> json) => _$AppVersionFromJson(json);
}
