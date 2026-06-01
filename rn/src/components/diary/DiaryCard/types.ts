import { CommunityDiaryDTO } from '@/api/community/types';
import { DailyDiaryDTO, MyDiaryDTO } from '@/api/diary/types';

export type Diary = MyDiaryDTO | DailyDiaryDTO | CommunityDiaryDTO;

export type DiaryCardSize = 'small' | 'large';
