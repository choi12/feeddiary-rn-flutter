export type MissionCount = {
  inProgress: number;
  completed: number;
};

export const TABS = {
  IN_PROGRESS: 'inProgress',
  COMPLETED: 'completed',
} as const;

export type MissionTab = (typeof TABS)[keyof typeof TABS];
