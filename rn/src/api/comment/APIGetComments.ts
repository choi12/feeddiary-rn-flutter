import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse } from '../types';

import { CommentDTO, CommentResponse, CommentsDTOSchema } from './types';

export interface APIGetCommentsParams {
  diaryIdx: number;
}

export const APIGetComments = async ({ diaryIdx }: APIGetCommentsParams): Promise<CommentDTO[]> => {
  const OPERATION_NAME = '댓글 리스트';
  try {
    const response = await request.get<APIResponse<CommentResponse[]>>(`/comment/list/${diaryIdx}`);
    const responseData = response.data.resData!;

    return CommentsDTOSchema.parse(responseData);
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
