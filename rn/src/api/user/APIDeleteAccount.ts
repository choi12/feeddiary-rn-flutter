import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse, APIStatus } from '../types';

export const APIDeleteAccount = async (): Promise<APIStatus> => {
  const OPERATION_NAME = '회원 탈퇴';
  try {
    const response = await request.delete<APIResponse<string>>('/user');

    return response.data.status;
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
