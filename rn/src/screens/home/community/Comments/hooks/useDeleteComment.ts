import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useCallback } from 'react';

import { APIDeleteComment, APIDeleteCommentParams } from '@/api/comment/APIDeleteComment';
import { CommentDTO } from '@/api/comment/types';
import { MODAL_CONTENT, MODAL_BUTTON, TOAST_BOTTOM_OFFSET, QUERY_KEYS } from '@/constants';
import useAlertModal from '@/hooks/store/useAlertModal';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import { AlertModalContent } from '@/types/modal';
import { delay } from '@/utils/common/delay';
import { invalidateQueries } from '@/utils/query/invalidateQueries';

import { useCommentContext } from '../context/CommentContext';

interface UseDeleteCommentProps {
  commentIdx: number;
}

function useDeleteComment({ commentIdx }: UseDeleteCommentProps) {
  const queryClient = useQueryClient();

  const { diaryIdx } = useCommentContext();
  const { openAlertModal, closeAlertModal } = useAlertModal();
  const handleErrorWithToast = useErrorToast();

  const { mutateAsync: deleteCommentMutation, isPending: isDeleteCommentPending } = useMutation({
    mutationFn: async () => {
      const params: APIDeleteCommentParams = { commentIdx };
      await APIDeleteComment(params);
    },
    onMutate: async () => {
      await queryClient.cancelQueries({ queryKey: [QUERY_KEYS.COMMENTS, diaryIdx] });
      const previousComments = queryClient.getQueryData([QUERY_KEYS.COMMENTS, diaryIdx]);

      queryClient.setQueryData([QUERY_KEYS.COMMENTS, diaryIdx], (old: CommentDTO[]) =>
        old.filter((comment) => comment.idx !== commentIdx),
      );
      closeAlertModal();

      return { previousComments };
    },
    onError: (error, variables, context) => {
      queryClient.setQueryData([QUERY_KEYS.COMMENTS, diaryIdx], context?.previousComments);
    },
    onSettled: () => invalidateQueries.deleteComment(queryClient, diaryIdx),
  });

  const handleDeleteComment = useCallback(async () => {
    try {
      await deleteCommentMutation();
    } catch (error) {
      await delay(100);
      handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.COMMENT);
    }
  }, [deleteCommentMutation, handleErrorWithToast]);

  const handleOpenDeleteModal = useCallback(() => {
    const modalContent: AlertModalContent = {
      message: MODAL_CONTENT.COMMENT.DELETE_CONFIRM,
      buttons: [
        { text: MODAL_BUTTON.COMMON.CLOSE, onPress: closeAlertModal, style: 'cancel' },
        {
          text: MODAL_BUTTON.COMMON.DELETE,
          onPress: handleDeleteComment,
          style: 'default',
          isLoading: isDeleteCommentPending,
        },
      ],
      onPressBackground: closeAlertModal,
    };
    openAlertModal(modalContent);
  }, [openAlertModal, closeAlertModal, handleDeleteComment, isDeleteCommentPending]);

  return { handleOpenDeleteModal };
}

export default useDeleteComment;
