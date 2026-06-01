import { z } from 'zod';

const ZeroOrOne = z.union([z.literal(0), z.literal(1)]);

export const MyDiaryResponseSchema = z.object({
  idx: z.number(),
  user_idx: z.number(),
  nickname: z.string(),
  sticker: z.string(),
  text: z.string(),
  image: z.string().optional(),
  created_time: z.string(),
  updated_time: z.string().optional(),
  deleted_time: z.string().optional(),
  is_visible: ZeroOrOne,
  like_count: z.number(),
  commentCount: z.number(),
});

export const DailyDiaryResponseSchema = z.object({
  idx: z.number(),
  sticker: z.string(),
  text: z.string(),
  image: z.string().optional(),
  created_time: z.string(),
  updated_time: z.string().optional(),
  is_visible: ZeroOrOne,
});

export const CreateDiaryResponseSchema = z.object({
  diaryIdx: z.number(),
});

export const LikeDiaryResponseSchema = z.object({
  like_count: z.number(),
  isLike: z.boolean(),
});

export const SetVisibilityResponseSchema = z.object({
  is_visible: ZeroOrOne,
});

export type MyDiaryResponse = z.infer<typeof MyDiaryResponseSchema>;
export type DailyDiaryResponse = z.infer<typeof DailyDiaryResponseSchema>;
export type CreateDiaryResponse = z.infer<typeof CreateDiaryResponseSchema>;
export type LikeDiaryResponse = z.infer<typeof LikeDiaryResponseSchema>;
export type SetVisibilityResponse = z.infer<typeof SetVisibilityResponseSchema>;
