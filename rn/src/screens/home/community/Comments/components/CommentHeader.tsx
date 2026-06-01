import React from 'react';

import CustomHeader from '@/components/common/CustomHeader';
import { COLORS } from '@/constants';

import { useCommentContext } from '../context/CommentContext';

function CommentHeader() {
  const { comments, isLoading, isError } = useCommentContext();

  if (isLoading || isError) return null;
  if (!comments) return null;

  return (
    <CustomHeader
      title={`댓글${isLoading ? '' : ` (${comments.length})`}`}
      backgroundColor={COLORS.CORE.BACKGROUND}
      hasCloseButton
    />
  );
}

export default CommentHeader;
