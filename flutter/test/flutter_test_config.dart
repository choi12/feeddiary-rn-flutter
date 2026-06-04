// 골든 테스트가 Ahem 박스가 아닌 실제 글리프로 렌더되도록 모든 번들 폰트를 로드하는 전역 테스트 설정.
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// 모든 테스트 실행 전 폰트를 로드한다. 골든의 텍스트·아이콘 글리프 렌더용이며 비골든 테스트엔 영향이 없다.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadFonts();
  await testMain();
}

/// pubspec 에 번들된 본문/손글씨 폰트 + RN 아이콘 .ttf 8종을 FontLoader 로 등록한다.
/// family 이름은 pubspec 의 fonts 선언과 정확히 일치해야 위젯이 글리프를 찾는다.
Future<void> _loadFonts() async {
  const fonts = <String, String>{
    'Dovemayo_gothic': 'assets/fonts/Dovemayo_gothic.ttf',
    'Ownglyph_PDH-Rg': 'assets/fonts/Ownglyph_PDH-Rg.ttf',
    'FontAwesome5_Solid': 'assets/fonts/icons/FontAwesome5_Solid.ttf',
    'FontAwesome': 'assets/fonts/icons/FontAwesome.ttf',
    'Ionicons': 'assets/fonts/icons/Ionicons.ttf',
    'AntDesign': 'assets/fonts/icons/AntDesign.ttf',
    'Octicons': 'assets/fonts/icons/Octicons.ttf',
    'Feather': 'assets/fonts/icons/Feather.ttf',
    'MaterialCommunityIcons': 'assets/fonts/icons/MaterialCommunityIcons.ttf',
    'Entypo': 'assets/fonts/icons/Entypo.ttf',
  };
  for (final entry in fonts.entries) {
    final bytes = await File(entry.value).readAsBytes();
    await (FontLoader(entry.key)..addFont(Future.value(ByteData.sublistView(bytes)))).load();
  }
}
