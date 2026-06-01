import { TabParamList } from '../../types';

export const BOTTOM_TAB_ICON: Record<keyof TabParamList, string> = {
  MyFlowerpot: 'seedling',
  MyDiary: 'book',
  Community: 'user-friends',
  Letters: 'email',
  Setting: 'cog',
};

export const LETTERS_CONFIG = {
  type: 'MaterialCommunityIcons',
  size: 23,
} as const;
