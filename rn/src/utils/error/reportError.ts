import * as Sentry from '@sentry/react-native';

import { MESSAGE } from '@/constants';

export const reportError = (error: unknown) => {
  if (__DEV__) console.error(MESSAGE.SYSTEM.ERROR_PREFIX, error);
  Sentry.captureException(error);
};
