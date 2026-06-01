import { QueryObserverResult } from '@tanstack/react-query';

import { CommentDTO } from '@/api/comment/types';
import useTypedContext from '@/hooks/core/context/useTypedContext';
import { createNamedContext } from '@/utils/context/createNamedContext';

type CommentContext = {
  comments: CommentDTO[];
  author: string;
  diaryIdx: number;

  refetch: () => Promise<QueryObserverResult<CommentDTO[], Error>>;
  isLoading: boolean;
  isError: boolean;
};

export const CommentContext = createNamedContext<CommentContext | undefined>('CommentContext', undefined);
export const useCommentContext = () => useTypedContext(CommentContext);
