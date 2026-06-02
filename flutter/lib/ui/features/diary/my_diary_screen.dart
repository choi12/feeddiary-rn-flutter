// 나의 일기 화면 — 달력/카드 뷰 토글 + 일기 작성 진입. RN screens/home/myDiary/MyDiary 대응.
import 'dart:async';

import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/features/diary/diary_list_controller.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_calendar.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_card.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_state_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _DiaryTab { calendar, card }

/// 내 일기 탭. 달력/카드 뷰 토글은 순수 로컬 UI 상태(setState)다.
class MyDiaryScreen extends ConsumerStatefulWidget {
  const MyDiaryScreen({super.key});

  @override
  ConsumerState<MyDiaryScreen> createState() => _MyDiaryScreenState();
}

class _MyDiaryScreenState extends ConsumerState<MyDiaryScreen> {
  _DiaryTab _tab = _DiaryTab.calendar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              tab: _tab,
              onSelectTab: (tab) => setState(() => _tab = tab),
              onCreate: () => context.push(Routes.diaryWrite),
            ),
            Expanded(child: _tab == _DiaryTab.calendar ? const DiaryCalendar() : const _CardView()),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.tab, required this.onSelectTab, required this.onCreate});

  final _DiaryTab tab;
  final ValueChanged<_DiaryTab> onSelectTab;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(bottom: BorderSide(color: context.colors.outline, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _ToggleButton(
                icon: Icons.calendar_today_outlined,
                label: '캘린더 보기',
                selected: tab == _DiaryTab.calendar,
                onTap: () => onSelectTab(_DiaryTab.calendar),
              ),
              _ToggleButton(
                icon: Icons.view_list_outlined,
                label: '리스트 보기',
                selected: tab == _DiaryTab.card,
                onTap: () => onSelectTab(_DiaryTab.card),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('일기 쓰기'),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({required this.icon, required this.label, required this.selected, required this.onTap});

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      tooltip: label,
      color: selected ? context.colors.primary : context.colors.outline,
    );
  }
}

/// 카드(리스트) 뷰 — 무한스크롤 + 당겨서 새로고침.
class _CardView extends ConsumerStatefulWidget {
  const _CardView();

  @override
  ConsumerState<_CardView> createState() => _CardViewState();
}

class _CardViewState extends ConsumerState<_CardView> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _controller.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      unawaited(ref.read(diaryListProvider.notifier).loadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diaryListProvider);
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => DiaryErrorView(onRetry: () => ref.invalidate(diaryListProvider)),
      data: (paged) {
        if (paged.isEmpty) {
          return const DiaryEmptyView(message: '아직 작성한 일기가 없어요.');
        }
        return RefreshIndicator(
          onRefresh: () => ref.read(diaryListProvider.notifier).refreshList(),
          child: ListView.separated(
            controller: _controller,
            padding: const EdgeInsets.all(16),
            itemCount: paged.items.length + (paged.isEnd ? 0 : 1),
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index >= paged.items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final diary = paged.items[index];
              return DiaryCard(
                sticker: diary.sticker,
                text: diary.text,
                date: diary.createdAt,
                isVisible: diary.isVisible,
                likeCount: diary.likeCount,
                commentCount: diary.commentCount,
                onTap: () => context.push(Routes.diaryDetailPath(diary.idx)),
              );
            },
          ),
        );
      },
    );
  }
}
