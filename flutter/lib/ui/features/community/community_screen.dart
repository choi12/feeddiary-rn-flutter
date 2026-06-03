// 공유 일기 화면 — 제목 없는 스크롤 반응형 헤더(정렬버튼 확장) + 무한스크롤 목록. RN screens/home/community/Community 대응.
import 'dart:async';

import 'package:feeddiary/domain/models/community_sort.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_bottom_sheet.dart';
import 'package:feeddiary/ui/features/community/community_list_controller.dart';
import 'package:feeddiary/ui/features/community/community_sort_provider.dart';
import 'package:feeddiary/ui/features/community/widgets/community_diary_card.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_state_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// RN SCROLL_THRESHOLD — 이 픽셀을 넘기면 헤더가 스크롤 상태로 전환된다.
const double _scrollThreshold = 30;

/// 헤더 전환 애니메이션(RN withTiming 기본 300ms).
const Duration _headerAnim = Duration(milliseconds: 300);

/// 공유 일기 탭. RN AnimatedHeader 를 재현한다 — 미스크롤 시 우측 작은 정렬버튼(BACKGROUND 헤더),
/// 스크롤(>30) 시 정렬버튼이 화면 전폭으로 확장되며 헤더가 WHITE 로 전환된다. 스크롤 여부는 화면 로컬 UI 상태(setState)다.
class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final ScrollController _controller = ScrollController();
  bool _isScrolled = false;

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
    final scrolled = _controller.offset > _scrollThreshold;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
    final position = _controller.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      unawaited(ref.read(communityListProvider.notifier).loadMore());
    }
  }

  void _scrollToTop() {
    if (_controller.hasClients) {
      _controller.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _openSortSheet(CommunitySort current) {
    showFeedSheet(
      context: context,
      items: [
        for (final sort in CommunitySort.values)
          FeedSheetItem(
            title: sort.label,
            icon: sort == current ? FeedIcons.check : null,
            color: sort == current ? FeedPalette.main : FeedPalette.darkGray,
            onPressed: () => ref.read(communitySortControllerProvider.notifier).set(sort),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // RN: 정렬 변경 시 목록 최상단으로 이동(CommunityList useEffect[sort] → scrollToTop).
    ref.listen(communitySortControllerProvider, (_, _) => _scrollToTop());
    final sort = ref.watch(communitySortControllerProvider);
    return Scaffold(
      backgroundColor: FeedPalette.background,
      body: Stack(
        children: [
          Column(
            children: [
              _AnimatedHeader(isScrolled: _isScrolled, sort: sort, onTapSort: () => _openSortSheet(sort)),
              Expanded(child: _CommunityList(controller: _controller)),
            ],
          ),
          if (_isScrolled) Positioned(right: 10, bottom: 0, child: _ScrollTopButton(onTap: _scrollToTop)),
        ],
      ),
    );
  }
}

/// RN AnimatedHeader — 상태바 영역 박스 + 정렬버튼 컨테이너(제목 텍스트 없음).
/// 스크롤 여부에 따라 배경(BACKGROUND↔WHITE)·우측패딩(12↔0)이 전환되고, 내부 정렬버튼은 폭(82↔화면폭)·radius(12↔0)가 전환된다.
class _AnimatedHeader extends StatelessWidget {
  const _AnimatedHeader({required this.isScrolled, required this.sort, required this.onTapSort});

  final bool isScrolled;
  final CommunitySort sort;
  final VoidCallback onTapSort;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final width = MediaQuery.sizeOf(context).width;
    final headerColor = isScrolled ? FeedPalette.white : FeedPalette.background;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // statusBox — 상태바 영역(높이=상단 안전영역). 스크롤 시 WHITE.
        AnimatedContainer(duration: _headerAnim, curve: Curves.easeInOut, height: topInset, color: headerColor),
        // buttonBox — paddingTop 10 · 우측 정렬 · 스크롤 시 우측패딩 0.
        AnimatedContainer(
          duration: _headerAnim,
          curve: Curves.easeInOut,
          color: headerColor,
          padding: EdgeInsets.only(top: 10, right: isScrolled ? 0 : 12),
          child: Align(
            alignment: Alignment.centerRight,
            child: _SortButton(isScrolled: isScrolled, width: width, sort: sort, onTap: onTapSort),
          ),
        ),
      ],
    );
  }
}

/// 정렬 드롭다운 버튼(RN SortButton) — 스크롤 시 폭 82→화면폭·radius 12→0 으로 확장. 탭하면 정렬 바텀시트.
class _SortButton extends StatelessWidget {
  const _SortButton({required this.isScrolled, required this.width, required this.sort, required this.onTap});

  final bool isScrolled;
  final double width;
  final CommunitySort sort;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        duration: _headerAnim,
        curve: Curves.easeInOut,
        tween: Tween<double>(begin: 0, end: isScrolled ? 1 : 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // RN: text marginLeft 3 + 버튼 gap 2.
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Text(
                sort.label,
                style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.lightBlack),
              ),
            ),
            const SizedBox(width: 2),
            const Icon(FeedIcons.caretDown, size: 20, color: FeedPalette.main),
          ],
        ),
        // RN SortButton 보더는 하단·우측 2면만(상단 보더 없음). 비균일 보더+borderRadius 동시 지정이 불가하므로
        // 모서리 라운드는 ClipRRect 로, 보더는 radius 없는 Container 로 그려 충돌을 피한다.
        builder: (context, t, child) => ClipRRect(
          borderRadius: BorderRadius.circular(12 * (1 - t)),
          child: Container(
            width: 82 + (width - 82) * t,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: FeedPalette.white,
              border: Border(
                bottom: BorderSide(color: FeedPalette.whiteGray),
                right: BorderSide(color: FeedPalette.whiteGray),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 맨 위로 버튼 — 스크롤 시 우하단 표시. RN ScrollTopButton(AntDesign totop 25 LIGHT_GRAY opacity 0.8).
class _ScrollTopButton extends StatelessWidget {
  const _ScrollTopButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(FeedIcons.scrollTop, size: 25, color: FeedPalette.lightGray.withValues(alpha: 0.8)),
      ),
    );
  }
}

/// 무한스크롤 목록 + 당겨서 새로고침. 스크롤 컨트롤러는 화면이 소유해 헤더 전환·맨 위로와 공유한다.
class _CommunityList extends ConsumerWidget {
  const _CommunityList({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(communityListProvider);
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => DiaryErrorView(onRetry: () => ref.invalidate(communityListProvider)),
      data: (paged) {
        if (paged.isEmpty) {
          return const DiaryEmptyView(message: '공유된 일기가 없어요.');
        }
        return RefreshIndicator(
          onRefresh: () => ref.read(communityListProvider.notifier).refreshList(),
          child: ListView.separated(
            controller: controller,
            // RN CommunityList: gap 40 · padding 12 · paddingTop 20 · paddingBottom 75(+inset 은 셸 belowTabBar 처리).
            padding: const EdgeInsets.fromLTRB(12, 20, 12, 75),
            itemCount: paged.items.length + (paged.isEnd ? 0 : 1),
            separatorBuilder: (_, _) => const SizedBox(height: 40),
            itemBuilder: (context, index) {
              if (index >= paged.items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final diary = paged.items[index];
              return CommunityDiaryCard(diary: diary, onTap: () => context.push(Routes.diaryDetailPath(diary.idx)));
            },
          ),
        );
      },
    );
  }
}
