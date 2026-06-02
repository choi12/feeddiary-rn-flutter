// 일기 상세 화면 — 내용 + 좋아요/공개여부 낙관 토글 + 작성자 액션(공개/수정/삭제). RN DiaryDetails 대응.
import 'package:feeddiary/data/models/community_diary.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_alert_dialog.dart';
import 'package:feeddiary/ui/core/widgets/feed_bottom_sheet.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
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

/// 일기 상세. 작성자 본인이면 헤더의 더보기(점 3개)로 공개/수정/삭제 액션 시트를 연다. RN `DiaryDetails` 1:1.
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
      backgroundColor: FeedPalette.white,
      appBar: FeedHeader(
        title: diary == null ? '일기' : (isMine ? '나의 일기' : diary.nickname),
        hasBackButton: true,
        rightItem: isMine
            ? InkResponse(
                onTap: () => _openActions(context, ref, diary),
                radius: 24,
                child: const Icon(FeedIcons.more, size: 18, color: FeedPalette.lightBlack),
              )
            : null,
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

  /// 작성자 액션 시트 — 공개 토글·수정·삭제. RN `useDiaryActions.handleOpenDiaryActionModal`.
  void _openActions(BuildContext context, WidgetRef ref, CommunityDiary diary) {
    showFeedSheet(
      context: context,
      items: [
        FeedSheetItem(
          title: diary.isVisible ? '비공개로 전환하기' : '공개로 전환하기',
          icon: diary.isVisible ? FeedIcons.visibleOff : FeedIcons.visibleOn,
          color: diary.isVisible ? FeedPalette.darkGray : FeedPalette.main,
          onPressed: () => _toggleVisibility(context, ref, diary),
        ),
        FeedSheetItem(
          title: '수정',
          color: FeedPalette.lightBlack,
          onPressed: () => context.push(Routes.diaryWrite, extra: diary.toMyDiary()),
        ),
        FeedSheetItem(title: '삭제', color: FeedPalette.orange, onPressed: () => _confirmDelete(context, ref, diary.idx)),
      ],
    );
  }

  void _toggleVisibility(BuildContext context, WidgetRef ref, CommunityDiary diary) {
    () async {
      try {
        await ref.read(diaryDetailControllerProvider(diary.idx).notifier).toggleVisibility();
        if (context.mounted) {
          // 토글 후 새 상태 기준 안내. RN MESSAGE.DIARY.PUBLISHED/UNPUBLISHED.
          showFeedToast(context, diary.isVisible ? '일기가 비공개로 설정되었어요.' : '일기가 공개되었어요.');
        }
      } on AppException catch (e) {
        if (context.mounted) showFeedToast(context, e.displayMessage);
      }
    }();
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int idx) {
    () async {
      final confirmed = await showFeedAlert<bool>(
        context: context,
        message: '일기를 삭제하시겠어요?',
        actions: [
          FeedAlertAction(text: '닫기', isCancel: true, onPressed: () => Navigator.of(context).pop(false)),
          FeedAlertAction(text: '삭제하기', onPressed: () => Navigator.of(context).pop(true)),
        ],
      );
      if (confirmed != true) return;
      try {
        await ref.read(diaryDetailControllerProvider(idx).notifier).delete();
        if (context.mounted) {
          context.pop();
          showFeedToast(context, '일기가 삭제되었어요.');
        }
      } on AppException catch (e) {
        if (context.mounted) showFeedToast(context, e.displayMessage);
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
          Image.asset(StickerCatalog.assetFor(diary.sticker), width: 72, height: 72, fit: BoxFit.contain),
          const SizedBox(height: 16),
          Text(formatDiaryDate(diary.createdAt), style: TextStyle(color: context.colors.textSecondary)),
          const SizedBox(height: 28),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              diary.text,
              style: const TextStyle(
                fontFamily: FeedFonts.ownglyph,
                color: FeedPalette.lightBlack,
                fontSize: 17,
                height: 22 / 17,
              ),
            ),
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
      showFeedToast(context, '다른 사람의 일기에만 좋아요를 할 수 있어요.');
      return;
    }
    try {
      await ref
          .read(diaryLikesProvider.notifier)
          .toggle(idx: diary.idx, baseIsLike: like.isLike, baseLikeCount: like.likeCount);
    } on AppException catch (e) {
      if (context.mounted) showFeedToast(context, e.displayMessage);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 좋아요는 목록과 동기화되도록 DiaryLikes 글로벌 override 를 구독한다(override 없으면 서버값 사용).
    final override = ref.watch(diaryLikesProvider.select((likes) => likes[diary.idx]));
    final like = override ?? (isLike: diary.isLike, likeCount: diary.likeCount);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding, vertical: 15),
      decoration: const BoxDecoration(
        color: FeedPalette.white,
        border: Border(top: BorderSide(color: FeedPalette.whiteGray)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _CountAction(
                icon: FeedIcons.like,
                iconColor: isMine ? FeedPalette.lightGray : (like.isLike ? FeedPalette.main : FeedPalette.lightGray),
                count: like.likeCount,
                onTap: () => _like(context, ref, like),
              ),
              const SizedBox(width: 20),
              _CountAction(
                icon: FeedIcons.comment,
                iconColor: FeedPalette.lightGray,
                count: diary.commentCount,
                onTap: () => context.push(Routes.diaryCommentsPath(diary.idx), extra: diary.nickname),
              ),
            ],
          ),
          if (isMine)
            VisibilityBadge(isVisible: diary.isVisible)
          else
            InkResponse(
              onTap: () => showReportDialog(context, ref, diaryIdx: diary.idx),
              radius: 24,
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FeedIcons.report, size: 14, color: FeedPalette.red),
                    SizedBox(width: 2),
                    Text(
                      '신고/차단',
                      style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.red),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 좋아요/댓글 카운트 액션 — 아이콘 + 개수. RN LikeButton/CommentButton 의 countBox 대응.
class _CountAction extends StatelessWidget {
  const _CountAction({required this.icon, required this.iconColor, required this.count, required this.onTap});

  final IconData icon;
  final Color iconColor;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Row(
        children: [
          Icon(icon, size: 25, color: iconColor),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 16, color: FeedPalette.black),
          ),
        ],
      ),
    );
  }
}
