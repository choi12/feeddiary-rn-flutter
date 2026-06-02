// 편지 화면 문자열·제약 상수 — RN constants(TEXT.LETTER/PLACEHOLDER.LETTER/MODAL_CONTENT.LETTER/MODAL_BUTTON) 1:1.

/// 편지 기능의 사용자 표시 문자열·제약. 하드코딩 대신 한곳에 모아 RN 문자열과 맞춘다.
abstract final class LetterStrings {
  // 편지함(목록)
  static const String headerTitle = '나에게 쓰는 편지';
  static const String writeCta = '오늘의 나에게 편지 쓰기';
  static const String writeDone = '오늘의 편지 작성 완료!';
  static const String empty = '나에게 첫 편지를 보내 보세요 :D';
  static const String to = '나에게';
  static const String editOn = '편집';
  static const String editOff = '편집 취소';

  // 작성 화면
  static const String writeTitle = '편지 쓰기';
  static const String placeholder = '오늘의 나에게...';
  static const String info = '편지는 하루에 최대 한 개만 보낼 수 있어요.';
  static const int maxLength = 50;
  static const String sendButton = '보내기';

  // 삭제 확인
  static const String deleteConfirm = '편지를 삭제하시겠어요?';
  static const String deleteButton = '삭제하기';
  static const String closeButton = '닫기';

  // 토스트
  static const String sentToast = '나에게 편지를 보냈어요.';
  static const String deletedToast = '편지가 삭제되었어요.';

  /// 작성 화면 글자 수 카운터(`{n} / 최대 50자`). RN LetterInput 카운트.
  static String counter(int length) => '$length / 최대 $maxLength자';
}
