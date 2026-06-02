// 공유 일기 / 일기 상세 모델 — 내 일기 필드 + 작성자 프로필·좋아요 여부. RN api/community/types 대응.
import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/data/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_diary.freezed.dart';
part 'community_diary.g.dart';

/// 공유 일기/상세 항목. `MyDiary` 필드에 작성자 프로필(userImage/background/character)과
/// 좋아요 여부(isLike)를 더한 superset. 상세(`/diary/:idx`)와 공유 목록(PR⑤)이 사용. RN `CommunityDiaryDTO`.
@freezed
abstract class CommunityDiary with _$CommunityDiary {
  const factory CommunityDiary({
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
    @JsonKey(name: 'user_image') required String userImage,
    required String background,
    required String character,
    required bool isLike,
  }) = _CommunityDiary;

  factory CommunityDiary.fromJson(Map<String, dynamic> json) => _$CommunityDiaryFromJson(json);
}

/// 수정 화면 전달용 — 공유 필드만 추려 `MyDiary` 로 변환. RN CreateDiary 가 CommunityDiaryDTO 를 받던 것 대응.
extension CommunityDiaryX on CommunityDiary {
  MyDiary toMyDiary() => MyDiary(
    idx: idx,
    userIdx: userIdx,
    nickname: nickname,
    sticker: sticker,
    text: text,
    image: image,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isVisible: isVisible,
    likeCount: likeCount,
    commentCount: commentCount,
  );
}
