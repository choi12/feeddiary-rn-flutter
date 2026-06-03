// 공유 일기 카드 — 날짜열·작성자(님의 일기)·본문·좋아요/댓글 수(표시 전용). RN Community/CommunityDiaryCard 대응.
import 'package:feeddiary/data/models/community_diary.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/features/community/diary_likes.dart';
import 'package:feeddiary/ui/features/diary/sticker_catalog.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_card.dart';
import 'package:feeddiary/ui/features/setting/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 공유 일기 한 장. RN 처럼 목록 카드의 하트는 표시 전용(회색 장식)이고 좋아요 토글은 상세에서만 한다.
/// 단 좋아요 수는 [DiaryLikes] 글로벌 override 를 구독해 상세→목록을 스크롤 리셋 없이 동기화한다. 탭은 상세로 이동.
class CommunityDiaryCard extends ConsumerWidget {
  const CommunityDiaryCard({required this.diary, this.onTap, super.key});

  final CommunityDiary diary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final override = ref.watch(diaryLikesProvider.select((likes) => likes[diary.idx]));
    final likeCount = override?.likeCount ?? diary.likeCount;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: FeedPalette.white,
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimens.cardRadius),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DayBox(date: diary.createdAt, isLarge: true),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                StickerCatalog.assetFor(diary.sticker),
                                width: 38,
                                height: 38,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ProfileAvatar(
                                      size: 25,
                                      userImage: diary.userImage,
                                      character: diary.character,
                                      background: diary.background,
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: diary.nickname,
                                              style: const TextStyle(
                                                fontFamily: FeedFonts.dovemayo,
                                                fontSize: 13,
                                                color: FeedPalette.black,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                            const TextSpan(
                                              text: ' 님의 일기',
                                              style: TextStyle(
                                                fontFamily: FeedFonts.dovemayo,
                                                fontSize: 11,
                                                color: FeedPalette.lightBlack,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // RN DiaryCard Content(large) — 본문 텍스트(marginV5) + 첨부 이미지(100%×150). 데모는 이미지가 비어 미렌더.
                          CardBody(text: diary.text, image: diary.image, isLarge: true),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DiaryCountChip(icon: FeedIcons.like, count: likeCount),
                              const SizedBox(width: 15),
                              DiaryCountChip(icon: FeedIcons.comment, count: diary.commentCount),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const CardSeedling(isLarge: true),
      ],
    );
  }
}
