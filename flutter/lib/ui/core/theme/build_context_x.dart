// context.colors 확장 — 위젯에서 시맨틱 색상 토큰(AppColors)에 간결히 접근.
import 'package:feeddiary/ui/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// `BuildContext`에서 디자인 토큰에 접근하는 확장.
extension AppThemeX on BuildContext {
  /// 현재 테마의 시맨틱/컴포넌트 색상 토큰. 예: `context.colors.primary`.
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
