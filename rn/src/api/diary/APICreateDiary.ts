import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

import { APIWriteDiaryParams, CreateDiaryResponse } from './types';

export const APICreateDiary = async ({ diaryFormData }: APIWriteDiaryParams): Promise<CreateDiaryResponse> => {
  const OPERATION_NAME = '일기 등록';
  try {
    const response = await request.post<APIResponse<CreateDiaryResponse>>('/diary', diaryFormData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    const responseData = response.data.resData!;

    return responseData;
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
