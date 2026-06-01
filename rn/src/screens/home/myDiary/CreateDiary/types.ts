import { Dayjs } from 'dayjs';

export type DiaryState = {
  text: string;
  sticker: string;
  date: Dayjs;
  isDeleted: boolean;
};

export type DiaryStateUpdater = (updates: Partial<DiaryState>) => void;
