import { useCallback, useEffect } from 'react';
import { Linking } from 'react-native';

import { MODAL_CONTENT, MODAL_BUTTON, STORE_URL, TOAST_BOTTOM_OFFSET } from '@/constants';
import useAlertModal from '@/hooks/store/useAlertModal';
import useLoading from '@/hooks/store/useLoading';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import { AlertModalContent } from '@/types/modal';
import { VersionStatus } from '@/types/version';
import { checkVersion } from '@/utils/common/checkVersion';
import { reportError } from '@/utils/error/reportError';

import useSignIn from '../../SignIn/hooks/useSignIn';

function useAppUpdate() {
  const { autoSignIn } = useSignIn();
  const { showLoading, hideLoading } = useLoading();
  const { openAlertModal, closeAlertModal } = useAlertModal();
  const handleErrorWithToast = useErrorToast();

  const onUpdate = useCallback(async () => {
    try {
      const supported = await Linking.canOpenURL(STORE_URL);
      if (supported) {
        await Linking.openURL(STORE_URL);
      }
    } catch (error) {
      handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.INNER_SCREEN);
    }
  }, [handleErrorWithToast]);

  const closeAlertModalAndSignIn = useCallback(async () => {
    closeAlertModal();
    await autoSignIn();
  }, [closeAlertModal, autoSignIn]);

  const getModalContent = useCallback(
    (status: VersionStatus): AlertModalContent =>
      status === VersionStatus.OPTIONAL
        ? {
            message: MODAL_CONTENT.UPDATE.REQUIRED,
            buttons: [
              { text: MODAL_BUTTON.UPDATE.LATER, onPress: closeAlertModalAndSignIn, style: 'cancel' },
              { text: MODAL_BUTTON.UPDATE.CONFIRM, onPress: onUpdate, style: 'default' },
            ],
            onPressBackground: closeAlertModalAndSignIn,
          }
        : {
            message: MODAL_CONTENT.UPDATE.REQUIRED,
            buttons: [{ text: MODAL_BUTTON.UPDATE.CONFIRM, onPress: onUpdate, style: 'default' }],
            onPressBackground: () => {},
          },
    [closeAlertModalAndSignIn, onUpdate],
  );

  const checkAppVersion = useCallback(async () => {
    try {
      showLoading();

      const versionData = await checkVersion();
      if (versionData.status !== VersionStatus.UP_TO_DATE) {
        const updateModalContent = getModalContent(versionData.status);
        openAlertModal(updateModalContent);
        return;
      }
      await autoSignIn();
    } catch (error) {
      reportError(error);
      await autoSignIn();
    } finally {
      hideLoading();
    }
  }, [openAlertModal, showLoading, hideLoading, getModalContent, autoSignIn]);

  useEffect(() => {
    checkAppVersion();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);
}
export default useAppUpdate;
