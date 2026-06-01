import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse, APIStatus } from '../types';

export interface APIDeleteDiaryParams {
  diaryIdx: number;
}

export const APIDeleteDiary = async ({ diaryIdx }: APIDeleteDiaryParams): Promise<APIStatus> => {
  const OPERATION_NAME = '일기 삭제';
  try {
    const response = await request.delete<APIResponse<string>>(`/diary/${diaryIdx}`);

    return response.data.status;
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
