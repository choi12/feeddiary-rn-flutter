// 편지 도메인 모델 — 나에게 쓰는 편지 한 건(본문·작성시각). RN api/letter/types(LetterResponse→LetterDTO) 대응.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'letter.freezed.dart';
part 'letter.g.dart';

/// 편지 한 통. 백엔드 snake_case(created_time)를 camelCase(createdAt)로 매핑해 계약을 앱 모델과 분리한다. RN `LetterDTO`.
/// deleted_time 은 RN 과 동일하게 무시한다(json_serializable 이 미인식 키를 건너뜀).
@freezed
abstract class Letter with _$Letter {
  const factory Letter({
    required int idx,
    required String text,
    @JsonKey(name: 'created_time') required DateTime createdAt,
  }) = _Letter;

  factory Letter.fromJson(Map<String, dynamic> json) => _$LetterFromJson(json);
}
