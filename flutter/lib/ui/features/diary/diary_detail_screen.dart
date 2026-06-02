// 일기 상세 화면 — 내용 + 좋아요/공개여부 낙관 토글 + 작성자 액션(공개/수정/삭제). RN DiaryDetails 대응.
import 'package:feeddiary/data/models/community_diary.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/features/community/diary_likes.dart';
import 'package:feeddiary/ui/features/community/report_dialog.dart';
import 'package:feeddiary/ui/features/diary/diary_detail_controller.dart';
import 'package:feeddiary/ui/features/diary/sticker_catalog.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_card.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_state_views.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 일기 상세. 작성자 본인이면 AppBar 의 더보기로 공개/수정/삭제 액션을 연다.
class DiaryDetailScreen extends ConsumerWidget {
  const DiaryDetailScreen({required this.diaryIdx, super.key});

  final int diaryIdx;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(diaryDetailControllerProvider(diaryIdx));
    final myNickname = ref.watch(authControllerProvider).user?.nickname;
    final diary = detail.value;
    final isMine = diary != null && diary.nickname == myNickname;

    return Scaffold(
      appBar: AppBar(
        title: const Text('일기'),
        actions: [
          if (isMine)
            IconButton(
              icon: const Icon(Icons.more_vert),
              tooltip: '더보기',
              onPressed: () => _openActions(context, ref, diary),
            ),
        ],
      ),
      body: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => DiaryErrorView(onRetry: () => ref.invalidate(diaryDetailControllerProvider(diaryIdx))),
        data: (value) => Column(
          children: [
            Expanded(child: _Content(diary: value)),
            _BottomBar(diary: value, isMine: value.nickname == myNickname),
          ],
        ),
      ),
    );
  }

  void _openActions(BuildContext context, WidgetRef ref, CommunityDiary diary) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(diary.isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
              title: Text(diary.isVisible ? '비공개로 전환' : '공개로 전환'),
              onTap: () {
                Navigator.pop(sheetContext);
                unawaitedToggleVisibility(context, ref, diary);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('수정'),
              onTap: () {
                Navigator.pop(sheetContext);
                context.push(Routes.diaryWrite, extra: diary.toMyDiary());
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: context.colors.error),
              title: Text('삭제', style: TextStyle(color: context.colors.error)),
              onTap: () {
                Navigator.pop(sheetContext);
                unawaitedConfirmDelete(context, ref, diary.idx);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 시트 콜백(VoidCallback)에서 비동기 작업을 시작만 하고 결과 처리는 내부에서 한다.
  void unawaitedToggleVisibility(BuildContext context, WidgetRef ref, CommunityDiary diary) {
    () async {
      try {
        await ref.read(diaryDetailControllerProvider(diary.idx).notifier).toggleVisibility();
        if (context.mounted) {
          final message = diary.isVisible ? '비공개로 전환했어요.' : '공개로 전환했어요.';
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      } on AppException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.displayMessage)));
        }
      }
    }();
  }

  void unawaitedConfirmDelete(BuildContext context, WidgetRef ref, int idx) {
    () async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          content: const Text('이 일기를 삭제할까요?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('닫기')),
            TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('삭제')),
          ],
        ),
      );
      if (confirmed != true) {
        return;
      }
      try {
        await ref.read(diaryDetailControllerProvider(idx).notifier).delete();
        if (context.mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('일기를 삭제했어요.')));
        }
      } on AppException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.displayMessage)));
        }
      }
    }();
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.diary});

  final CommunityDiary diary;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.padding),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text(StickerCatalog.emojiFor(diary.sticker), style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(formatDiaryDate(diary.createdAt), style: TextStyle(color: context.colors.textSecondary)),
          const SizedBox(height: 28),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(diary.text, style: TextStyle(color: context.colors.textPrimary, fontSize: 15, height: 1.7)),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({required this.diary, required this.isMine});

  final CommunityDiary diary;
  final bool isMine;

  Future<void> _like(BuildContext context, WidgetRef ref, LikeState like) async {
    if (isMine) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('내 일기에는 좋아요를 누를 수 없어요.')));
      return;
    }
    try {
      await ref
          .read(diaryLikesProvider.notifier)
          .toggle(idx: diary.idx, baseIsLike: like.isLike, baseLikeCount: like.likeCount);
    } on AppException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.displayMessage)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 좋아요는 목록과 동기화되도록 DiaryLikes 글로벌 override 를 구독한다(override 없으면 서버값 사용).
    final override = ref.watch(diaryLikesProvider.select((likes) => likes[diary.idx]));
    final like = override ?? (isLike: diary.isLike, likeCount: diary.likeCount);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding, vertical: 12),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.outline, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _like(context, ref, like),
            icon: Icon(
              like.isLike ? Icons.favorite : Icons.favorite_border,
              color: like.isLike ? context.colors.error : context.colors.textSecondary,
            ),
          ),
          Text('${like.likeCount}', style: TextStyle(color: context.colors.textSecondary)),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () => context.push(Routes.diaryCommentsPath(diary.idx), extra: diary.nickname),
            icon: Icon(Icons.chat_bubble_outline, size: 20, color: context.colors.textSecondary),
            label: Text('${diary.commentCount}', style: TextStyle(color: context.colors.textSecondary)),
          ),
          const Spacer(),
          if (isMine)
            VisibilityBadge(isVisible: diary.isVisible)
          else
            IconButton(
              tooltip: '신고/차단',
              onPressed: () => showReportDialog(context, ref, diaryIdx: diary.idx),
              icon: Icon(Icons.flag_outlined, color: context.colors.textSecondary),
            ),
        ],
      ),
    );
  }
}
