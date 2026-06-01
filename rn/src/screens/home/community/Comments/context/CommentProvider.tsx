import React, { PropsWithChildren, useMemo } from 'react';

import useCommentsQuery from '../hooks/useCommentsQuery';

import { CommentContext } from './CommentContext';

interface CommentProviderProps {
  diaryIdx: number;
  author: string;
}

function CommentProvider({ children, diaryIdx, author }: PropsWithChildren<CommentProviderProps>) {
  const { data: comments, refetch, isLoading, isError } = useCommentsQuery({ diaryIdx });

  const contextValue = useMemo(
    () => ({
      comments: comments ?? [],
      refetch,
      author,
      diaryIdx,
      isLoading,
      isError,
    }),
    [comments, refetch, author, diaryIdx, isLoading, isError],
  );

  return <CommentContext.Provider value={contextValue}>{children}</CommentContext.Provider>;
}

export default CommentProvider;
