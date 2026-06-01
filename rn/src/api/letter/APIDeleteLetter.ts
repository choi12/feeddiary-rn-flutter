import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

import { LetterDTO, LetterDTOSchema, LetterResponse } from './types';

export interface APIDeleteLetterParams {
  letterIdx: number;
}

export const APIDeleteLetter = async ({ letterIdx }: APIDeleteLetterParams): Promise<LetterDTO> => {
  const OPERATION_NAME = '편지 삭제';
  try {
    const response = await request.delete<APIResponse<LetterResponse>>(`/letter/${letterIdx}`);

    return LetterDTOSchema.parse(response.data.resData!);
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
