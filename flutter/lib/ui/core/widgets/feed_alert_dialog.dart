// 알림 다이얼로그 — 300px·radius14·로고+메시지+버튼행(취소|확인). RN modal/AlertModal + showFeedAlert.
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:flutter/material.dart';

/// 알림 버튼 1개. `isCancel`=좌측 취소(우측 보더+회색 글자), 아니면 확인(MAIN 글자). RN AlertModalButton.
class FeedAlertAction {
  const FeedAlertAction({required this.text, required this.onPressed, this.isCancel = false, this.isLoading = false});

  final String text;
  final VoidCallback onPressed;
  final bool isCancel;
  final bool isLoading;
}

/// RN `AlertModal` 디자인의 다이얼로그를 띄운다. dim rgba(0,0,0,0.3)·페이드·상단 로고.
/// 버튼 onPressed 는 자동으로 닫지 않으므로, 닫거나 값을 돌려주려면 onPressed 안에서 `Navigator.of(context).pop(value)` 한다.
Future<T?> showFeedAlert<T>({
  required BuildContext context,
  String? message,
  Widget? image,
  required List<FeedAlertAction> actions,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: FeedPalette.scrim,
    builder: (_) => _FeedAlertDialog(message: message, image: image, actions: actions),
  );
}

class _FeedAlertDialog extends StatelessWidget {
  const _FeedAlertDialog({this.message, this.image, required this.actions});

  final String? message;
  final Widget? image;
  final List<FeedAlertAction> actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: FeedPalette.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.borderRadius)),
      child: SizedBox(
        width: AppDimens.dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppAssets.logo, height: 14, fit: BoxFit.contain),
                  if (image != null) Padding(padding: const EdgeInsets.only(top: 15), child: image),
                  if (message != null)
                    Padding(
                      padding: EdgeInsets.only(top: image != null ? 10 : 20, bottom: image != null ? 0 : 20),
                      child: Text(
                        message!,
                        style: const TextStyle(
                          fontFamily: FeedFonts.dovemayo,
                          fontSize: 14,
                          color: FeedPalette.black,
                          height: 20 / 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: FeedPalette.whiteGray)),
              ),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [for (final a in actions) Expanded(child: _AlertButton(action: a))],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertButton extends StatelessWidget {
  const _AlertButton({required this.action});

  final FeedAlertAction action;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: action.isCancel
          ? const BoxDecoration(
              border: Border(right: BorderSide(color: FeedPalette.whiteGray)),
            )
          : const BoxDecoration(),
      child: InkWell(
        onTap: action.isLoading ? null : action.onPressed,
        child: Center(
          child: action.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: FeedPalette.main),
                )
              : Text(
                  action.text,
                  style: TextStyle(
                    fontFamily: FeedFonts.dovemayo,
                    fontSize: 14,
                    color: action.isCancel ? FeedPalette.lightBlack : FeedPalette.main,
                  ),
                ),
        ),
      ),
    );
  }
}
