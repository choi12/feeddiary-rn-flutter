import { Mission } from '@/types/mission';

import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

import { CompleteMissionRequest, CompleteMissionResponse } from './types';

export interface APICompleteMissionParams {
  missionIdx: number;
  type: Mission;
}

export const APICompleteMission = async ({
  missionIdx,
  type,
}: APICompleteMissionParams): Promise<CompleteMissionResponse> => {
  const OPERATION_NAME = '미션 완료(보상 받기)';
  try {
    const requestData: CompleteMissionRequest = { mission_idx: missionIdx, type };
    const response = await request.post<APIResponse<CompleteMissionResponse>>('/mission', requestData);
    const responseData = response.data.resData!;

    return responseData;
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
