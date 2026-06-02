// 공유 일기 화면 — 정렬(최신/인기) + 무한스크롤 목록. RN screens/home/community/Community 대응.
import 'dart:async';

import 'package:feeddiary/domain/models/community_sort.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
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
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: const Text('공유 일기')),
      body: const Column(
        children: [
          _SortBar(),
          Expanded(child: _CommunityList()),
        ],
      ),
    );
  }
}

/// 정렬 SegmentedButton(최신/인기). 변경 시 목록 컨트롤러 build 가 재실행돼 1페이지부터 다시 로드된다.
class _SortBar extends ConsumerWidget {
  const _SortBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(communitySortControllerProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SegmentedButton<CommunitySort>(
        segments: const [
          ButtonSegment(value: CommunitySort.latest, label: Text('최신'), icon: Icon(Icons.schedule)),
          ButtonSegment(value: CommunitySort.popular, label: Text('인기'), icon: Icon(Icons.favorite)),
        ],
        selected: {sort},
        onSelectionChanged: (selection) => ref.read(communitySortControllerProvider.notifier).set(selection.first),
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
