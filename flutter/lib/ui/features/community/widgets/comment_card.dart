// 댓글 카드 — 작성자 아바타·닉네임(작성자 인증 배지)·작성시각·본문 + 내 댓글 삭제. RN Comments/CommentCard 대응.
import 'package:feeddiary/data/models/comment.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_alert_dialog.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
import 'package:feeddiary/ui/features/community/comments_controller.dart';
import 'package:feeddiary/ui/features/setting/widgets/profile_avatar.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 댓글 한 장. [author]는 일기 작성자 닉네임으로, 일치하면 인증 배지를 단다. 내 댓글이면 삭제 버튼을 노출한다.
class CommentCard extends ConsumerWidget {
  const CommentCard({required this.comment, required this.diaryIdx, this.author, super.key});

  final Comment comment;
  final int diaryIdx;
  final String? author;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showFeedAlert<bool>(
      context: context,
      message: '댓글을 삭제하시겠어요?',
      actions: [
        FeedAlertAction(text: '닫기', isCancel: true, onPressed: () => Navigator.of(context).pop(false)),
        FeedAlertAction(text: '삭제하기', onPressed: () => Navigator.of(context).pop(true)),
      ],
    );
    if (confirmed != true) {
      return;
    }
    try {
      await ref.read(commentsControllerProvider(diaryIdx).notifier).delete(comment.idx);
    } on AppException catch (e) {
      if (context.mounted) {
        showFeedToast(context, e.displayMessage, offset: FeedToastOffset.comment);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myNickname = ref.watch(authControllerProvider).user?.nickname;
    final canDelete = comment.nickname == myNickname;
    final isAuthor = author != null && author == comment.nickname;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: FeedPalette.white, borderRadius: BorderRadius.circular(AppDimens.cardRadius)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileAvatar(
            size: 46,
            userImage: comment.userImage,
            character: comment.character,
            background: comment.background,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (isAuthor) ...[
                      const Icon(FeedIcons.verified, size: 14, color: FeedPalette.main),
                      const SizedBox(width: 3),
                    ],
                    Flexible(
                      child: Text(
                        comment.nickname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 14, color: FeedPalette.black),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      formatDateTime(comment.createdAt),
                      style: const TextStyle(
                        fontFamily: FeedFonts.dovemayo,
                        fontSize: 10,
                        color: FeedPalette.gray,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  comment.text,
                  style: const TextStyle(
                    fontFamily: FeedFonts.dovemayo,
                    fontSize: 14,
                    color: FeedPalette.lightBlack,
                    height: 20 / 14,
                  ),
                ),
              ],
            ),
          ),
          if (canDelete)
            Semantics(
              button: true,
              label: '댓글 삭제',
              child: InkResponse(
                onTap: () => _confirmDelete(context, ref),
                radius: 18,
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(FeedIcons.close, size: 16, color: FeedPalette.gray),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
