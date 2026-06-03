// 일기 캘린더 — 월 선택 + 6주 x 7일 격자(일기 있는 날 마킹) + 선택일 일기 리스트. RN MyDiary CalendarList 대응.
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
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

    // RN CalendarList: marginTop 15 · paddingHorizontal 12 · gap 10.
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 15, 12, 0),
      child: Column(
        children: [
          _CalendarCard(
            month: _month,
            selected: _selected,
            marked: marked,
            canGoNext: _canGoNext,
            onPrev: () => _changeMonth(-1),
            onNext: () => _changeMonth(1),
            onSelect: (day) => setState(() => _selected = day),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: monthly.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => DiaryErrorView(onRetry: () => ref.invalidate(monthlyDiariesProvider(key))),
              data: (diaries) {
                final daily = diariesOn(diaries, _selected);
                if (daily.isEmpty) {
                  return const DiaryEmptyView(message: '이 날의 일기가 없어요.');
                }
                // RN DailyDiaryList: paddingTop 25 · gap 25 · 하단 탭바 여백. 일별 카드는 small.
                return ListView.separated(
                  padding: const EdgeInsets.only(top: 25, bottom: 90),
                  itemCount: daily.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 25),
                  itemBuilder: (context, index) {
                    final diary = daily[index];
                    return DiaryCard(
                      sticker: diary.sticker,
                      text: diary.text,
                      date: diary.createdAt,
                      isVisible: diary.isVisible,
                      size: DiaryCardSize.small,
                      onTap: () => context.push(Routes.diaryDetailPath(diary.idx)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 달력 카드 — 흰 배경·우/하단 입체 보더·뒤 워터마크 + 점 장식 + 월 선택 + 요일 + 격자. RN Calendar.
class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.month,
    required this.selected,
    required this.marked,
    required this.canGoNext,
    required this.onPrev,
    required this.onNext,
    required this.onSelect,
  });

  final DateTime month;
  final DateTime selected;
  final Set<DateTime> marked;
  final bool canGoNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 13, 20, 15),
      decoration: const BoxDecoration(
        color: FeedPalette.white,
        border: Border(
          right: BorderSide(color: FeedPalette.calendarBorder, width: 2),
          bottom: BorderSide(color: FeedPalette.calendarBorder, width: 3),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 뒤 워터마크 — 회색조 레모니(높이 80%·opacity 0.15). RN BackgroundImage.
          Positioned.fill(
            child: FractionallySizedBox(
              heightFactor: 0.8,
              child: Opacity(opacity: 0.15, child: Image.asset(AppAssets.lemonyGrayscale, fit: BoxFit.contain)),
            ),
          ),
          Column(
            children: [
              const _CircleStrip(),
              _MonthSelector(month: month, canGoNext: canGoNext, onPrev: onPrev, onNext: onNext),
              const _WeekdayHeader(),
              _CalendarGrid(month: month, selected: selected, marked: marked, onSelect: onSelect),
            ],
          ),
        ],
      ),
    );
  }
}

/// 상단 점 장식 10개. RN CircleBox.
class _CircleStrip extends StatelessWidget {
  const _CircleStrip();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < 10; i++)
            const SizedBox(
              width: 12,
              height: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(color: FeedPalette.whiteGray, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}

/// 월 이동 — 좌우 캐럿 + 연/월(월 35·main). RN MonthSelector.
class _MonthSelector extends StatelessWidget {
  const _MonthSelector({required this.month, required this.canGoNext, required this.onPrev, required this.onNext});

  final DateTime month;
  final bool canGoNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NavButton(icon: FeedIcons.monthPrev, color: FeedPalette.main, onTap: onPrev),
        Column(
          children: [
            Text(
              '${month.year}',
              style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 12, color: FeedPalette.gray),
            ),
            Transform.translate(
              offset: const Offset(0, -7),
              child: Text(
                '${month.month}',
                style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 35, color: FeedPalette.main),
              ),
            ),
          ],
        ),
        _NavButton(
          icon: FeedIcons.monthNext,
          color: canGoNext ? FeedPalette.main : FeedPalette.lightGray,
          onTap: canGoNext ? onNext : null,
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.color, required this.onTap});

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
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
    return Column(
      children: [
        for (final week in grid)
          Row(
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: _DayCell(
                    day: week[i],
                    weekdayIndex: i,
                    hasDiary: week[i] != null && marked.contains(DateTime(week[i]!.year, week[i]!.month, week[i]!.day)),
                    isSelected: week[i] != null && isSameDay(week[i]!, selected),
                    onTap: onSelect,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

/// 날짜 셀 — 40·radius 12·선택 시 회색 배경. 일기 있는 날은 연필 마커, 없으면 날짜(평일 gray·주말 main). RN DayButton.
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
      return const SizedBox(height: 40);
    }
    final isWeekend = weekdayIndex == 0 || weekdayIndex == 6;
    return GestureDetector(
      onTap: hasDiary ? () => onTap(date) : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? FeedPalette.whiteGray : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: hasDiary
              ? Image.asset(AppAssets.calendarPencil, width: 20, height: 20, fit: BoxFit.contain)
              : Text(
                  '${date.day}',
                  style: TextStyle(
                    fontFamily: FeedFonts.dovemayo,
                    fontSize: 13,
                    color: isWeekend ? FeedPalette.main : FeedPalette.gray,
                  ),
                ),
        ),
      ),
    );
  }
}
