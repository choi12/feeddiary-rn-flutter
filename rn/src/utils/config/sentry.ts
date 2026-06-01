import * as Sentry from '@sentry/react-native';
import Config from 'react-native-config';

export const routingInstrumentation = Sentry.reactNavigationIntegration({
  enableTimeToInitialDisplay: true,
});

export const initSentry = () => {
  Sentry.init({
    dsn: Config.SENTRY_DSN,
    enabled: !__DEV__,
    tracesSampleRate: 0.2,
    _experiments: {
      profilesSampleRate: 0.1,
    },
    integrations: [
      routingInstrumentation,
      Sentry.reactNativeTracingIntegration(),
      Sentry.reactNativeErrorHandlersIntegration(),
    ],
  });
};
