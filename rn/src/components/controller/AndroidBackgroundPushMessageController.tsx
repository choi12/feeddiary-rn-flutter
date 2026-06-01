import notifee from '@notifee/react-native';
import React, { PropsWithChildren, useCallback, useEffect } from 'react';

import { isAndroid } from '@/constants';
import useUserInfo from '@/hooks/store/useUserInfo';
import { reportError } from '@/utils/error/reportError';
import { moveToComments } from '@/utils/notifications/pushNavigation';

function AndroidBackgroundPushMessageController({ children }: PropsWithChildren) {
  const userNickname = useUserInfo('nickname');

  const handleInitialPushNotification = useCallback(async () => {
    try {
      const init = await notifee.getInitialNotification();
      if (!init?.notification.data?.diaryIdx || !userNickname) return;

      const diaryIdx = init.notification.data.diaryIdx;
      moveToComments(userNickname, Number(diaryIdx));
    } catch (error) {
      reportError(error);
    }
  }, [userNickname]);

  useEffect(() => {
    if (!isAndroid) return;
    handleInitialPushNotification();
  }, [handleInitialPushNotification]);

  return <>{children}</>;
}

export default AndroidBackgroundPushMessageController;
