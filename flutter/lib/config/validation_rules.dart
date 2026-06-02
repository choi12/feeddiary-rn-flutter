// 입력 검증 규칙 — 닉네임 정규식·최대 길이·안내문. RN constants/validation/regex + ui/textInput 대응.

/// 폼 입력 검증 규칙. RN `NICKNAME_REGEX`/`NICKNAME_MAX_LENGTH`/`TEXT.PROFILE.NICKNAME` 대응.
abstract final class ValidationRules {
  /// 닉네임: 한글/영문/숫자 2~8자. RN `NICKNAME_REGEX`.
  static final RegExp nicknameRegex = RegExp(r'^[ㄱ-ㅎ가-힣a-zA-Z0-9]{2,8}$');

  /// 닉네임 최대 길이. RN `NICKNAME_MAX_LENGTH`.
  static const int nicknameMaxLength = 8;

  /// 닉네임 입력 안내문(정규식과 동기화). RN `TEXT.PROFILE.NICKNAME`.
  static const String nicknameHint = '한글, 영어, 숫자 2~8자';
}
