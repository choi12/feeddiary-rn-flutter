// 공통 입력 — 보더 #DDDDDD·radius14·흰 배경·Dovemayo/Ownglyph. RN TextInput 스타일 1:1.
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 입력 폰트. 닉네임/댓글=Dovemayo, 편지=Ownglyph. RN 입력 폰트 분기 대응.
enum FeedFieldFont { dovemayo, ownglyph }

/// 공통 텍스트 입력. 보더 1px #DDDDDD·radius 14·흰 배경·placeholder #D5D5D5.
/// 단일 행은 약 57px 높이, 멀티라인은 [maxLines]/[minLines]로 늘어난다. 포커스 시에도 보더 색을 유지한다(RN 동일).
class FeedTextField extends StatelessWidget {
  const FeedTextField({
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofocus = false,
    this.font = FeedFieldFont.dovemayo,
    this.fontSize = 14,
    super.key,
  });

  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final bool autofocus;
  final FeedFieldFont font;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final family = font == FeedFieldFont.ownglyph ? FeedFonts.ownglyph : FeedFonts.dovemayo;
    final isSingleLine = maxLines == 1;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.borderRadius),
      borderSide: const BorderSide(color: FeedPalette.input),
    );
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      autofocus: autofocus,
      cursorColor: FeedPalette.main,
      style: TextStyle(fontFamily: family, fontSize: fontSize, color: FeedPalette.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontFamily: family, fontSize: fontSize, color: FeedPalette.lightGray),
        filled: true,
        fillColor: FeedPalette.white,
        counterText: '',
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isSingleLine ? 18 : 14),
        enabledBorder: border,
        focusedBorder: border,
        border: border,
      ),
    );
  }
}
