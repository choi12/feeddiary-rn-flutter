// 화분 경험치 진행 표시 — 레벨 배너 + 그라데이션 프로그레스 바 + 다음 단계 미리보기 원. RN ExpBox 대응.
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/theme/tokens/shadows.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_stats.dart';
import 'package:flutter/material.dart';

/// 레벨 배너 + exp 프로그레스 바(lime→main 그라데이션 채움·1초) + 다음 단계 미리보기 원(skyblue). RN ExpBox.
class ExpProgress extends StatelessWidget {
  const ExpProgress({required this.stats, super.key});

  final FlowerpotStats stats;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 트랙(세로 중앙·full width). 우측 38은 미리보기 원 자리.
          Positioned(
            left: 0,
            right: 0,
            top: 10,
            child: _Track(progress: stats.expProgress, isMax: stats.isMaxLevel),
          ),
          // 레벨 배너(좌상단으로 살짝 올라옴).
          Positioned(
            top: -18,
            left: 0,
            child: _LevelTag(level: stats.level, isMax: stats.isMaxLevel),
          ),
          // 다음 단계 미리보기 원(우측·세로 중앙).
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: _PreviewCircle(level: stats.level, isMax: stats.isMaxLevel),
            ),
          ),
        ],
      ),
    );
  }
}

/// 트랙 — 반투명 흰 그라데이션 pill(22·r100) + lime→main 채움(18). RN ProgressBar.
class _Track extends StatelessWidget {
  const _Track({required this.progress, required this.isMax});

  final double progress;
  final bool isMax;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.only(right: 38),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: FeedPalette.white.withValues(alpha: 0.7)),
        gradient: LinearGradient(
          colors: [FeedPalette.white.withValues(alpha: 0.898), FeedPalette.white.withValues(alpha: 0.2)],
        ),
      ),
      child: isMax ? null : _Fill(progress: progress),
    );
  }
}

class _Fill extends StatelessWidget {
  const _Fill({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final percent = '${(progress * 100).toStringAsFixed(1)}%';
    final inside = progress > 0.25;
    return LayoutBuilder(
      builder: (context, constraints) {
        final fullWidth = constraints.maxWidth;
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: progress),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOut,
          builder: (context, value, _) {
            final fillWidth = fullWidth * value;
            return Stack(
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: fillWidth,
                  height: 18,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    gradient: LinearGradient(colors: [FeedPalette.lime, FeedPalette.main]),
                  ),
                ),
                Positioned(
                  left: inside ? null : fillWidth + 5,
                  right: inside ? (fullWidth - fillWidth) + 6 : null,
                  child: Text(
                    percent,
                    style: TextStyle(
                      fontFamily: FeedFonts.dovemayo,
                      fontSize: inside ? 13 : 14,
                      color: inside ? FeedPalette.white : FeedPalette.main,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// 레벨 배너 — level_box.png(50×25·opacity 0.9) + "Lv.N"(흰 13, 최대 "Lv. Max" 12). RN LevelTag.
class _LevelTag extends StatelessWidget {
  const _LevelTag({required this.level, required this.isMax});

  final int level;
  final bool isMax;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 25,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(opacity: 0.9, child: Image.asset(AppAssets.levelBox, width: 50, height: 25, fit: BoxFit.contain)),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              isMax ? 'Lv. Max' : 'Lv.$level',
              style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: isMax ? 12 : 13, color: FeedPalette.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// 다음 단계 미리보기 원 — 42 skyblue 원 안에 다음 레벨 캐릭터(70%) 또는 "Max". RN ProgressBarCircle.
class _PreviewCircle extends StatelessWidget {
  const _PreviewCircle({required this.level, required this.isMax});

  final int level;
  final bool isMax;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: FeedPalette.skyblue,
        shape: BoxShape.circle,
        border: Border.all(color: FeedPalette.white.withValues(alpha: 0.7)),
        boxShadow: FeedShadows.tabBar,
      ),
      child: isMax
          ? const Text(
              'Max',
              style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 10, color: FeedPalette.white),
            )
          : Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(level == 1 ? AppAssets.lemony2Preview : AppAssets.lemony3Preview, fit: BoxFit.contain),
            ),
    );
  }
}
