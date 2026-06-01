import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

import { APIWriteDiaryParams, CreateDiaryResponse } from './types';

export const APIEditDiary = async ({ diaryFormData }: APIWriteDiaryParams): Promise<CreateDiaryResponse> => {
  const OPERATION_NAME = '일기 수정';
  try {
    const response = await request.put<APIResponse<CreateDiaryResponse>>('/diary', diaryFormData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    const responseData = response.data.resData!;

    return responseData;
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
