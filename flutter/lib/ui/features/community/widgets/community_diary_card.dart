// 공유 일기 카드 — 작성자·스티커·본문 + 좋아요(글로벌 동기화)·댓글 수. RN Community/CommunityDiaryCard 대응.
import 'package:feeddiary/data/models/community_diary.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/features/community/diary_likes.dart';
import 'package:feeddiary/ui/features/diary/sticker_catalog.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 공유 일기 한 장. 좋아요는 [DiaryLikes] 글로벌 provider 를 구독해 상세와 동기화하고, 카드 탭은 상세로 이동한다.
class CommunityDiaryCard extends ConsumerWidget {
  const CommunityDiaryCard({required this.diary, this.onTap, super.key});

  final CommunityDiary diary;
  final VoidCallback? onTap;

  Future<void> _like(BuildContext context, WidgetRef ref, {required bool isMine, required LikeState like}) async {
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
    final myNickname = ref.watch(authControllerProvider).user?.nickname;
    final isMine = diary.nickname == myNickname;
    final override = ref.watch(diaryLikesProvider.select((likes) => likes[diary.idx]));
    final like = override ?? (isLike: diary.isLike, likeCount: diary.likeCount);

    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(AppDimens.borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.borderRadius),
            border: Border.all(color: context.colors.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(StickerCatalog.emojiFor(diary.sticker), style: const TextStyle(fontSize: 30)),
                  const SizedBox(width: 10),
                  _Avatar(nickname: diary.nickname),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(diary.nickname, style: TextStyle(color: context.colors.textPrimary, fontSize: 14)),
                        Text(
                          formatYmd(diary.createdAt),
                          style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                diary.text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: context.colors.textPrimary, height: 1.5),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _like(context, ref, isMine: isMine, like: like),
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      like.isLike ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: like.isLike ? context.colors.error : context.colors.textSecondary,
                    ),
                  ),
                  Text('${like.likeCount}', style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
                  const SizedBox(width: 16),
                  Icon(Icons.chat_bubble_outline, size: 18, color: context.colors.textSecondary),
                  const SizedBox(width: 6),
                  Text('${diary.commentCount}', style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 작성자 아바타 placeholder(닉네임 첫 글자). 실제 프로필/캐릭터 이미지는 polish PR⑧.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.nickname});

  final String nickname;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: context.colors.background,
      child: Text(
        nickname.isNotEmpty ? nickname.substring(0, 1) : '?',
        style: TextStyle(color: context.colors.primary, fontSize: 14),
      ),
    );
  }
}
