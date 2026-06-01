import { Mission } from '@/types/mission';

import { MissionResponseSchema, MissionsResponseSchema } from './response';

export type MissionDTO = {
  idx: number;
  type: Mission;
  count: number;
  maxCount: number;
  isCompleted: 0 | 1;
};

export type MissionsDTO = {
  completed: MissionDTO[];
  inProgress: MissionDTO[];
};

export const MissionDTOSchema = MissionResponseSchema.transform(
  (m): MissionDTO => ({
    idx: m.idx,
    type: m.type,
    count: m.count,
    maxCount: m.max_count,
    isCompleted: m.is_completed,
  }),
);

export const MissionsDTOSchema = MissionsResponseSchema.transform(
  (m): MissionsDTO => ({
    completed: m.completed.map((x) => ({
      idx: x.idx,
      type: x.type,
      count: x.count,
      maxCount: x.max_count,
      isCompleted: x.is_completed,
    })),
    inProgress: m.inProgress.map((x) => ({
      idx: x.idx,
      type: x.type,
      count: x.count,
      maxCount: x.max_count,
      isCompleted: x.is_completed,
    })),
  }),
);
