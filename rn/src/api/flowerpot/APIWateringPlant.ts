import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse, APIStatus } from '../types';

import { FlowerpotResponse } from './types';

export const APIWateringPlant = async (): Promise<APIStatus> => {
  const OPERATION_NAME = '물 주기';
  try {
    const response = await request.post<APIResponse<FlowerpotResponse>>('/flowerpot/watering');

    return response.data.status;
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
