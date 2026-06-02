// 소셜 로그인 제공자 종류 — RN types/auth.ts SignInType 대응.

/// 소셜 로그인 제공자. JSON 직렬화는 enum 이름(`google`/`apple`)을 그대로 사용
/// (json_serializable 기본 매핑)하여 백엔드 `type` 필드와 1:1로 대응한다.
enum SignInType { google, apple }
