import { useMutation } from '@tanstack/react-query';
import { useCallback } from 'react';

import { APIDeleteAccount } from '@/api/user/APIDeleteAccount';
import { MESSAGE, MODAL_BUTTON, MODAL_CONTENT, TOAST_BOTTOM_OFFSET } from '@/constants';
import useAlertModal from '@/hooks/store/useAlertModal';
import useLoading from '@/hooks/store/useLoading';
import useToast from '@/hooks/store/useToast';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import { AlertModalContent } from '@/types/modal';
import { delay } from '@/utils/common/delay';

import useAuthCleanup from './useAuthCleanup';

function useDeleteAccount() {
  const { cleanupUserData } = useAuthCleanup();
  const { showLoading, hideLoading } = useLoading();
  const { openAlertModal, closeAlertModal } = useAlertModal();
  const { showToast } = useToast();
  const handleErrorWithToast = useErrorToast();

  const { mutateAsync: deleteAccountMutation, isPending } = useMutation({
    mutationFn: APIDeleteAccount,
  });

  const handleDeleteAccount = useCallback(async () => {
    try {
      showLoading();

      await deleteAccountMutation();
      await cleanupUserData();

      closeAlertModal();
      hideLoading();
      showToast(MESSAGE.ACCOUNT.ACCOUNT_DELETED, TOAST_BOTTOM_OFFSET.INNER_SCREEN);
    } catch (error) {
      hideLoading();

      await delay(100);
      handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.BUTTON_SCREEN);
    }
  }, [
    closeAlertModal,
    showLoading,
    deleteAccountMutation,
    hideLoading,
    cleanupUserData,
    handleErrorWithToast,
    showToast,
  ]);

  const openDeleteAccountModal = useCallback(() => {
    const modalContent: AlertModalContent = {
      message: MODAL_CONTENT.ACCOUNT.DELETE_CONFIRM,
      buttons: [
        { text: MODAL_BUTTON.COMMON.CLOSE, onPress: closeAlertModal, style: 'cancel' },
        { text: MODAL_BUTTON.ACCOUNT.DELETE, onPress: handleDeleteAccount, style: 'default', isLoading: isPending },
      ],
    };
    openAlertModal(modalContent);
  }, [openAlertModal, closeAlertModal, handleDeleteAccount, isPending]);

  return { openDeleteAccountModal };
}

export default useDeleteAccount;
