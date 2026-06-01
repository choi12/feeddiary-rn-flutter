import { CommunitySort } from '@/types/community';

import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

import { CommunityDiariesDTOSchema, CommunityDiaryDTO, CommunityDiaryResponse, GetCommunityDiariesRequest } from './types';

export interface APIGetCommunityDiariesParams {
  skip: number;
  sortType: CommunitySort;
}

export const APIGetCommunityDiaries = async ({
  skip,
  sortType,
}: APIGetCommunityDiariesParams): Promise<CommunityDiaryDTO[]> => {
  const OPERATION_NAME = '공유 일기 리스트';
  try {
    const requestData: GetCommunityDiariesRequest = { skip, sort_type: sortType };
    const response = await request.get<APIResponse<CommunityDiaryResponse[]>>('/diary/community-list', {
      params: requestData,
    });
    const responseData = response.data.resData!;

    return CommunityDiariesDTOSchema.parse(responseData);
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
