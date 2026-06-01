import { z } from 'zod';

export const CommentResponseSchema = z.object({
  idx: z.number(),
  nickname: z.string(),
  background: z.string(),
  character: z.string(),
  text: z.string(),
  created_time: z.string(),
  user_image: z.string(),
});

export type CommentResponse = z.infer<typeof CommentResponseSchema>;
