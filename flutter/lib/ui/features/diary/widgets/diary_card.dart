// 일기 카드 — 날짜열·스티커·본문·공개여부(+좋아요/댓글 수)·상단 새싹 포인트. RN components/diary/DiaryCard 대응.
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/features/diary/sticker_catalog.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter/material.dart';

/// 카드 크기 — 대(목록/공유)·소(캘린더 일별). RN DiaryCard size large/small.
enum DiaryCardSize { large, small }

/// 일기 한 건 카드. [likeCount]/[commentCount]가 null 이면 카운트 줄을 숨긴다(캘린더 daily 카드).
/// 왼쪽 날짜열(DayBox) + 본문(ContentBox) 가로 배치, 상단을 살짝 뚫고 나오는 새싹 포인트로 RN 카드를 복제한다.
class DiaryCard extends StatelessWidget {
  const DiaryCard({
    required this.sticker,
    required this.text,
    required this.date,
    required this.isVisible,
    this.likeCount,
    this.commentCount,
    this.size = DiaryCardSize.large,
    this.onTap,
    super.key,
  });

  final String sticker;
  final String text;
  final DateTime date;
  final bool isVisible;
  final int? likeCount;
  final int? commentCount;
  final DiaryCardSize size;
  final VoidCallback? onTap;

  bool get _isLarge => size == DiaryCardSize.large;

  @override
  Widget build(BuildContext context) {
    final showCounts = likeCount != null || commentCount != null;
    final stickerSize = _isLarge ? 38.0 : 32.0;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: FeedPalette.white,
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimens.cardRadius),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DayBox(date: date, isLarge: _isLarge),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                StickerCatalog.assetFor(sticker),
                                width: stickerSize,
                                height: stickerSize,
                                fit: BoxFit.contain,
                              ),
                              const Spacer(),
                              VisibilityBadge(isVisible: isVisible),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            text,
                            maxLines: _isLarge ? 2 : 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: FeedFonts.dovemayo,
                              color: FeedPalette.lightBlack,
                              fontSize: 13,
                              height: 20 / 13,
                            ),
                          ),
                          if (showCounts) ...[
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (likeCount != null) DiaryCountChip(icon: FeedIcons.like, count: likeCount!),
                                if (commentCount != null) ...[
                                  const SizedBox(width: 15),
                                  DiaryCountChip(icon: FeedIcons.comment, count: commentCount!),
                                ],
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // 카드 상단을 살짝 뚫고 나오는 새싹 포인트. RN PointImage(FontAwesome5 seedling·absolute).
        CardSeedling(isLarge: _isLarge),
      ],
    );
  }
}

/// 카드 상단을 뚫고 나오는 새싹 포인트(Stack 직속 자식). RN PointImage(FontAwesome5 seedling).
class CardSeedling extends StatelessWidget {
  const CardSeedling({required this.isLarge, super.key});

  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 15,
      top: isLarge ? -14 : -12,
      child: Icon(FeedIcons.tabFlowerpot, size: isLarge ? 15 : 13, color: FeedPalette.main),
    );
  }
}

/// 날짜열 — 일(28/25)·월(15/13)을 우측 구분선과 함께 세로로. RN DayBox.
class DayBox extends StatelessWidget {
  const DayBox({required this.date, required this.isLarge, super.key});

  final DateTime date;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    final inset = isLarge ? 20.0 : 10.0;
    return Container(
      margin: EdgeInsets.only(right: inset),
      padding: EdgeInsets.only(right: inset),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: FeedPalette.whiteGray)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            pad2(date.day),
            style: TextStyle(
              fontFamily: FeedFonts.dovemayo,
              color: FeedPalette.darkGray,
              fontSize: isLarge ? 28 : 25,
              height: 1.1,
            ),
          ),
          Text(
            '${date.month}월',
            style: TextStyle(
              fontFamily: FeedFonts.dovemayo,
              color: FeedPalette.gray,
              fontSize: isLarge ? 15 : 13,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// 공개/비공개 배지. RN VisibilityBox(size small) — eye/eye-off + "공개 중"/"비공개".
class VisibilityBadge extends StatelessWidget {
  const VisibilityBadge({required this.isVisible, super.key});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final color = isVisible ? FeedPalette.main : FeedPalette.gray;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(isVisible ? FeedIcons.visibleOn : FeedIcons.visibleOff, size: 15, color: color),
        const SizedBox(width: 4),
        Text(
          isVisible ? '공개 중' : '비공개',
          style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 12, color: color),
        ),
      ],
    );
  }
}

/// 좋아요/댓글 수 — 회색 장식 아이콘 + 카운트(99 초과 시 99+). RN CountBox.
class DiaryCountChip extends StatelessWidget {
  const DiaryCountChip({required this.icon, required this.count, super.key});

  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: FeedPalette.lightGray),
        const SizedBox(width: 5),
        Text(
          count > 99 ? '99+' : '$count',
          style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.lightBlack),
        ),
      ],
    );
  }
}
