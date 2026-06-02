// 화분 경험치 진행 표시 — 레벨 태그 + 경험치 프로그레스 바(부드러운 채움). RN ExpBox(LevelTag/ProgressBar) 대응.
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_stats.dart';
import 'package:flutter/material.dart';

/// 레벨 배지 + exp 진행률 바. 진행률은 [TweenAnimationBuilder]로 부드럽게 채운다.
class ExpProgress extends StatelessWidget {
  const ExpProgress({required this.stats, super.key});

  final FlowerpotStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: BorderRadius.circular(AppDimens.borderRadius),
              ),
              child: Text(
                'Lv.${stats.level}',
                style: TextStyle(color: context.colors.onPrimary, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              stats.isMaxLevel ? '최고 레벨이에요!' : '${stats.exp} / ${stats.maxExp}',
              style: TextStyle(color: context.colors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.borderRadius),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: stats.expProgress),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 12,
              backgroundColor: context.colors.outline,
              color: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
