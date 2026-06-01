import {
  DailyDiaryResponseSchema,
  LikeDiaryResponseSchema,
  MyDiaryResponseSchema,
  SetVisibilityResponseSchema,
} from './response';

export interface MyDiaryDTO {
  idx: number;
  userIdx: number;
  nickname: string;
  sticker: string;
  text: string;
  image?: string;
  createdAt: string;
  updatedAt?: string;
  isVisible: 1 | 0;
  likeCount: number;
  commentCount: number;
}

export interface DailyDiaryDTO {
  idx: number;
  sticker: string;
  text: string;
  image?: string;
  createdAt: string;
  updatedAt?: string;
  isVisible: 1 | 0;
}

export type LikeDiaryDTO = {
  likeCount: number;
  isLike: boolean;
};

export type SetVisibilityDTO = {
  isVisible: 1 | 0;
};

export const MyDiaryDTOSchema = MyDiaryResponseSchema.transform(
  (d): MyDiaryDTO => ({
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
  }),
);

export const MyDiariesDTOSchema = MyDiaryDTOSchema.array();

export const DailyDiaryDTOSchema = DailyDiaryResponseSchema.transform(
  (d): DailyDiaryDTO => ({
    idx: d.idx,
    sticker: d.sticker,
    text: d.text,
    image: d.image,
    createdAt: d.created_time,
    updatedAt: d.updated_time,
    isVisible: d.is_visible,
  }),
);

export const DailyDiariesDTOSchema = DailyDiaryDTOSchema.array();

export const LikeDiaryDTOSchema = LikeDiaryResponseSchema.transform(
  (r): LikeDiaryDTO => ({
    likeCount: r.like_count,
    isLike: r.isLike,
  }),
);

export const SetVisibilityDTOSchema = SetVisibilityResponseSchema.transform(
  (r): SetVisibilityDTO => ({
    isVisible: r.is_visible,
  }),
);
