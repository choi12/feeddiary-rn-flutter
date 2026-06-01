import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

import { MyDiariesDTOSchema, MyDiaryDTO, MyDiaryResponse } from './types';

export interface APIGetDiariesParams {
  skip: number;
}

export const APIGetDiaries = async ({ skip }: APIGetDiariesParams): Promise<MyDiaryDTO[]> => {
  const OPERATION_NAME = '나의 일기 리스트';
  try {
    const response = await request.get<APIResponse<MyDiaryResponse[]>>('/diary/list', { params: { skip } });
    const responseData = response.data.resData!;

    return MyDiariesDTOSchema.parse(responseData);
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
