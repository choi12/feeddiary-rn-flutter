// FCM 백그라운드 메시지 핸들러 — 데모 트랙에서 Firebase 는 제거했으나 푸시 설계 코드는 보존한다(실 연동 시 index.js 에 등록).
import { reportError } from '../error/reportError';

import { displayNotification } from './displayNotification';
import type { RemoteMessage } from './types';

export const backgroundMessageHandler = async (remoteMessage: RemoteMessage) => {
  try {
    await displayNotification(remoteMessage);
  } catch (error) {
    reportError(error);
  }
};
