import { z } from 'zod';

export const FlowerpotResponseSchema = z.object({
  level: z.number(),
  exp: z.number(),
  max_exp: z.number(),
  watering_count: z.number(),
  love_count: z.number(),
  showBadge: z.boolean(),
});

export type FlowerpotResponse = z.infer<typeof FlowerpotResponseSchema>;
