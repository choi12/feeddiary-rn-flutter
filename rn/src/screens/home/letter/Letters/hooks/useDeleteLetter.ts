import { useMutation, useQueryClient } from '@tanstack/react-query';
import { useCallback } from 'react';

import { APIDeleteLetter, APIDeleteLetterParams } from '@/api/letter/APIDeleteLetter';
import { LetterDTO } from '@/api/letter/types';
import { MODAL_CONTENT, MODAL_BUTTON, TOAST_BOTTOM_OFFSET, QUERY_KEYS } from '@/constants';
import useAlertModal from '@/hooks/store/useAlertModal';
import useToast from '@/hooks/store/useToast';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import { AlertModalContent } from '@/types/modal';
import { delay } from '@/utils/common/delay';
import { invalidateQueries } from '@/utils/query/invalidateQueries';

function useDeleteLetter() {
  const queryClient = useQueryClient();

  const { openAlertModal, closeAlertModal } = useAlertModal();
  const { showToast } = useToast();
  const handleErrorWithToast = useErrorToast();

  const { mutateAsync: deleteLetterMutation, isPending: isDeleteLetterPending } = useMutation({
    mutationFn: async (letterIdx: number) => {
      const params: APIDeleteLetterParams = { letterIdx };
      await APIDeleteLetter(params);
    },
    onMutate: async (letterIdx) => {
      await queryClient.cancelQueries({ queryKey: [QUERY_KEYS.LETTERS] });

      const previousLetters = queryClient.getQueryData([QUERY_KEYS.LETTERS]);

      queryClient.setQueryData(
        [QUERY_KEYS.LETTERS],
        (old: { pages: LetterDTO[][]; pageParams: number[] } | undefined) => {
          if (!old) return { pages: [], pageParams: [] };

          return {
            ...old,
            pages: old.pages.map((page) => page.filter((letter) => letter.idx !== letterIdx)),
          };
        },
      );

      return { previousLetters };
    },
    onError: (error, letterIdx, context) => {
      queryClient.setQueryData([QUERY_KEYS.LETTERS], context?.previousLetters);
    },
    onSettled: () => invalidateQueries.deleteLetter(queryClient),
  });

  const handleDeleteLetter = useCallback(
    async (letterIdx: number) => {
      try {
        await deleteLetterMutation(letterIdx);
        closeAlertModal();

        await delay(100);
        showToast('편지가 삭제되었어요.', TOAST_BOTTOM_OFFSET.HOME_SCREEN);
      } catch (error) {
        await delay(100);
        handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.HOME_SCREEN);
      }
    },
    [closeAlertModal, deleteLetterMutation, handleErrorWithToast, showToast],
  );

  const handleOpenDeleteModal = useCallback(
    (letterIdx: number) => {
      const modalContent: AlertModalContent = {
        message: MODAL_CONTENT.LETTER.DELETE_CONFIRM,
        buttons: [
          { text: MODAL_BUTTON.COMMON.CLOSE, onPress: closeAlertModal, style: 'cancel' },
          {
            text: MODAL_BUTTON.COMMON.DELETE,
            onPress: () => handleDeleteLetter(letterIdx),
            style: 'default',
            isLoading: isDeleteLetterPending,
          },
        ],
        onPressBackground: closeAlertModal,
      };
      openAlertModal(modalContent);
    },
    [openAlertModal, closeAlertModal, handleDeleteLetter, isDeleteLetterPending],
  );

  return { handleOpenDeleteModal };
}

export default useDeleteLetter;
