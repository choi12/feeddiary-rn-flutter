// 화분 도메인 모델 — 레벨·경험치·물주기/사랑 충전 수. RN api/flowerpot/types(FlowerpotResponse→DTO) 대응.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'flowerpot.freezed.dart';
part 'flowerpot.g.dart';

/// 화분 상태. 백엔드 snake_case 응답을 camelCase 로 매핑(@JsonKey)해 백엔드 계약을 앱 모델과 분리한다.
/// RN `FlowerpotDTO`(max_exp→maxExp, watering_count→wateringCount, love_count→loveCount).
@freezed
abstract class Flowerpot with _$Flowerpot {
  const factory Flowerpot({
    required int level,
    required int exp,
    @JsonKey(name: 'max_exp') required int maxExp,
    @JsonKey(name: 'watering_count') required int wateringCount,
    @JsonKey(name: 'love_count') required int loveCount,
    required bool showBadge,
  }) = _Flowerpot;

  factory Flowerpot.fromJson(Map<String, dynamic> json) => _$FlowerpotFromJson(json);
}
