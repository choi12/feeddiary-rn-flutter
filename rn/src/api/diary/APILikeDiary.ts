import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

import { LikeDiaryDTO, LikeDiaryDTOSchema, LikeDiaryRequest, LikeDiaryResponse } from './types';

export interface APILikeDiaryParams {
  diaryIdx: number;
}

export const APILikeDiary = async ({ diaryIdx }: APILikeDiaryParams): Promise<LikeDiaryDTO> => {
  const OPERATION_NAME = '일기 좋아요';
  try {
    const requestData: LikeDiaryRequest = { diary_idx: diaryIdx };
    const response = await request.post<APIResponse<LikeDiaryResponse>>('/diary/like', requestData);
    const responseData = response.data.resData!;

    return LikeDiaryDTOSchema.parse(responseData);
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
