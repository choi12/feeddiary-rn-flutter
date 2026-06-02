// 공통 헤더 — 70px·하단 보더·중앙 제목·뒤로/닫기·rightItem. RN components/common/CustomHeader.
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:flutter/material.dart';

/// 헤더 제목 폰트. RN `FontType`(DOVEMAYO 17px·ONGLE 24px Ownglyph) 대응.
enum FeedHeaderFont { dovemayo, ownglyph }

/// 화면 상단 커스텀 헤더. `Scaffold.appBar` 슬롯에 쓰는 [PreferredSizeWidget] 이다. RN `CustomHeader` 1:1.
///
/// 높이 70(+상단 안전영역)·흰 배경·하단 1px 보더(닫기 버튼이 있으면 보더 없음)·제목 중앙 정렬.
/// 좌측 뒤로 버튼(Ionicons arrow-back 25)·우측 닫기(Ionicons close 28)/`rightItem` 슬롯.
class FeedHeader extends StatelessWidget implements PreferredSizeWidget {
  const FeedHeader({
    required this.title,
    this.titleWidget,
    this.font = FeedHeaderFont.dovemayo,
    this.rightItem,
    this.hasBackButton = false,
    this.hasCloseButton = false,
    this.onBack,
    this.onClose,
    this.backgroundColor,
    super.key,
  });

  final String title;
  final Widget? titleWidget;
  final FeedHeaderFont font;
  final Widget? rightItem;
  final bool hasBackButton;
  final bool hasCloseButton;
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final Color? backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(AppDimens.headerHeight);

  TextStyle get _titleStyle => switch (font) {
    FeedHeaderFont.ownglyph => const TextStyle(
      fontFamily: FeedFonts.ownglyph,
      fontSize: 24,
      color: FeedPalette.lightBlack,
      letterSpacing: -0.5,
    ),
    FeedHeaderFont.dovemayo => const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 17, color: FeedPalette.black),
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? FeedPalette.white,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: AppDimens.headerHeight,
          decoration: hasCloseButton
              ? null
              : const BoxDecoration(
                  border: Border(bottom: BorderSide(color: FeedPalette.whiteGray)),
                ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              titleWidget ?? Text(title, style: _titleStyle),
              if (hasBackButton)
                Align(
                  alignment: Alignment.centerLeft,
                  child: _HeaderIconButton(
                    icon: FeedIcons.back,
                    size: 25,
                    padding: const EdgeInsets.fromLTRB(AppDimens.padding, 13, 13, 13),
                    onTap: onBack ?? () => Navigator.of(context).maybePop(),
                  ),
                ),
              if (hasCloseButton || rightItem != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (hasCloseButton)
                        _HeaderIconButton(
                          icon: FeedIcons.close,
                          size: 28,
                          padding: const EdgeInsets.fromLTRB(13, 13, AppDimens.padding, 13),
                          onTap: onClose ?? () => Navigator.of(context).maybePop(),
                        ),
                      if (rightItem != null)
                        Padding(
                          padding: const EdgeInsets.only(right: AppDimens.padding),
                          child: rightItem,
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 헤더 좌/우 아이콘 버튼(뒤로·닫기). RN BackButton/CloseButton 의 padding·색을 따른다.
class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.size, required this.padding, required this.onTap});

  final IconData icon;
  final double size;
  final EdgeInsets padding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Padding(
        padding: padding,
        child: Icon(icon, size: size, color: FeedPalette.black),
      ),
    );
  }
}
