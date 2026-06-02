// 번들 에셋 경로 상수 — RN src/assets 이식분의 단일 출처. 경로 하드코딩을 막는다.
/// 도메인 카탈로그(스티커=`StickerCatalog`)가 아닌 단발 에셋(편지지/핀·화분 캐릭터·Lottie) 경로를 모아 둔다.
abstract final class AppAssets {
  static const String _img = 'assets/images';
  static const String _lottie = 'assets/lottie';

  // 편지(편지함 카드·펼침 모달 비주얼). RN assets/images/letter.
  static const String letterPaper = '$_img/letter/letter_paper.png';
  static const String letterPin = '$_img/letter/pin.png';
  static const String letterBoard = '$_img/letter/letter_board.png';

  // 화분 캐릭터(레벨 1~3). RN assets/images/home.
  static const List<String> _lemonyLevels = [
    '$_img/home/lemony1.png',
    '$_img/home/lemony2.png',
    '$_img/home/lemony3.png',
  ];

  /// 레벨(1~3)에 대응하는 레모니 캐릭터 PNG. 범위를 벗어나면 가장 가까운 레벨로 클램프.
  static String lemonyForLevel(int level) => _lemonyLevels[level.clamp(1, 3) - 1];

  // Lottie(물/사랑 피드백). RN assets/lottie.
  static const String lottieRain = '$_lottie/rain.json';
  static const String lottieHeart = '$_lottie/heart.json';

  // 로그인/계정(앱 버전 로고·설정 계정 박스 소셜 로고). RN assets/images/signIn.
  static const String logo = '$_img/signin/logo.png';
  static const String appleIcon = '$_img/signin/apple.png';
  static const String googleIcon = '$_img/signin/google.png';
}
