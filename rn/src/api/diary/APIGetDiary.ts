import { CommunityDiaryDTO, CommunityDiaryDTOSchema, CommunityDiaryResponse } from '../community/types';
import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

export interface APIGetDiaryParams {
  diaryIdx: number;
}

export const APIGetDiary = async ({ diaryIdx }: APIGetDiaryParams): Promise<CommunityDiaryDTO> => {
  const OPERATION_NAME = '일기 상세';
  try {
    const response = await request.get<APIResponse<CommunityDiaryResponse>>(`/diary/${diaryIdx}`);
    const responseData = response.data.resData!;

    return CommunityDiaryDTOSchema.parse(responseData);
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
