import { useMutation, useQueryClient } from '@tanstack/react-query';
import React, { useCallback } from 'react';

import { CommunityDiaryDTO } from '@/api/community/types';
import { APIDeleteDiary, APIDeleteDiaryParams } from '@/api/diary/APIDeleteDiary';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS, MESSAGE, MODAL_CONTENT, MODAL_BUTTON, TOAST_BOTTOM_OFFSET } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';
import useAlertModal from '@/hooks/store/useAlertModal';
import useBottomSheetModal from '@/hooks/store/useBottomSheetModal';
import useToast from '@/hooks/store/useToast';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import { AlertModalContent, BottomSheetModalContent } from '@/types/modal';
import { invalidateQueries } from '@/utils/query/invalidateQueries';

interface UseDiaryActionsProps {
  diary: CommunityDiaryDTO | undefined;
  isVisible: boolean;
  toggleVisibility: () => boolean | null;
}

function useDiaryActions({ diary, isVisible, toggleVisibility }: UseDiaryActionsProps) {
  const navigation = useScreenNavigation();
  const queryClient = useQueryClient();

  const { openBottomSheetModal, closeBottomSheetModal } = useBottomSheetModal();
  const { openAlertModal, closeAlertModal } = useAlertModal();
  const { showToast } = useToast();
  const handleErrorWithToast = useErrorToast();

  const handleSetVisibility = useCallback(() => {
    const nextVisible = toggleVisibility();
    if (nextVisible === null) return;
    closeBottomSheetModal();
    showToast(
      nextVisible ? MESSAGE.DIARY.PUBLISHED : MESSAGE.DIARY.UNPUBLISHED,
      TOAST_BOTTOM_OFFSET.DIARY_DETAILS,
    );
  }, [closeBottomSheetModal, showToast, toggleVisibility]);

  const { mutateAsync: deleteDiaryMutation, isPending: isDeleteDiaryPending } = useMutation({
    mutationFn: async () => {
      if (!diary) throw new Error('diary is required for deleteDiary');
      const params: APIDeleteDiaryParams = {
        diaryIdx: diary.idx,
      };
      await APIDeleteDiary(params);
    },
    onSuccess: () => invalidateQueries.deleteDiary(queryClient),
  });

  const handleDeleteDiary = useCallback(async () => {
    try {
      await deleteDiaryMutation();
      closeAlertModal();

      navigation.goBack();
      showToast(MESSAGE.DIARY.DELETED, TOAST_BOTTOM_OFFSET.HOME_SCREEN);
    } catch (error) {
      handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.DIARY_DETAILS);
    }
  }, [handleErrorWithToast, showToast, deleteDiaryMutation, closeAlertModal, navigation]);

  const goEditDiary = useCallback(() => {
    closeBottomSheetModal();
    navigation.replace('CreateDiary', { diary });
  }, [closeBottomSheetModal, diary, navigation]);

  const handleOpenDiaryActionModal = useCallback(() => {
    const deleteModalContent: AlertModalContent = {
      message: MODAL_CONTENT.DIARY.DELETE_CONFIRM,
      buttons: [
        { text: MODAL_BUTTON.COMMON.CLOSE, onPress: closeAlertModal, style: 'cancel' },
        {
          text: MODAL_BUTTON.COMMON.DELETE,
          onPress: handleDeleteDiary,
          isLoading: isDeleteDiaryPending,
          style: 'default',
        },
      ],
    };
    const modalContent: BottomSheetModalContent[] | undefined = [
      {
        title: MODAL_CONTENT.DIARY.VISIBILITY.toggle(isVisible),
        icon: (
          <VectorIcon
            type="Ionicons"
            name={isVisible ? 'eye-off' : 'eye'}
            color={isVisible ? COLORS.GRAYSCALE.DARK_GRAY : COLORS.CORE.MAIN}
            size={18}
          />
        ),
        color: isVisible ? COLORS.GRAYSCALE.DARK_GRAY : COLORS.CORE.MAIN,
        onPress: handleSetVisibility,
      },
      {
        title: MODAL_CONTENT.DIARY.VISIBILITY.EDIT,
        color: COLORS.GRAYSCALE.LIGHT_BLACK,
        onPress: goEditDiary,
      },
      {
        title: MODAL_CONTENT.DIARY.VISIBILITY.DELETE,
        color: COLORS.ACCENT.ORANGE,
        onPress: () => {
          closeBottomSheetModal();
          openAlertModal(deleteModalContent);
        },
      },
    ];

    openBottomSheetModal(modalContent);
  }, [
    openBottomSheetModal,
    closeBottomSheetModal,
    goEditDiary,
    isVisible,
    openAlertModal,
    handleSetVisibility,
    closeAlertModal,
    handleDeleteDiary,
    isDeleteDiaryPending,
  ]);

  return { handleOpenDiaryActionModal };
}

export default useDiaryActions;
