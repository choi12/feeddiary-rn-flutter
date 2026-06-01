import { ConflictError } from '@/types/errors';

import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse, APIStatus } from '../types';

export interface APICheckNicknameParams {
  nickname: string;
}

export const APICheckNickname = async ({ nickname }: APICheckNicknameParams): Promise<APIStatus> => {
  const OPERATION_NAME = '닉네임 중복 검사';
  try {
    const response = await request.post<APIResponse<undefined>>('/auth/check-nickname', { nickname });

    return response.data.status;
  } catch (error) {
    if (error instanceof ConflictError) {
      throw error;
    }
    throw formatAPIError(error, OPERATION_NAME);
  }
};
