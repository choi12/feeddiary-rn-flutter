// 일기 날짜 선택 모달 — 인앱 캘린더(월 이동·6주 격자, 미래 비활성). RN CreateDiary DatePicker(CalendarModal) 대응.
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/features/diary/calendar_grid.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter/material.dart';

const List<String> _weekdayLabels = ['일', '월', '화', '수', '목', '금', '토'];

/// 인앱 캘린더 모달로 [initial] 기준 날짜를 고른다(미래 불가). 선택 시 그 날짜를, 취소 시 null 을 반환한다.
Future<DateTime?> showDiaryDatePicker({required BuildContext context, required DateTime initial}) {
  return showDialog<DateTime>(
    context: context,
    barrierColor: FeedPalette.scrim,
    builder: (_) => _DiaryDatePicker(initial: initial),
  );
}

class _DiaryDatePicker extends StatefulWidget {
  const _DiaryDatePicker({required this.initial});

  final DateTime initial;

  @override
  State<_DiaryDatePicker> createState() => _DiaryDatePickerState();
}

class _DiaryDatePickerState extends State<_DiaryDatePicker> {
  late DateTime _month = DateTime(widget.initial.year, widget.initial.month);
  late final DateTime _selected = DateTime(widget.initial.year, widget.initial.month, widget.initial.day);

  bool get _canGoNext {
    final now = DateTime.now();
    return _month.isBefore(DateTime(now.year, now.month));
  }

  void _changeMonth(int delta) => setState(() => _month = DateTime(_month.year, _month.month + delta));

  @override
  Widget build(BuildContext context) {
    final grid = buildCalendarGrid(_month);
    final today = DateTime.now();
    return Dialog(
      backgroundColor: FeedPalette.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.borderRadius)),
      child: SizedBox(
        width: AppDimens.dialogWidth,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 월 이동 — RN CalendarModal arrow 18 MAIN · month 16.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Arrow(icon: FeedIcons.monthPrev, color: FeedPalette.main, onTap: () => _changeMonth(-1)),
                  Text(
                    '${_month.year}년 ${_month.month}월',
                    style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 16, color: FeedPalette.darkGray),
                  ),
                  _Arrow(
                    icon: FeedIcons.monthNext,
                    color: _canGoNext ? FeedPalette.main : FeedPalette.lightGray,
                    onTap: _canGoNext ? () => _changeMonth(1) : null,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (var i = 0; i < 7; i++)
                    Expanded(
                      child: Center(
                        child: Text(
                          _weekdayLabels[i],
                          style: TextStyle(
                            fontFamily: FeedFonts.dovemayo,
                            fontSize: 12,
                            color: (i == 0 || i == 6) ? FeedPalette.main : FeedPalette.darkGray,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              for (final week in grid)
                Row(
                  children: [
                    for (var i = 0; i < 7; i++)
                      Expanded(
                        child: _DayCell(
                          day: week[i],
                          weekdayIndex: i,
                          isSelected: week[i] != null && isSameDay(week[i]!, _selected),
                          isFuture: week[i] != null && week[i]!.isAfter(DateTime(today.year, today.month, today.day)),
                          onTap: (date) => Navigator.of(context).pop(date),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.icon, required this.color, required this.onTap});

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.weekdayIndex,
    required this.isSelected,
    required this.isFuture,
    required this.onTap,
  });

  final DateTime? day;
  final int weekdayIndex;
  final bool isSelected;
  final bool isFuture;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final date = day;
    if (date == null) {
      return const SizedBox(height: 40);
    }
    final isWeekend = weekdayIndex == 0 || weekdayIndex == 6;
    final color = isFuture ? FeedPalette.lightGray : (isWeekend ? FeedPalette.main : FeedPalette.darkGray);
    return GestureDetector(
      onTap: isFuture ? null : () => onTap(date),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? FeedPalette.whiteGray : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 14, color: color),
          ),
        ),
      ),
    );
  }
}
