import notifee, { Event, EventType } from '@notifee/react-native';
import React, { PropsWithChildren, useCallback, useEffect } from 'react';

import useUserInfo from '@/hooks/store/useUserInfo';
import { reportError } from '@/utils/error/reportError';
import { moveToComments } from '@/utils/notifications/pushNavigation';

function ForegroundPushMessageController({ children }: PropsWithChildren) {
  const userNickname = useUserInfo('nickname');

  const navigateToComments = useCallback(
    ({ type, detail }: Event) => {
      if (type !== EventType.PRESS) return;
      if (!detail.notification?.data?.diaryIdx || !userNickname) return;

      const diaryIdx = detail.notification.data.diaryIdx;
      moveToComments(userNickname, Number(diaryIdx));
    },
    [userNickname],
  );

  // Firebase Messaging의 onMessage 구독은 데모 트랙에서 제거. 원본은 displayNotification 호출.

  useEffect(() => {
    const unsubscribe = notifee.onForegroundEvent((event) => {
      try {
        navigateToComments(event);
      } catch (error) {
        reportError(error);
      }
    });
    return () => unsubscribe();
  }, [navigateToComments]);

  return <>{children}</>;
}

export default ForegroundPushMessageController;
