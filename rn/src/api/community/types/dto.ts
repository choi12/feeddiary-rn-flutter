import { MyDiaryDTO } from '@/api/diary/types';

import { CommunityDiaryResponseSchema } from './response';

export interface CommunityDiaryDTO extends MyDiaryDTO {
  userImage: string;
  background: string;
  character: string;
  isLike: boolean;
}

export const CommunityDiaryDTOSchema = CommunityDiaryResponseSchema.transform(
  (d): CommunityDiaryDTO => ({
    idx: d.idx,
    userIdx: d.user_idx,
    nickname: d.nickname,
    sticker: d.sticker,
    text: d.text,
    image: d.image,
    createdAt: d.created_time,
    updatedAt: d.updated_time,
    isVisible: d.is_visible,
    likeCount: d.like_count,
    commentCount: d.commentCount,
    userImage: d.user_image,
    background: d.background,
    character: d.character,
    isLike: d.isLike,
  }),
);

export const CommunityDiariesDTOSchema = CommunityDiaryDTOSchema.array();
