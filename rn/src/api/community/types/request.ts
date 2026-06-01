import { CommunitySort } from '@/types/community';

export interface GetCommunityDiariesRequest {
  skip: number;
  sort_type: CommunitySort;
}

export interface ReportDiaryRequest {
  diary_idx: number;
  text: string;
  block_idx: number;
}
