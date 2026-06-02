// 미션 저장소 — 미션 목록 조회 + 완료(보상). RN api/mission/APIxxx 1:1 (core Dio+guardApiCall 위).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/models/api_response.dart';
import 'package:feeddiary/data/models/mission.dart';
import 'package:feeddiary/data/services/api_guard.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/domain/models/mission_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mission_repository.g.dart';

/// 미션 API 저장소. core [guardApiCall] + envelope 언랩. RN `APIGetMissions`/`APICompleteMission`.
class MissionRepository {
  MissionRepository(this._dio);

  final Dio _dio;

  /// 미션 목록(진행중/완료). RN `APIGetMissions`.
  Future<MissionsResult> getMissions() {
    return guardApiCall('미션 리스트', () async {
      final response = await _dio.get<Map<String, dynamic>>('/mission/list');
      return _unwrap(response.data!, MissionsResult.fromJson);
    });
  }

  /// 미션 완료(보상 받기). 갱신된 미션 묶음 + 받은 보상을 반환. RN `APICompleteMission`.
  Future<CompleteMissionResult> completeMission({required int missionIdx, required MissionType type}) {
    return guardApiCall('미션 완료(보상 받기)', () async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/mission',
        data: {'mission_idx': missionIdx, 'type': type.name},
      );
      return _unwrap(response.data!, CompleteMissionResult.fromJson);
    });
  }

  R _unwrap<R>(Map<String, dynamic> json, R Function(Map<String, dynamic>) fromJson) {
    final envelope = ApiResponse.fromJson(json, (data) => fromJson(data! as Map<String, dynamic>));
    return envelope.resData!;
  }
}

@riverpod
MissionRepository missionRepository(Ref ref) => MissionRepository(ref.watch(dioProvider));
