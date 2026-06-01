// 디자인 토큰 L2/L3 — 시맨틱·컴포넌트 색상을 ThemeExtension 으로 노출.
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:flutter/material.dart';

/// 시맨틱(L2)·컴포넌트(L3) 색상 토큰.
///
/// 원시 팔레트([FeedPalette], L1)를 의미 단위로 매핑한 [ThemeExtension]이다.
/// 위젯에서는 `context.colors.primary` 형태로 접근한다(`build_context_x.dart`).
/// 현재는 라이트 테마만 제공하나, [ThemeExtension] 구조라 다크 테마 확장 여지를 남긴다.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.background,
    required this.surface,
    required this.outline,
    required this.textPrimary,
    required this.textSecondary,
    required this.error,
    required this.buttonBackground,
    required this.buttonForeground,
    required this.inputBackground,
  });

  /// feedDiary 라이트 테마 토큰. RN 색상 의미 매핑을 그대로 따른다.
  factory AppColors.light() => const AppColors(
    // L2 시맨틱
    primary: FeedPalette.green,
    onPrimary: FeedPalette.white,
    background: FeedPalette.whiteGray,
    surface: FeedPalette.white,
    outline: FeedPalette.lightGray,
    textPrimary: FeedPalette.black,
    textSecondary: FeedPalette.darkGray,
    error: FeedPalette.red,
    // L3 컴포넌트
    buttonBackground: FeedPalette.green,
    buttonForeground: FeedPalette.white,
    inputBackground: FeedPalette.input,
  );

  // L2 시맨틱
  final Color primary;
  final Color onPrimary;
  final Color background;
  final Color surface;
  final Color outline;
  final Color textPrimary;
  final Color textSecondary;
  final Color error;

  // L3 컴포넌트
  final Color buttonBackground;
  final Color buttonForeground;
  final Color inputBackground;

  @override
  AppColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? background,
    Color? surface,
    Color? outline,
    Color? textPrimary,
    Color? textSecondary,
    Color? error,
    Color? buttonBackground,
    Color? buttonForeground,
    Color? inputBackground,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      outline: outline ?? this.outline,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      error: error ?? this.error,
      buttonBackground: buttonBackground ?? this.buttonBackground,
      buttonForeground: buttonForeground ?? this.buttonForeground,
      inputBackground: inputBackground ?? this.inputBackground,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      error: Color.lerp(error, other.error, t)!,
      buttonBackground: Color.lerp(buttonBackground, other.buttonBackground, t)!,
      buttonForeground: Color.lerp(buttonForeground, other.buttonForeground, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
    );
  }
}
