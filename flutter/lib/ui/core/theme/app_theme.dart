// feedDiary 앱 테마 빌더 — 디자인 토큰을 ThemeData 로 조립(라이트).
import 'package:feeddiary/ui/core/theme/app_colors.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:flutter/material.dart';

/// feedDiary 라이트 [ThemeData]. 시맨틱 토큰([AppColors])을 [ThemeData.extensions]로 주입하고,
/// Material 컬러스킴/기본 폰트를 디자인 토큰에 맞춘다.
ThemeData buildAppTheme() {
  final colors = AppColors.light();
  final colorScheme = ColorScheme.fromSeed(
    seedColor: FeedPalette.green,
    primary: colors.primary,
    error: colors.error,
    surface: colors.surface,
  );

  return ThemeData(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colors.background,
    fontFamily: FeedFonts.dovemayo,
    // RN 은 잉크 리플/하이라이트가 없다(AnimatedPressable=scale·opacity / Pressable=무피드백) → 전역 제거.
    // 주 버튼의 누름 축소·투명 모션은 FeedPressable 이 따로 담당한다.
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    extensions: <ThemeExtension<dynamic>>[colors],
  );
}
