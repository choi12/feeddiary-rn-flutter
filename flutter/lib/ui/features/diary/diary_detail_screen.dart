// 일기 상세 화면 — 내용 + 좋아요/공개여부 낙관 토글 + 작성자 액션(공개/수정/삭제). RN DiaryDetails 대응.
import 'dart:async';

import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/data/models/community_diary.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_alert_dialog.dart';
import 'package:feeddiary/ui/core/widgets/feed_bottom_sheet.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
import 'package:feeddiary/ui/features/community/diary_likes.dart';
import 'package:feeddiary/ui/features/diary/diary_detail_controller.dart';
import 'package:feeddiary/ui/features/diary/sticker_catalog.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_card.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_state_views.dart';
import 'package:feeddiary/ui/features/setting/widgets/profile_avatar.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

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
        // RN DiaryDetailsHeader: 로딩 중(diary==null) 빈 제목·내 일기 '나의 일기'·타인 일기 NicknameBox(large).
        title: isMine ? '나의 일기' : '',
        titleWidget: (diary != null && !isMine) ? _DetailNicknameTitle(diary: diary) : null,
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
          showFeedToast(
            context,
            diary.isVisible ? '일기가 비공개로 설정되었어요.' : '일기가 공개되었어요.',
            offset: FeedToastOffset.diaryDetails,
          );
        }
      } on AppException catch (e) {
        if (context.mounted) showFeedToast(context, e.displayMessage, offset: FeedToastOffset.diaryDetails);
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
          // 삭제 후 목록으로 돌아간 뒤 표시되므로 홈 오프셋(탭바 위). RN TOAST_BOTTOM_OFFSET.HOME_SCREEN.
          showFeedToast(context, '일기가 삭제되었어요.', offset: FeedToastOffset.home);
        }
      } on AppException catch (e) {
        if (context.mounted) showFeedToast(context, e.displayMessage, offset: FeedToastOffset.diaryDetails);
      }
    }();
  }
}

/// 타인 일기 상세 헤더 제목 — 작성자 아바타(37) + "{닉네임} 님의 일기". RN `NicknameBox size="large"`(diary/NicknameBox).
class _DetailNicknameTitle extends StatelessWidget {
  const _DetailNicknameTitle({required this.diary});

  final CommunityDiary diary;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProfileAvatar(size: 37, userImage: diary.userImage, character: diary.character, background: diary.background),
        // RN nicknameText marginLeft 5.
        const SizedBox(width: 5),
        Text.rich(
          TextSpan(
            style: const TextStyle(
              fontFamily: FeedFonts.dovemayo,
              fontSize: 14,
              color: FeedPalette.lightBlack,
              letterSpacing: -0.5,
            ),
            children: [
              TextSpan(
                text: '${diary.nickname} ',
                style: const TextStyle(fontSize: 17, color: FeedPalette.black),
              ),
              const TextSpan(text: '님의 일기'),
            ],
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.diary});

  final CommunityDiary diary;

  @override
  Widget build(BuildContext context) {
    final hasImage = diary.image != null && diary.image!.isNotEmpty;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.padding),
      // RN diaryContentBox: alignItems center · marginVertical 20.
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // RN StickerImage size 50.
            Image.asset(StickerCatalog.assetFor(diary.sticker), width: 50, height: 50, fit: BoxFit.contain),
            // 날짜 — RN formatDate(_,'diary') 상대 표기 · 15 · GRAY · marginTop 15.
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                formatRelativeDate(diary.createdAt),
                style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 15, color: FeedPalette.gray),
              ),
            ),
            // 본문 — RN contentText: Dovemayo(C1) · 15 · lineHeight 25 · marginTop 35 · paddingHorizontal 10 · 좌측 정렬.
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    diary.text,
                    style: const TextStyle(
                      fontFamily: FeedFonts.dovemayo,
                      color: FeedPalette.lightBlack,
                      fontSize: 15,
                      height: 25 / 15,
                    ),
                  ),
                ),
              ),
            ),
            // 본문 이미지 — RN diaryImage: 100%·aspectRatio 1.5·radius 7·marginVertical 20, 탭 시 ImageModal.
            if (hasImage)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: GestureDetector(
                  onTap: () => showDiaryImageModal(context, diary.image!),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: AspectRatio(
                      aspectRatio: 1.5,
                      child: Image.network(
                        diary.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 본문 이미지 확대 모달 — 검은 배경(scrimHeavy) 위에 전체 화면 이미지, 아무 곳이나 탭하면 닫힘. RN ImageModal(BaseModal isImageModal).
void showDiaryImageModal(BuildContext context, String imageUrl) {
  unawaited(
    showGeneralDialog<void>(
      context: context,
      barrierColor: FeedPalette.scrimHeavy,
      barrierDismissible: true,
      barrierLabel: '이미지 닫기',
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (_, animation, _, child) => FadeTransition(opacity: animation, child: child),
      pageBuilder: (dialogContext, _, _) => GestureDetector(
        onTap: () => Navigator.of(dialogContext).pop(),
        child: SizedBox.expand(
          child: Image.network(imageUrl, fit: BoxFit.contain, errorBuilder: (_, _, _) => const SizedBox.shrink()),
        ),
      ),
    ),
  );
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.diary, required this.isMine});

  final CommunityDiary diary;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
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
              _LikeButton(diary: diary, isMine: isMine),
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
              onTap: () => context.push(Routes.reportPath(diary.idx)),
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

/// 좋아요 버튼 — 하트 아이콘 + 카운트, 좋아요 추가 시 heart_green Lottie 버스트(500ms). RN LikeButton + useLikeDiary.
class _LikeButton extends ConsumerStatefulWidget {
  const _LikeButton({required this.diary, required this.isMine});

  final CommunityDiary diary;
  final bool isMine;

  @override
  ConsumerState<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends ConsumerState<_LikeButton> {
  bool _showLottie = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _toggle(LikeState like) async {
    if (widget.isMine) {
      showFeedToast(context, '다른 사람의 일기에만 좋아요를 할 수 있어요.', offset: FeedToastOffset.diaryDetails);
      return;
    }
    try {
      await ref
          .read(diaryLikesProvider.notifier)
          .toggle(idx: widget.diary.idx, baseIsLike: like.isLike, baseLikeCount: like.likeCount);
      // RN: response.isLike === true(좋아요 추가) 일 때만 하트 Lottie 를 500ms 노출. 취소 시 애니 없음.
      final updated = ref.read(diaryLikesProvider)[widget.diary.idx];
      if (mounted && updated != null && updated.isLike) {
        setState(() => _showLottie = true);
        _timer?.cancel();
        _timer = Timer(const Duration(milliseconds: 500), () {
          if (mounted) setState(() => _showLottie = false);
        });
      }
    } on AppException catch (e) {
      if (mounted) showFeedToast(context, e.displayMessage, offset: FeedToastOffset.diaryDetails);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 좋아요는 목록과 동기화되도록 DiaryLikes 글로벌 override 를 구독한다(override 없으면 서버값 사용).
    final override = ref.watch(diaryLikesProvider.select((likes) => likes[widget.diary.idx]));
    final like = override ?? (isLike: widget.diary.isLike, likeCount: widget.diary.likeCount);
    final iconColor = widget.isMine ? FeedPalette.lightGray : (like.isLike ? FeedPalette.main : FeedPalette.lightGray);
    return InkResponse(
      onTap: () => _toggle(like),
      radius: 24,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            children: [
              Icon(FeedIcons.like, size: 25, color: iconColor),
              const SizedBox(width: 6),
              Text(
                like.likeCount > 99 ? '99+' : '${like.likeCount}',
                style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 16, color: FeedPalette.black),
              ),
            ],
          ),
          // RN likeLottie: absolute left -61 · top -65 · 150×150 — 하트 위로 크게 튀어나오는 버스트.
          if (_showLottie)
            Positioned(
              left: -61,
              top: -65,
              // heart_green 컴포지션이 38×57 라 fit 미지정 시 네이티브 크기로 작게 렌더된다. RN LottieView 기본 resizeMode 'contain' 처럼 150 박스에 맞춰 키운다.
              child: IgnorePointer(
                child: Lottie.asset(AppAssets.lottieHeartGreen, width: 150, height: 150, fit: BoxFit.contain),
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
            count > 99 ? '99+' : '$count',
            style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 16, color: FeedPalette.black),
          ),
        ],
      ),
    );
  }
}
