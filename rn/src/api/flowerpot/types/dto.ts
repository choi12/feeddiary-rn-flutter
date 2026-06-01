import { FlowerpotResponseSchema } from './response';

export type FlowerpotDTO = {
  level: number;
  exp: number;
  maxExp: number;
  wateringCount: number;
  loveCount: number;
  showBadge: boolean;
};

export const FlowerpotDTOSchema = FlowerpotResponseSchema.transform(
  (f): FlowerpotDTO => ({
    level: f.level,
    exp: f.exp,
    maxExp: f.max_exp,
    wateringCount: f.watering_count,
    loveCount: f.love_count,
    showBadge: f.showBadge,
  }),
);
