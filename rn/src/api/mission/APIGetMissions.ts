import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

import { MissionsDTO, MissionsDTOSchema, MissionsResponse } from './types';

export const APIGetMissions = async (): Promise<MissionsDTO> => {
  const OPERATION_NAME = '미션 리스트';
  try {
    const response = await request.get<APIResponse<MissionsResponse>>('/mission/list');
    const responseData = response.data.resData!;

    return MissionsDTOSchema.parse(responseData);
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
