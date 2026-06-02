// RN react-native-vector-icons 글리프 → Flutter IconData 중앙 매핑. 화면은 FeedIcons.x 로만 참조(아이콘 하드코딩 금지).
import 'package:flutter/material.dart';

/// RN `VectorIcon`(type+name)을 Flutter `IconData` 로 1:1 매핑한 중앙 사전.
///
/// RN 과 동일한 react-native-vector-icons `.ttf` 폰트를 직접 번들하고(pubspec `fonts:`), 같은 코드포인트로
/// const IconData 를 정의한다 → 글리프가 RN 과 동일하다. (Flutter 3.44 에서 IconData 가 final 이 되어 아이콘
/// 패키지의 IconData 상속이 컴파일 불가하므로 폰트 직접 번들 방식을 쓴다.) MaterialIcons 세트는 Flutter
/// 빌트인 [Icons](= Material Icons 폰트)로 충분하다. 모든 항목이 const 라 릴리스 빌드의 아이콘 트리셰이킹이 유지된다.
abstract final class FeedIcons {
  // 번들 아이콘 폰트 패밀리(pubspec `fonts:` 선언과 일치).
  static const String _fa5 = 'FontAwesome5_Solid';
  static const String _fa = 'FontAwesome';
  static const String _ion = 'Ionicons';
  static const String _ant = 'AntDesign';
  static const String _oct = 'Octicons';
  static const String _feather = 'Feather';
  static const String _mci = 'MaterialCommunityIcons';
  static const String _entypo = 'Entypo';

  // ── 하단 탭 (RN FontAwesome5, Letters=MaterialCommunityIcons) ──
  static const IconData tabFlowerpot = IconData(0xf4d8, fontFamily: _fa5); // FA5 seedling
  static const IconData tabDiary = IconData(0xf02d, fontFamily: _fa5); // FA5 book
  static const IconData tabCommunity = IconData(0xf500, fontFamily: _fa5); // FA5 user-friends
  static const IconData tabLetters = IconData(0xf01ee, fontFamily: _mci); // MCI email
  static const IconData tabSetting = IconData(0xf013, fontFamily: _fa5); // FA5 cog

  // ── 헤더 (Ionicons / Entypo) ──
  static const IconData back = IconData(0xea28, fontFamily: _ion); // Ionicons arrow-back
  static const IconData close = IconData(0xeb4b, fontFamily: _ion); // Ionicons close
  static const IconData more = IconData(0xf181, fontFamily: _entypo); // Entypo dots-three-horizontal

  // ── 설정 메뉴 ──
  static const IconData settingLock = IconData(0xe67b, fontFamily: _ant); // AntDesign lock
  static const IconData settingSupport = IconData(0xf01f0, fontFamily: _mci); // MCI email-outline
  static const IconData menuChevron = IconData(0xf130, fontFamily: _oct); // Octicons chevron-right

  // ── 일기 상세 / 카드 ──
  static const IconData like = IconData(0xec6b, fontFamily: _ion); // Ionicons heart
  static const IconData comment = IconData(0xf0184, fontFamily: _mci); // MCI comment-processing
  static const IconData report = Icons.block; // MaterialIcons block
  static const IconData visibleOn = IconData(0xebe7, fontFamily: _ion); // Ionicons eye
  static const IconData visibleOff = IconData(0xebe8, fontFamily: _ion); // Ionicons eye-off

  // ── 나의 일기 / 캘린더 ──
  static const IconData calendar = IconData(0xf13c, fontFamily: _entypo); // Entypo calendar
  static const IconData listView = IconData(0xf1e5, fontFamily: _entypo); // Entypo list
  static const IconData caretDown = IconData(0xeaf5, fontFamily: _ion); // Ionicons caret-down-outline
  static const IconData monthPrev = IconData(0xe605, fontFamily: _ant); // AntDesign caretleft
  static const IconData monthNext = IconData(0xe604, fontFamily: _ant); // AntDesign caretright

  // ── 일기 작성 ──
  static const IconData addPhoto = Icons.add_photo_alternate; // MaterialIcons add-photo-alternate
  static const IconData trash = IconData(0xf1f5, fontFamily: _feather); // Feather trash-2
  static const IconData stickerCheck = IconData(0xf22b, fontFamily: _oct); // Octicons check-circle-fill

  // ── 편지 ──
  static const IconData minus = IconData(0xf1fc, fontFamily: _entypo); // Entypo minus
  static const IconData alert = IconData(0xf102, fontFamily: _feather); // Feather alert-circle

  // ── 공유 일기(커뮤니티) ──
  static const IconData check = IconData(0xf12b, fontFamily: _feather); // Feather check
  static const IconData verified = Icons.verified; // MaterialIcons verified
  static const IconData send = IconData(0xf28e, fontFamily: _oct); // Octicons paper-airplane

  // ── 프로필 ──
  static const IconData profileUser = IconData(0xf007, fontFamily: _fa); // FontAwesome user
  static const IconData plus = IconData(0xe627, fontFamily: _ant); // AntDesign plus
  static const IconData colorize = Icons.colorize; // MaterialIcons colorize
  static const IconData question = IconData(0xe63a, fontFamily: _ant); // AntDesign question
  static const IconData backgroundFill = IconData(0xf0266, fontFamily: _mci); // MCI format-color-fill
  static const IconData expandDown = IconData(0xeb33, fontFamily: _ion); // Ionicons chevron-down
  static const IconData expandUp = IconData(0xeb42, fontFamily: _ion); // Ionicons chevron-up

  // ── 기타 ──
  static const IconData scrollTop = IconData(0xe66c, fontFamily: _ant); // AntDesign totop
  static const IconData keypadDelete = IconData(0xf155, fontFamily: _feather); // Feather delete
}
