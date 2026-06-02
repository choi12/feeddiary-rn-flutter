// 공유 일기 저장소 — 커뮤니티 목록/댓글 CRUD/신고. RN api/community·comment APIxxx 1:1 (core Dio+guardApiCall 위).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/models/api_response.dart';
import 'package:feeddiary/data/models/comment.dart';
import 'package:feeddiary/data/models/community_diary.dart';
import 'package:feeddiary/data/services/api_guard.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/domain/models/community_sort.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_repository.g.dart';

/// 공유 일기/댓글 API 저장소. diary_repository 와 동일하게 [guardApiCall] 로 에러를 도메인 예외로 정규화하고
/// 응답 envelope([ApiResponse])를 언랩한다. 좋아요는 `diary_repository.likeDiary` 를 재사용한다(중복 금지).
class CommunityRepository {
  CommunityRepository(this._dio);

  final Dio _dio;

  /// 공유(공개) 일기 목록(정렬·오프셋 페이지네이션). RN `APIGetCommunityDiaries`.
  Future<List<CommunityDiary>> getCommunityDiaries({required int skip, required CommunitySort sort}) {
    return guardApiCall('공유 일기 리스트', () async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/diary/community-list',
        queryParameters: {'skip': skip, 'sort_type': sort.queryValue},
      );
      return _unwrapList(response.data!, CommunityDiary.fromJson);
    });
  }

  /// 특정 일기의 댓글 목록. RN `APIGetComments`.
  Future<List<Comment>> getComments({required int diaryIdx}) {
    return guardApiCall('댓글 리스트', () async {
      final response = await _dio.get<Map<String, dynamic>>('/comment/list/$diaryIdx');
      return _unwrapList(response.data!, Comment.fromJson);
    });
  }

  /// 댓글 작성. RN `APICreateComment`.
  Future<void> createComment({required int diaryIdx, required String text}) {
    return guardApiCall('댓글 작성', () async {
      await _dio.post<Map<String, dynamic>>('/comment', data: {'diary_idx': diaryIdx, 'text': text.trim()});
    });
  }

  /// 댓글 삭제. RN `APIDeleteComment`.
  Future<void> deleteComment({required int commentIdx}) {
    return guardApiCall('댓글 삭제', () async {
      await _dio.delete<dynamic>('/comment/$commentIdx');
    });
  }

  /// 일기 신고(작성자 차단). [blockIdx]는 신고자(본인) idx. RN `APIReportDiary`.
  Future<void> reportDiary({required int diaryIdx, required String text, required int blockIdx}) {
    return guardApiCall('일기 신고(유저 차단)', () async {
      await _dio.post<Map<String, dynamic>>(
        '/diary/report',
        data: {'diary_idx': diaryIdx, 'text': text.trim(), 'block_idx': blockIdx},
      );
    });
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
CommunityRepository communityRepository(Ref ref) => CommunityRepository(ref.watch(dioProvider));
