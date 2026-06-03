// 숫자 키패드 — 3×4(마지막 행 [빈칸, 0, 삭제]). RN components/lock/DigitKeypad + LOCK_SCREEN_DIGITS.
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:flutter/material.dart';

/// 잠금 비밀번호 입력용 숫자 키패드. RN `LOCK_SCREEN_DIGITS`(마지막 행 좌측 빈칸·우측 삭제) 레이아웃을 따른다.
class DigitKeypad extends StatelessWidget {
  const DigitKeypad({required this.onDigit, required this.onDelete, super.key});

  /// 숫자 입력 콜백.
  final ValueChanged<String> onDigit;

  /// 삭제(한 자리) 콜백.
  final VoidCallback onDelete;

  /// 키 배열. `null`=빈칸, `'delete'`=삭제 버튼. RN `LOCK_SCREEN_DIGITS` 1:1.
  static const List<List<String?>> _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    [null, '0', 'delete'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in _rows) Row(children: [for (final cell in row) Expanded(child: _cell(cell))]),
      ],
    );
  }

  Widget _cell(String? cell) {
    // RN numberButtonBox: height 95. 숫자 LIGHT_BLACK 20 Dovemayo · 삭제 Feather delete 25 LIGHT_BLACK.
    if (cell == null) {
      return const SizedBox(height: 95);
    }
    if (cell == 'delete') {
      return Semantics(
        button: true,
        label: SettingStrings.keypadDeleteLabel,
        child: InkResponse(
          onTap: onDelete,
          child: const SizedBox(
            height: 95,
            child: Icon(FeedIcons.keypadDelete, size: 25, color: FeedPalette.lightBlack),
          ),
        ),
      );
    }
    return Semantics(
      button: true,
      label: '숫자 $cell',
      child: InkResponse(
        onTap: () => onDigit(cell),
        child: SizedBox(
          height: 95,
          child: Center(
            child: Text(
              cell,
              style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 20, color: FeedPalette.lightBlack),
            ),
          ),
        ),
      ),
    );
  }
}
