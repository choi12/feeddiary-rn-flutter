// 일기 저장소 — 목록/월별/상세/생성/수정/삭제/좋아요/공개설정. RN api/diary/APIxxx 1:1 (core Dio+guardApiCall 위).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/models/api_response.dart';
import 'package:feeddiary/data/models/community_diary.dart';
import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/data/models/json_converters.dart';
import 'package:feeddiary/data/services/api_guard.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'diary_repository.g.dart';

/// 일기 API 저장소. 모든 호출을 core [guardApiCall]로 감싸 에러를 도메인 예외로 정규화하고,
/// 응답 envelope([ApiResponse])를 언랩해 typed 모델로 반환한다. 작성/수정 multipart 는 이 경계에서 구성한다.
class DiaryRepository {
  DiaryRepository(this._dio);

  final Dio _dio;

  /// 내 일기 목록(오프셋 페이지네이션). RN `APIGetDiaries`.
  Future<List<MyDiary>> getDiaries({required int skip}) {
    return guardApiCall('나의 일기 리스트', () async {
      final response = await _dio.get<Map<String, dynamic>>('/diary/list', queryParameters: {'skip': skip});
      return _unwrapList(response.data!, MyDiary.fromJson);
    });
  }

  /// 특정 월(`YYYY-MM`)의 일기 목록(캘린더용). RN `APIGetMonthlyDiaries`.
  Future<List<DailyDiary>> getMonthlyDiaries({required String month}) {
    return guardApiCall('월별 일기 리스트', () async {
      final response = await _dio.get<Map<String, dynamic>>('/diary/list-by-month/$month');
      return _unwrapList(response.data!, DailyDiary.fromJson);
    });
  }

  /// 일기 상세(작성자 프로필·좋아요 포함). RN `APIGetDiary`(CommunityDiaryDTO 반환).
  Future<CommunityDiary> getDiary({required int diaryIdx}) {
    return guardApiCall('일기 상세', () async {
      final response = await _dio.get<Map<String, dynamic>>('/diary/$diaryIdx');
      return _unwrap(response.data!, CommunityDiary.fromJson);
    });
  }

  /// 일기 등록(multipart). 생성된 idx 를 반환. RN `APICreateDiary` + useWriteDiary.prepareDiaryData.
  Future<int> createDiary({required String sticker, required String text, required DateTime date}) {
    return guardApiCall('일기 등록', () async {
      final form = FormData.fromMap({
        'sticker': sticker,
        'image': '',
        'text': text.trim(),
        'date': date.toIso8601String(),
      });
      final response = await _dio.post<Map<String, dynamic>>('/diary', data: form);
      return _unwrap(response.data!, CreateDiaryResult.fromJson).diaryIdx;
    });
  }

  /// 일기 수정(multipart). [imageText]는 유지할 기존 이미지(삭제 시 빈 문자열). RN `APIEditDiary`.
  Future<int> editDiary({
    required int diaryIdx,
    required String sticker,
    required String text,
    required DateTime date,
    String? imageText,
  }) {
    return guardApiCall('일기 수정', () async {
      final form = FormData.fromMap({
        'sticker': sticker,
        'image': '',
        'text': text.trim(),
        'date': date.toIso8601String(),
        'diary_idx': diaryIdx,
        'image_text': imageText ?? '',
      });
      final response = await _dio.put<Map<String, dynamic>>('/diary', data: form);
      return _unwrap(response.data!, CreateDiaryResult.fromJson).diaryIdx;
    });
  }

  /// 일기 삭제. RN `APIDeleteDiary`.
  Future<void> deleteDiary({required int diaryIdx}) {
    return guardApiCall('일기 삭제', () async {
      await _dio.delete<dynamic>('/diary/$diaryIdx');
    });
  }

  /// 좋아요 토글. RN `APILikeDiary`.
  Future<LikeResult> likeDiary({required int diaryIdx}) {
    return guardApiCall('일기 좋아요', () async {
      final response = await _dio.post<Map<String, dynamic>>('/diary/like', data: {'diary_idx': diaryIdx});
      return _unwrap(response.data!, LikeResult.fromJson);
    });
  }

  /// 공개 여부 토글. 변경된 공개 여부를 반환. RN `APISetVisibility`.
  Future<bool> setVisibility({required int diaryIdx}) {
    return guardApiCall('일기 공개 설정', () async {
      final response = await _dio.post<Map<String, dynamic>>('/diary/visibility', data: {'diary_idx': diaryIdx});
      final envelope = ApiResponse.fromJson(
        response.data!,
        (data) => (data! as Map<String, dynamic>)['is_visible'] as int,
      );
      return boolFromInt(envelope.resData!);
    });
  }

  R _unwrap<R>(Map<String, dynamic> json, R Function(Map<String, dynamic>) fromJson) {
    final envelope = ApiResponse.fromJson(json, (data) => fromJson(data! as Map<String, dynamic>));
    return envelope.resData!;
  }

  List<R> _unwrapList<R>(Map<String, dynamic> json, R Function(Map<String, dynamic>) fromJson) {
    final envelope = ApiResponse.fromJson(
      json,
      (data) => (data! as List).map((e) => fromJson(e as Map<String, dynamic>)).toList(),
    );
    return envelope.resData!;
  }
}

@riverpod
DiaryRepository diaryRepository(Ref ref) => DiaryRepository(ref.watch(dioProvider));
