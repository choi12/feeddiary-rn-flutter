// 일기 카드 — 스티커·날짜·본문·공개여부(+좋아요/댓글 수). RN components/diary/DiaryCard 대응.
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/features/diary/sticker_catalog.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter/material.dart';

/// 일기 한 건 카드. [likeCount]/[commentCount]가 null 이면 카운트 줄을 숨긴다(캘린더 daily 카드).
class DiaryCard extends StatelessWidget {
  const DiaryCard({
    required this.sticker,
    required this.text,
    required this.date,
    required this.isVisible,
    this.likeCount,
    this.commentCount,
    this.onTap,
    super.key,
  });

  final String sticker;
  final String text;
  final DateTime date;
  final bool isVisible;
  final int? likeCount;
  final int? commentCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final showCounts = likeCount != null || commentCount != null;
    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(AppDimens.borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.borderRadius),
            border: Border.all(color: context.colors.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(StickerCatalog.assetFor(sticker), width: 40, height: 40, fit: BoxFit.contain),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(formatYmd(date), style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
                  ),
                  VisibilityBadge(isVisible: isVisible),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: context.colors.textPrimary, height: 1.5),
              ),
              if (showCounts) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    if (likeCount != null) _CountChip(icon: Icons.favorite_border, count: likeCount!),
                    if (commentCount != null) ...[
                      const SizedBox(width: 16),
                      _CountChip(icon: Icons.chat_bubble_outline, count: commentCount!),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 공개/비공개 배지. RN VisibilityBox.
class VisibilityBadge extends StatelessWidget {
  const VisibilityBadge({required this.isVisible, super.key});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final color = isVisible ? context.colors.primary : context.colors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 16, color: color),
        const SizedBox(width: 4),
        Text(isVisible ? '공개' : '비공개', style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({required this.icon, required this.count});

  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: context.colors.textSecondary),
        const SizedBox(width: 4),
        Text('$count', style: TextStyle(fontSize: 13, color: context.colors.textSecondary)),
      ],
    );
  }
}
