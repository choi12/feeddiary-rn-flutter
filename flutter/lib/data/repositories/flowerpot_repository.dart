// 화분 저장소 — 화분 조회 + 물주기/사랑주기. RN api/flowerpot/APIxxx 1:1 (core Dio+guardApiCall 위).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/models/api_response.dart';
import 'package:feeddiary/data/models/flowerpot.dart';
import 'package:feeddiary/data/services/api_guard.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flowerpot_repository.g.dart';

/// 화분 API 저장소. 모든 호출을 core [guardApiCall]로 감싸 에러를 도메인 예외로 정규화하고
/// envelope([ApiResponse])를 언랩한다. 물주기/사랑주기는 응답이 status 뿐이라 void 다.
class FlowerpotRepository {
  FlowerpotRepository(this._dio);

  final Dio _dio;

  /// 화분 상태(레벨·경험치·충전) 조회. RN `APIGetFlowerpot`.
  Future<Flowerpot> getFlowerpot() {
    return guardApiCall('나의 화분', () async {
      final response = await _dio.get<Map<String, dynamic>>('/flowerpot');
      return _unwrap(response.data!, Flowerpot.fromJson);
    });
  }

  /// 물 주기(경험치 증가·충전 소비는 서버 계산). RN `APIWateringPlant`.
  Future<void> wateringPlant() {
    return guardApiCall('물 주기', () async {
      await _dio.post<dynamic>('/flowerpot/watering');
    });
  }

  /// 사랑 주기. 거동은 [wateringPlant]와 동일. RN `APILovePlant`.
  Future<void> lovePlant() {
    return guardApiCall('사랑 주기', () async {
      await _dio.post<dynamic>('/flowerpot/love');
    });
  }

  R _unwrap<R>(Map<String, dynamic> json, R Function(Map<String, dynamic>) fromJson) {
    final envelope = ApiResponse.fromJson(json, (data) => fromJson(data! as Map<String, dynamic>));
    return envelope.resData!;
  }
}

@riverpod
FlowerpotRepository flowerpotRepository(Ref ref) => FlowerpotRepository(ref.watch(dioProvider));
