// 하단 탭바 — 75px·상단 radius20·옅은 그림자·활성 MAIN/비활성 LIGHT_GRAY·Dovemayo 11 라벨. RN BottomTabNavigation.
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/theme/tokens/shadows.dart';
import 'package:flutter/material.dart';

/// 탭 1개 정의(아이콘·라벨·아이콘 크기·아이콘 미세 보정). RN `BOTTOM_TAB_ICON`(+ Letters size 23) 대응.
class FeedTabItem {
  const FeedTabItem({required this.icon, required this.label, this.iconSize = 21, this.iconOffset = Offset.zero});

  final IconData icon;
  final String label;
  final double iconSize;

  /// 아이콘 잉크 중앙 보정. FA5 `user-friends`(공유)는 글리프 잉크가 advance 박스보다 우측으로 치우쳐
  /// Flutter 텍스트 엔진에서 라벨 중앙선보다 ~2px 오른쪽으로 보인다 → 좌측으로 당겨 라벨과 시각 중앙을 맞춘다.
  final Offset iconOffset;
}

/// 메인 하단 탭바. 75px(+하단 안전영역)·흰 배경·상단 좌우 radius 20·옅은 그림자.
/// 활성 MAIN(#B8D698)/비활성 LIGHT_GRAY(#D5D5D5), 라벨 Dovemayo 11px·letterSpacing -0.5. RN `tabBarStyle` 1:1.
class FeedTabBar extends StatelessWidget {
  const FeedTabBar({required this.currentIndex, required this.onTap, required this.items, super.key});

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<FeedTabItem> items;

  static const _decoration = BoxDecoration(
    color: FeedPalette.white,
    borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.tabBarTopRadius)),
    boxShadow: FeedShadows.tabBar,
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _decoration,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppDimens.bottomTabHeight,
          child: Padding(
            padding: const EdgeInsets.only(left: AppDimens.padding, right: AppDimens.padding, bottom: 10),
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _TabCell(item: items[i], selected: i == currentIndex, onTap: () => onTap(i)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabCell extends StatelessWidget {
  const _TabCell({required this.item, required this.selected, required this.onTap});

  final FeedTabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? FeedPalette.main : FeedPalette.lightGray;
    return InkResponse(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.translate(
            offset: item.iconOffset,
            child: Icon(item.icon, size: item.iconSize, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 11, letterSpacing: -0.5, color: color),
          ),
        ],
      ),
    );
  }
}
