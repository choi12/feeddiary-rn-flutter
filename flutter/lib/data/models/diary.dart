// 일기 도메인 모델 — 목록(MyDiary)·캘린더(DailyDiary)·생성/좋아요 결과. RN api/diary/types 대응.
import 'package:feeddiary/data/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary.freezed.dart';
part 'diary.g.dart';

/// 내 일기 목록 항목. 백엔드 snake_case 응답을 camelCase 로 매핑(@JsonKey)해 백엔드 계약을 앱 모델과 분리한다.
/// RN `MyDiaryDTO`(commentCount 는 응답도 camelCase 라 @JsonKey 불필요).
@freezed
abstract class MyDiary with _$MyDiary {
  const factory MyDiary({
    required int idx,
    @JsonKey(name: 'user_idx') required int userIdx,
    required String nickname,
    required String sticker,
    required String text,
    String? image,
    @JsonKey(name: 'created_time') required DateTime createdAt,
    @JsonKey(name: 'updated_time') DateTime? updatedAt,
    @JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) required bool isVisible,
    @JsonKey(name: 'like_count') required int likeCount,
    required int commentCount,
  }) = _MyDiary;

  factory MyDiary.fromJson(Map<String, dynamic> json) => _$MyDiaryFromJson(json);
}

/// 캘린더 월별 조회 항목(작성자 정보 없는 경량 일기). RN `DailyDiaryDTO`.
@freezed
abstract class DailyDiary with _$DailyDiary {
  const factory DailyDiary({
    required int idx,
    required String sticker,
    required String text,
    String? image,
    @JsonKey(name: 'created_time') required DateTime createdAt,
    @JsonKey(name: 'updated_time') DateTime? updatedAt,
    @JsonKey(name: 'is_visible', fromJson: boolFromInt, toJson: intFromBool) required bool isVisible,
  }) = _DailyDiary;

  factory DailyDiary.fromJson(Map<String, dynamic> json) => _$DailyDiaryFromJson(json);
}

/// 일기 생성/수정 응답 — 생성된 일기 idx. RN `CreateDiaryResponse`(diaryIdx 는 응답도 camelCase).
@freezed
abstract class CreateDiaryResult with _$CreateDiaryResult {
  const factory CreateDiaryResult({required int diaryIdx}) = _CreateDiaryResult;

  factory CreateDiaryResult.fromJson(Map<String, dynamic> json) => _$CreateDiaryResultFromJson(json);
}

/// 좋아요 토글 응답. RN `LikeDiaryDTO`.
@freezed
abstract class LikeResult with _$LikeResult {
  const factory LikeResult({@JsonKey(name: 'like_count') required int likeCount, required bool isLike}) = _LikeResult;

  factory LikeResult.fromJson(Map<String, dynamic> json) => _$LikeResultFromJson(json);
}
