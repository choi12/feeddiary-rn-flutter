import { NavigationContainer } from '@react-navigation/native';
import * as Sentry from '@sentry/react-native';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import dayjs from 'dayjs';
import isSameOrBefore from 'dayjs/plugin/isSameOrBefore';
import React, { useEffect } from 'react';
import { SafeAreaProvider } from 'react-native-safe-area-context';

import { setupMockAdapter } from './api/mock';

dayjs.extend(isSameOrBefore);

setupMockAdapter();

import DemoBanner from './components/common/DemoBanner';
import ErrorBoundary from './components/common/ErrorBoundary';
import GlobalModals from './components/modal/GlobalModals';
import { MainNavigation } from './navigation';
import { setupInitialAppConfig } from './utils/config/app';
import { QUERY_CLIENT_CONFIG } from './utils/config/query';
import { initSentry, routingInstrumentation } from './utils/config/sentry';
import { reportError } from './utils/error/reportError';
import { navigationRef } from './utils/navigation/navigationRef';

initSentry();

const queryClient = new QueryClient(QUERY_CLIENT_CONFIG);

function App() {
  useEffect(() => {
    setupInitialAppConfig().catch((error) => reportError(error));
  }, []);

  return (
    <SafeAreaProvider>
      <DemoBanner>
        <QueryClientProvider client={queryClient}>
          <NavigationContainer
            ref={navigationRef}
            onReady={() => {
              routingInstrumentation.registerNavigationContainer(navigationRef);
            }}
          >
            <ErrorBoundary>
              <MainNavigation />
            </ErrorBoundary>
            <GlobalModals />
          </NavigationContainer>
        </QueryClientProvider>
      </DemoBanner>
    </SafeAreaProvider>
  );
}

export default Sentry.wrap(App);
