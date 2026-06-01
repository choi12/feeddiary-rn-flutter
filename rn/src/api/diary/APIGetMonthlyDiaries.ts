import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

import { DailyDiariesDTOSchema, DailyDiaryDTO, DailyDiaryResponse } from './types';

export interface APIGetMonthlyDiariesParams {
  month: string;
}

export const APIGetMonthlyDiaries = async ({ month }: APIGetMonthlyDiariesParams): Promise<DailyDiaryDTO[]> => {
  const OPERATION_NAME = '월별 일기 리스트';
  try {
    const response = await request.get<APIResponse<DailyDiaryResponse[]>>(`/diary/list-by-month/${month}`);
    const responseData = response.data.resData!;

    return DailyDiariesDTOSchema.parse(responseData);
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
