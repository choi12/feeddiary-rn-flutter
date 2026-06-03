// 번들 에셋 경로 상수 — RN src/assets 이식분의 단일 출처. 경로 하드코딩을 막는다.
/// 도메인 카탈로그(스티커=`StickerCatalog`)가 아닌 단발 에셋(편지지/핀·화분 캐릭터·Lottie) 경로를 모아 둔다.
abstract final class AppAssets {
  static const String _img = 'assets/images';
  static const String _lottie = 'assets/lottie';

  // 편지(편지함 카드·펼침 모달 비주얼). RN assets/images/letter.
  static const String letterPaper = '$_img/letter/letter_paper.png';
  static const String letterPin = '$_img/letter/pin.png';
  static const String letterBoard = '$_img/letter/letter_board.png';
  static const String letterIcon = '$_img/letter/letter.png';

  // 화분 캐릭터(레벨 1~3). RN assets/images/home.
  static const List<String> _lemonyLevels = [
    '$_img/home/lemony1.png',
    '$_img/home/lemony2.png',
    '$_img/home/lemony3.png',
  ];

  /// 레벨(1~3)에 대응하는 레모니 캐릭터 PNG. 범위를 벗어나면 가장 가까운 레벨로 클램프.
  static String lemonyForLevel(int level) => _lemonyLevels[level.clamp(1, 3) - 1];

  // 화분 풀 캔버스 배경(하늘/땅). RN assets/images/home(HomeBGTop/Bottom).
  static const String flowerpotBgTop = '$_img/home/bg_top.png';
  static const String flowerpotBgBottom = '$_img/home/bg_bottom.png';

  // 화분 액션/미션 버튼(RN FastImage). RN assets/images/home.
  static const String wateringPlant = '$_img/home/watering.png';
  static const String lovePlant = '$_img/home/love.png';
  static const String missionIcon = '$_img/home/mission.png';

  // 경험치 바(레벨 배너·다음 단계 미리보기 원). RN assets/images/home.
  static const String levelBox = '$_img/home/level_box.png';
  static const String lemony2Preview = '$_img/home/lemony2_preview.png';
  static const String lemony3Preview = '$_img/home/lemony3_preview.png';

  // 식물 레벨별 상세 아트(L1 화분+씨앗·L3 열매). RN assets/images/home.
  static const String lemony1Flowerpot = '$_img/home/lemony1_flowerpot.png';
  static const String lemonySeed = '$_img/home/lemony_seed.png';
  static const String lemony3New = '$_img/home/lemony3_new.png';

  // 캘린더(일기 있는 날 마커·배경 워터마크). RN assets/images(diary/pencil·home/grayscale).
  static const String calendarPencil = '$_img/diary/pencil.png';
  static const String lemonyGrayscale = '$_img/home/lemony3_preview_grayscale.png';

  // 프로필 닉네임 검증 피드백 아이콘. RN assets/images/profile.
  static const String profileSuccess = '$_img/profile/success.png';
  static const String profileError = '$_img/profile/error.png';

  // Lottie(물/사랑 피드백 + 화분 캔버스 앰비언트 새/풍선 + 일기 좋아요 하트). RN assets/lottie.
  static const String lottieRain = '$_lottie/rain.json';
  static const String lottieHeart = '$_lottie/heart.json';
  static const String lottieBirds = '$_lottie/birds.json';
  static const String lottieBaloon = '$_lottie/heart_baloon.json';
  static const String lottieHeartGreen = '$_lottie/heart_green.json';

  // 로그인/계정(앱 버전 로고·설정 계정 박스 소셜 로고). RN assets/images/signIn.
  static const String logo = '$_img/signin/logo.png';
  static const String appleIcon = '$_img/signin/apple.png';
  static const String googleIcon = '$_img/signin/google.png';

  // 로그인 화면 캐릭터 캔버스(잔디밭·레모니·해·물뿌리개). RN assets/images/signIn.
  static const String signInField = '$_img/signin/field.png';
  static const String signInLemony = '$_img/signin/lemony_main.png';
  static const String signInSun = '$_img/signin/sun.png';
  static const String signInWatering = '$_img/signin/watering.png';
}
