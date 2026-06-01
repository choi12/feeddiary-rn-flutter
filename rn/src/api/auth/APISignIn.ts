import { UnauthorizedError } from '@/types/errors';

import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

import { SignInRequest, UserDTO, UserDTOSchema, UserResponse } from './types';

export interface APISignInParams {
  userId: string;
  fcmToken: string;
}

export const APISignIn = async ({ userId, fcmToken }: APISignInParams): Promise<UserDTO> => {
  const OPERATION_NAME = '로그인';
  try {
    const requestData: SignInRequest = { user_id: userId, fcm_token: fcmToken };
    const response = await request.post<APIResponse<UserResponse>>('/auth/sign-in', requestData);
    const responseData = response.data.resData!;

    return UserDTOSchema.parse(responseData);
  } catch (error) {
    if (error instanceof UnauthorizedError) {
      throw error;
    }
    throw formatAPIError(error, OPERATION_NAME);
  }
};
