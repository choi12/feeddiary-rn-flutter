// 주 버튼 — 100%·54px·radius14·MAIN·비활성/로딩(INPUT+인디케이터). RN components/common/CustomButton.
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:flutter/material.dart';

/// 화면 주 버튼. 가득 찬 너비·54px·MAIN(#B8D698) 배경·흰 17px 라벨.
/// 비활성/로딩 시 INPUT(#DDDDDD) 배경이 되고, 로딩이면 라벨 대신 인디케이터를 보인다. RN `CustomButton` 1:1.
class FeedButton extends StatelessWidget {
  const FeedButton({
    required this.title,
    required this.onPressed,
    this.disabled = false,
    this.isLoading = false,
    super.key,
  });

  final String title;
  final VoidCallback onPressed;
  final bool disabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final inactive = disabled || isLoading;
    return SizedBox(
      width: double.infinity,
      height: AppDimens.buttonHeight,
      child: Material(
        color: inactive ? FeedPalette.input : FeedPalette.main,
        borderRadius: BorderRadius.circular(AppDimens.borderRadius),
        child: InkWell(
          onTap: inactive ? null : onPressed,
          borderRadius: BorderRadius.circular(AppDimens.borderRadius),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: FeedPalette.white),
                  )
                : Text(
                    title,
                    style: const TextStyle(color: FeedPalette.white, fontSize: 17, fontFamily: FeedFonts.dovemayo),
                  ),
          ),
        ),
      ),
    );
  }
}
