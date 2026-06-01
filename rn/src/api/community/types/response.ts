import { z } from 'zod';

import { MyDiaryResponseSchema } from '@/api/diary/types';

export const CommunityDiaryResponseSchema = MyDiaryResponseSchema.extend({
  user_image: z.string(),
  background: z.string(),
  character: z.string(),
  isLike: z.boolean(),
});

export type CommunityDiaryResponse = z.infer<typeof CommunityDiaryResponseSchema>;
