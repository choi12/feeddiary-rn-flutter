// 편지 저장소 — 나의 편지 목록/작성/삭제. RN api/letter APIxxx 1:1 (core Dio+guardApiCall 위).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/models/api_response.dart';
import 'package:feeddiary/data/models/letter.dart';
import 'package:feeddiary/data/services/api_guard.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'letter_repository.g.dart';

/// 편지 API 저장소. community_repository 와 동일하게 [guardApiCall] 로 에러를 도메인 예외로 정규화하고
/// 응답 envelope([ApiResponse])를 언랩한다. 편지는 격리 도메인이라 작성/삭제 응답 body 는 무시한다(목록만 갱신).
class LetterRepository {
  LetterRepository(this._dio);

  final Dio _dio;

  /// 나의 편지 목록(오프셋 페이지네이션). RN `APIGetLetters`.
  Future<List<Letter>> getLetters({required int skip}) {
    return guardApiCall('나의 편지 리스트', () async {
      final response = await _dio.get<Map<String, dynamic>>('/letter/list', queryParameters: {'skip': skip});
      return _unwrapList(response.data!, Letter.fromJson);
    });
  }

  /// 편지 작성(하루 한 통). RN `APICreateLetter`.
  Future<void> createLetter({required String text}) {
    return guardApiCall('편지 등록', () async {
      await _dio.post<Map<String, dynamic>>('/letter', data: {'text': text.trim()});
    });
  }

  /// 편지 삭제. RN `APIDeleteLetter`.
  Future<void> deleteLetter({required int letterIdx}) {
    return guardApiCall('편지 삭제', () async {
      await _dio.delete<dynamic>('/letter/$letterIdx');
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
LetterRepository letterRepository(Ref ref) => LetterRepository(ref.watch(dioProvider));
