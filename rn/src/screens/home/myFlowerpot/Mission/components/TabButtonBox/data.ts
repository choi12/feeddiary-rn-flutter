import { TABS } from '../../types';

const TAB_LABELS: Record<keyof typeof TABS, string> = {
  IN_PROGRESS: '진행 중',
  COMPLETED: '완료',
};

export const MISSION_TABS = Object.entries(TABS).map(([key, value]) => ({
  type: key,
  label: TAB_LABELS[key as keyof typeof TABS],
  value,
}));
