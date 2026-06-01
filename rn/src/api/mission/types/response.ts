import { z } from 'zod';

import { Mission, RewardItem } from '@/types/mission';

const MissionSchema: z.ZodType<Mission> = z.enum(['diary', 'comment', 'visible', 'like']);
const PlantActionSchema = z.enum(['watering', 'love']);
const RewardItemSchema: z.ZodType<RewardItem> = z.object({
  count: z.number(),
  item: PlantActionSchema,
});

export const MissionResponseSchema = z.object({
  idx: z.number(),
  type: MissionSchema,
  count: z.number(),
  max_count: z.number(),
  is_completed: z.union([z.literal(0), z.literal(1)]),
});

export const MissionsResponseSchema = z.object({
  completed: MissionResponseSchema.array(),
  inProgress: MissionResponseSchema.array(),
});

export const CompleteMissionResponseSchema = z.object({
  missions: MissionsResponseSchema,
  reward: RewardItemSchema,
});

export type MissionResponse = z.infer<typeof MissionResponseSchema>;
export type MissionsResponse = z.infer<typeof MissionsResponseSchema>;
export type CompleteMissionResponse = z.infer<typeof CompleteMissionResponseSchema>;
