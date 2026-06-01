import { UserDTO, UserDTOSchema, UserResponse } from '../auth/types';
import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

export interface APIUpdateProfileParams {
  updateProfileFormData: FormData;
}

export const APIUpdateProfile = async ({ updateProfileFormData }: APIUpdateProfileParams): Promise<UserDTO> => {
  const OPERATION_NAME = '프로필 업데이트';
  try {
    const response = await request.put<APIResponse<UserResponse>>('/user', updateProfileFormData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
    const responseData = response.data.resData!;

    return UserDTOSchema.parse(responseData);
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
