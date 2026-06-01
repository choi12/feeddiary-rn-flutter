import { useCallback } from 'react';

import { APISignOut } from '@/api/auth/APISignOut';
import { MESSAGE, MODAL_BUTTON, MODAL_CONTENT, TOAST_BOTTOM_OFFSET } from '@/constants';
import useAlertModal from '@/hooks/store/useAlertModal';
import useLoading from '@/hooks/store/useLoading';
import useToast from '@/hooks/store/useToast';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import { AlertModalContent } from '@/types/modal';

import useAuthCleanup from './useAuthCleanup';

function useSignOut() {
  const { cleanupUserData } = useAuthCleanup();

  const { showLoading, hideLoading } = useLoading();
  const { openAlertModal, closeAlertModal } = useAlertModal();
  const { showToast } = useToast();
  const handleErrorWithToast = useErrorToast();

  const handleSignOut = useCallback(async () => {
    closeAlertModal();
    try {
      showLoading();

      await APISignOut();
      await cleanupUserData();

      showToast(MESSAGE.ACCOUNT.LOGGED_OUT, TOAST_BOTTOM_OFFSET.INNER_SCREEN);
    } catch (error) {
      handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.HOME_SCREEN);
    } finally {
      hideLoading();
    }
  }, [handleErrorWithToast, closeAlertModal, showLoading, hideLoading, showToast, cleanupUserData]);

  const openSignOutModal = useCallback(() => {
    const modalContent: AlertModalContent = {
      message: MODAL_CONTENT.ACCOUNT.LOGOUT_CONFIRM,
      buttons: [
        { text: MODAL_BUTTON.COMMON.CLOSE, onPress: closeAlertModal, style: 'cancel' },
        { text: MODAL_BUTTON.ACCOUNT.LOGOUT, onPress: handleSignOut, style: 'default' },
      ],
    };
    openAlertModal(modalContent);
  }, [openAlertModal, closeAlertModal, handleSignOut]);

  return { openSignOutModal };
}

export default useSignOut;
