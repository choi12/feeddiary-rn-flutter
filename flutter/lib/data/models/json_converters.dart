// JSON 변환 헬퍼 — 백엔드 정수 불리언(0/1)을 Dart bool 로 매핑. RN zod ZeroOrOne 대응.

/// `is_visible` 등 백엔드의 0|1 정수를 bool 로 변환한다(@JsonKey fromJson).
bool boolFromInt(int value) => value == 1;

/// bool 을 백엔드 0|1 정수로 직렬화한다(@JsonKey toJson).
int intFromBool(bool value) => value ? 1 : 0;
