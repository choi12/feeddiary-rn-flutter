// 바텀시트 — 상단 radius14·행 paddingV25·gap7·마지막 보더 제거. RN modal/BottomSheetModal + showFeedSheet.
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:flutter/material.dart';

/// 바텀시트 항목 1개. 제목·(선택)색·(선택)아이콘·탭 콜백. RN bottomSheet content item.
class FeedSheetItem {
  const FeedSheetItem({required this.title, required this.onPressed, this.color, this.icon});

  final String title;
  final VoidCallback onPressed;
  final Color? color;
  final IconData? icon;
}

/// RN `BottomSheetModal` 디자인의 시트를 띄운다. dim rgba(0,0,0,0.3)·하단 정렬·상단 radius 14.
/// 항목 탭 시 시트를 닫은 뒤 onPressed 를 호출한다(RN 동작 순서 동일).
Future<void> showFeedSheet({required BuildContext context, required List<FeedSheetItem> items}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: FeedPalette.scrim,
    builder: (_) => _FeedBottomSheet(items: items),
  );
}

class _FeedBottomSheet extends StatelessWidget {
  const _FeedBottomSheet({required this.items});

  final List<FeedSheetItem> items;

  static const _decoration = BoxDecoration(
    color: FeedPalette.white,
    borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.borderRadius)),
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _decoration,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [for (var i = 0; i < items.length; i++) _SheetRow(item: items[i], isLast: i == items.length - 1)],
          ),
        ),
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({required this.item, required this.isLast});

  final FeedSheetItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = item.color ?? FeedPalette.lightBlack;
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        item.onPressed();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 25),
        decoration: isLast
            ? null
            : const BoxDecoration(
                border: Border(bottom: BorderSide(color: FeedPalette.whiteGray)),
              ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (item.icon != null) ...[Icon(item.icon, size: 18, color: color), const SizedBox(width: 7)],
            Text(
              item.title,
              style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 16, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
