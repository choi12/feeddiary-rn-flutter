import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse, APIStatus } from '../types';

export const APISignOut = async (): Promise<APIStatus> => {
  const OPERATION_NAME = '로그아웃';
  try {
    const response = await request.post<APIResponse<string>>('/auth/sign-out');

    return response.data.status;
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
