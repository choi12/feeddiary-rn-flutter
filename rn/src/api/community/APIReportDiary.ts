import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse, APIStatus } from '../types';

import { ReportDiaryRequest } from './types';

export interface APIReportDiaryParams {
  diaryIdx: number;
  text: string;
  blockIdx: number;
}

export const APIReportDiary = async ({ diaryIdx, text, blockIdx }: APIReportDiaryParams): Promise<APIStatus> => {
  const OPERATION_NAME = '일기 신고(유저 차단)';
  try {
    const requestData: ReportDiaryRequest = { diary_idx: diaryIdx, text, block_idx: blockIdx };
    const response = await request.post<APIResponse<string>>('/diary/report', requestData);

    return response.data.status;
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
