// 설정 메뉴 행 — 70px·하단 보더·(아이콘)+라벨+chevron-right. RN MenuButton 1:1.
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:flutter/material.dart';

/// 설정 메인의 메뉴 한 줄. 좌측 (선택)아이콘+라벨, 우측 Octicons chevron-right.
/// 높이 70·하단 1px 보더·좌우 패딩 24. RN `MenuButton`(아이콘은 항목별 선택) 대응.
class FeedMenuRow extends StatelessWidget {
  const FeedMenuRow({required this.label, required this.onTap, this.icon, this.iconSize = 19, super.key});

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FeedPalette.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: AppDimens.menuRowHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: FeedPalette.whiteGray)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: iconSize, color: FeedPalette.lightBlack),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    label,
                    style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 14, color: FeedPalette.lightBlack),
                  ),
                ],
              ),
              const Icon(FeedIcons.menuChevron, size: 20, color: FeedPalette.lightGray),
            ],
          ),
        ),
      ),
    );
  }
}
