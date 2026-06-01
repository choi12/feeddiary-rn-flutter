import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

import { CreateCommentRequest } from './types';

export interface APICreateCommentParams {
  diaryIdx: number;
  text: string;
}

export const APICreateComment = async ({ diaryIdx, text }: APICreateCommentParams): Promise<string> => {
  const OPERATION_NAME = '댓글 작성';
  try {
    const requestData: CreateCommentRequest = { diary_idx: diaryIdx, text };
    const response = await request.post<APIResponse<string>>('/comment', requestData);
    const responseData = response.data.resData!;

    return responseData;
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
