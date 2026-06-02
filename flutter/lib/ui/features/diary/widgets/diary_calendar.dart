// 일기 캘린더 — 월 선택 + 6주 x 7일 격자(일기 있는 날 마킹) + 선택일 일기 리스트. RN MyDiary CalendarList 대응.
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/features/diary/calendar_grid.dart';
import 'package:feeddiary/ui/features/diary/monthly_diaries_provider.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_card.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_state_views.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const List<String> _weekdayLabels = ['일', '월', '화', '수', '목', '금', '토'];

/// 달력 뷰. selectedMonth/selectedDate 는 순수 로컬 UI 상태(setState), 월별 일기는 서버상태(provider)다.
class DiaryCalendar extends ConsumerStatefulWidget {
  const DiaryCalendar({super.key});

  @override
  ConsumerState<DiaryCalendar> createState() => _DiaryCalendarState();
}

class _DiaryCalendarState extends ConsumerState<DiaryCalendar> {
  late DateTime _month;
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _selected = DateTime(now.year, now.month, now.day);
  }

  bool get _canGoNext {
    final now = DateTime.now();
    return _month.isBefore(DateTime(now.year, now.month));
  }

  void _changeMonth(int delta) => setState(() => _month = DateTime(_month.year, _month.month + delta));

  @override
  Widget build(BuildContext context) {
    final key = monthKey(_month);
    final monthly = ref.watch(monthlyDiariesProvider(key));
    // 월 데이터 로드 시 선택일에 일기가 없으면 첫 일기 날짜로 자동 선택(RN useDiaryCalendarView).
    ref.listen(monthlyDiariesProvider(key), (_, next) {
      next.whenData((diaries) {
        if (diaries.isNotEmpty && !diaries.any((d) => isSameDay(d.createdAt, _selected))) {
          setState(() => _selected = diaries.first.createdAt);
        }
      });
    });
    final marked = monthly.value == null ? <DateTime>{} : markedDays(monthly.value!);

    return Column(
      children: [
        _MonthSelector(
          month: _month,
          canGoNext: _canGoNext,
          onPrev: () => _changeMonth(-1),
          onNext: () => _changeMonth(1),
        ),
        const _WeekdayHeader(),
        _CalendarGrid(
          month: _month,
          selected: _selected,
          marked: marked,
          onSelect: (day) => setState(() => _selected = day),
        ),
        const Divider(height: 24),
        Expanded(
          child: monthly.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => DiaryErrorView(onRetry: () => ref.invalidate(monthlyDiariesProvider(key))),
            data: (diaries) {
              final daily = diariesOn(diaries, _selected);
              if (daily.isEmpty) {
                return const DiaryEmptyView(message: '이 날의 일기가 없어요.');
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: daily.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final diary = daily[index];
                  return DiaryCard(
                    sticker: diary.sticker,
                    text: diary.text,
                    date: diary.createdAt,
                    isVisible: diary.isVisible,
                    onTap: () => context.push(Routes.diaryDetailPath(diary.idx)),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({required this.month, required this.canGoNext, required this.onPrev, required this.onNext});

  final DateTime month;
  final bool canGoNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPrev,
            icon: const Icon(Icons.chevron_left),
            color: context.colors.primary,
            tooltip: '이전 달',
          ),
          Column(
            children: [
              Text('${month.year}', style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
              Text(
                '${month.month}',
                style: TextStyle(fontSize: 28, color: context.colors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          IconButton(
            onPressed: canGoNext ? onNext : null,
            icon: const Icon(Icons.chevron_right),
            color: context.colors.primary,
            tooltip: '다음 달',
          ),
        ],
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Center(
                child: Text(
                  _weekdayLabels[i],
                  style: TextStyle(
                    fontSize: 12,
                    color: (i == 0 || i == 6) ? context.colors.primary : context.colors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({required this.month, required this.selected, required this.marked, required this.onSelect});

  final DateTime month;
  final DateTime selected;
  final Set<DateTime> marked;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final grid = buildCalendarGrid(month);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          for (final week in grid)
            Row(
              children: [
                for (var i = 0; i < 7; i++)
                  Expanded(
                    child: _DayCell(
                      day: week[i],
                      weekdayIndex: i,
                      hasDiary:
                          week[i] != null && marked.contains(DateTime(week[i]!.year, week[i]!.month, week[i]!.day)),
                      isSelected: week[i] != null && isSameDay(week[i]!, selected),
                      onTap: onSelect,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.weekdayIndex,
    required this.hasDiary,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime? day;
  final int weekdayIndex;
  final bool hasDiary;
  final bool isSelected;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final date = day;
    if (date == null) {
      return const SizedBox(height: 48);
    }
    final isWeekend = weekdayIndex == 0 || weekdayIndex == 6;
    return GestureDetector(
      onTap: hasDiary ? () => onTap(date) : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.background : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: hasDiary
              ? Icon(Icons.edit, size: 18, color: context.colors.primary)
              : Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isWeekend ? context.colors.primary : context.colors.textSecondary,
                  ),
                ),
        ),
      ),
    );
  }
}
