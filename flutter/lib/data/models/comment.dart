// 댓글 도메인 모델 — 작성자 프로필·본문·작성시각. RN api/comment/types 대응.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

/// 일기 댓글 한 건. 백엔드 snake_case 응답을 camelCase 로 매핑(@JsonKey)해 계약을 앱 모델과 분리한다. RN `CommentDTO`.
@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required int idx,
    required String nickname,
    required String background,
    required String character,
    required String text,
    @JsonKey(name: 'created_time') required DateTime createdAt,
    @JsonKey(name: 'user_image') required String userImage,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}
