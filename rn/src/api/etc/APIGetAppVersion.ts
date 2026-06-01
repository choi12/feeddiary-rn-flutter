import { isAndroid } from '@/constants';

import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

import { AppVersionResponse, AppVersionResponseSchema } from './types/response';

export const APIGetAppVersion = async (): Promise<string> => {
  const OPERATION_NAME = '앱 버전';
  try {
    const response = await request.get<APIResponse<AppVersionResponse>>('/etc/app-version');
    const responseData = AppVersionResponseSchema.parse(response.data.resData!);

    return isAndroid ? responseData.app_version_android : responseData.app_version_ios;
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
