import { ConflictError } from '@/types/errors';

import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

import { UserDTO, UserDTOSchema, UserResponse } from './types';

export interface APISignUpParams {
  signUpFormData: FormData;
}

export const APISignUp = async ({ signUpFormData }: APISignUpParams): Promise<UserDTO> => {
  const OPERATION_NAME = '회원가입';
  try {
    const response = await request.post<APIResponse<UserResponse>>('/auth/sign-up', signUpFormData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    const responseData = response.data.resData!;

    return UserDTOSchema.parse(responseData);
  } catch (error) {
    if (error instanceof ConflictError) {
      throw error;
    }
    throw formatAPIError(error, OPERATION_NAME);
  }
};
