import { z } from 'zod';

export const LetterResponseSchema = z.object({
  idx: z.number(),
  text: z.string(),
  created_time: z.string(),
  deleted_time: z.string().optional(),
});

export type LetterResponse = z.infer<typeof LetterResponseSchema>;
