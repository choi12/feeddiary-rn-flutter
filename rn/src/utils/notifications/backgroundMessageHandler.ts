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
