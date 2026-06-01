import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useCallback } from 'react';

import { APICreateComment, APICreateCommentParams } from '@/api/comment/APICreateComment';
import { TOAST_BOTTOM_OFFSET } from '@/constants';
import useThrottle from '@/hooks/core/useThrottle';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import { invalidateQueries } from '@/utils/query/invalidateQueries';

import { useCommentContext } from '../context/CommentContext';

interface UseCreateCommentProps {
  text: string;
  setText: (text: string) => void;
}

function useCreateComment({ text, setText }: UseCreateCommentProps) {
  const queryClient = useQueryClient();

  const { diaryIdx } = useCommentContext();
  const handleErrorWithToast = useErrorToast();

  const { mutateAsync: createCommentMutation, isPending } = useMutation({
    mutationFn: async () => {
      const data: APICreateCommentParams = {
        diaryIdx,
        text: text.trim(),
      };
      await APICreateComment(data);
    },
    onSuccess: () => invalidateQueries.createComment(queryClient, diaryIdx),
  });

  const createComment = useCallback(async () => {
    if (isPending) return;

    try {
      await createCommentMutation();
      setText('');
    } catch (error) {
      handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.COMMENT);
    }
  }, [createCommentMutation, handleErrorWithToast, isPending, setText]);

  const throttledCreateComment = useThrottle({ callback: createComment });

  return { handleSubmitComment: throttledCreateComment, isPending };
}

export default useCreateComment;
