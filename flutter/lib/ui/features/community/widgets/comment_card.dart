// 댓글 카드 — 작성자 아바타·닉네임(작성자 인증 배지)·작성시각·본문 + 내 댓글 삭제. RN Comments/CommentCard 대응.
import 'package:feeddiary/data/models/comment.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/features/community/comments_controller.dart';
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: const Text('이 댓글을 삭제할까요?'),
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
      await ref.read(commentsControllerProvider(diaryIdx).notifier).delete(comment.idx);
    } on AppException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.displayMessage)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myNickname = ref.watch(authControllerProvider).user?.nickname;
    final canDelete = comment.nickname == myNickname;
    final isAuthor = author != null && author == comment.nickname;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppDimens.borderRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: context.colors.background,
            child: Text(
              comment.nickname.isNotEmpty ? comment.nickname.substring(0, 1) : '?',
              style: TextStyle(color: context.colors.primary, fontSize: 14),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (isAuthor) ...[
                      Icon(Icons.verified, size: 14, color: context.colors.primary),
                      const SizedBox(width: 3),
                    ],
                    Text(comment.nickname, style: TextStyle(color: context.colors.textPrimary, fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      formatYmd(comment.createdAt),
                      style: TextStyle(color: context.colors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.text, style: TextStyle(color: context.colors.textPrimary, height: 1.4)),
              ],
            ),
          ),
          if (canDelete)
            IconButton(
              onPressed: () => _confirmDelete(context, ref),
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.close, size: 18, color: context.colors.textSecondary),
            ),
        ],
      ),
    );
  }
}
