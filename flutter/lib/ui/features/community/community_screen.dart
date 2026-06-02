// 공유 일기 화면 — 정렬(최신/인기) 드롭다운 + 무한스크롤 목록. RN screens/home/community/Community 대응.
import 'dart:async';

import 'package:feeddiary/domain/models/community_sort.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_bottom_sheet.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/features/community/community_list_controller.dart';
import 'package:feeddiary/ui/features/community/community_sort_provider.dart';
import 'package:feeddiary/ui/features/community/widgets/community_diary_card.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_state_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 공유 일기 탭. 정렬 토글은 작은 클라이언트 상태(Riverpod), 목록은 무한스크롤 서버상태다.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: FeedPalette.background,
      appBar: FeedHeader(title: '공유 일기'),
      body: Column(
        children: [
          _SortBar(),
          Expanded(child: _CommunityList()),
        ],
      ),
    );
  }
}

/// 정렬 드롭다운 — "최신글 ⌄" 버튼을 탭하면 바텀시트에서 최신/인기를 고른다. RN `SortButton` 대응.
class _SortBar extends ConsumerWidget {
  const _SortBar();

  void _openSortSheet(BuildContext context, WidgetRef ref, CommunitySort current) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(communitySortControllerProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: FeedPalette.white,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () => _openSortSheet(context, ref, sort),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: FeedPalette.whiteGray),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    sort.label,
                    style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.lightBlack),
                  ),
                  const SizedBox(width: 2),
                  const Icon(FeedIcons.caretDown, size: 20, color: FeedPalette.main),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 무한스크롤 목록 + 당겨서 새로고침.
class _CommunityList extends ConsumerStatefulWidget {
  const _CommunityList();

  @override
  ConsumerState<_CommunityList> createState() => _CommunityListState();
}

class _CommunityListState extends ConsumerState<_CommunityList> {
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
      unawaited(ref.read(communityListProvider.notifier).loadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityListProvider);
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => DiaryErrorView(onRetry: () => ref.invalidate(communityListProvider)),
      data: (paged) {
        if (paged.isEmpty) {
          return const DiaryEmptyView(message: '아직 공유된 일기가 없어요.');
        }
        return RefreshIndicator(
          onRefresh: () => ref.read(communityListProvider.notifier).refreshList(),
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
              return CommunityDiaryCard(diary: diary, onTap: () => context.push(Routes.diaryDetailPath(diary.idx)));
            },
          ),
        );
      },
    );
  }
}
