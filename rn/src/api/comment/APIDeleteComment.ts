import { formatAPIError } from '../formatAPIError';
import request from '../request';
import { APIResponse, APIStatus } from '../types';

export interface APIDeleteCommentParams {
  commentIdx: number;
}

export const APIDeleteComment = async ({ commentIdx }: APIDeleteCommentParams): Promise<APIStatus> => {
  const OPERATION_NAME = '댓글 삭제';
  try {
    const response = await request.delete<APIResponse<string>>(`/comment/${commentIdx}`);

    return response.data.status;
  } catch (error) {
    throw formatAPIError(error, OPERATION_NAME);
  }
};
