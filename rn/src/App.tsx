// 앱 루트 — 전역 Provider(SafeArea·Query·Navigation) 조립 및 mock/Sentry/초기설정 부트스트랩
import { NavigationContainer } from '@react-navigation/native';
import * as Sentry from '@sentry/react-native';
import { QueryCache, QueryClient, QueryClientProvider } from '@tanstack/react-query';
import dayjs from 'dayjs';
import isSameOrBefore from 'dayjs/plugin/isSameOrBefore';
import React, { useEffect } from 'react';
import { SafeAreaProvider } from 'react-native-safe-area-context';

import { setupMockAdapter } from './api/mock';
import DemoBanner from './components/common/DemoBanner';
import ErrorBoundary from './components/common/ErrorBoundary';
import GlobalModals from './components/modal/GlobalModals';
import { MainNavigation } from './navigation';
import { setupInitialAppConfig } from './utils/config/app';
import { QUERY_CLIENT_CONFIG } from './utils/config/query';
import { initSentry, routingInstrumentation } from './utils/config/sentry';
import { reportError } from './utils/error/reportError';
import { navigationRef } from './utils/navigation/navigationRef';

// dayjs 비교 플러그인 확장 (isSameOrBefore)
dayjs.extend(isSameOrBefore);

// mock 데모 모드(USE_MOCK=true)에서 axios 인스턴스에 mock 어댑터 부착
setupMockAdapter();

// Sentry 초기화 — enabled: !__DEV__ 이라 데모/dev 빌드에선 비활성(no-op)
initSentry();

// 조회 실패는 화면이 ErrorView 로 받되, 보고는 뮤테이션·렌더 에러와 같은 창구(reportError)로 모은다
const queryClient = new QueryClient({
  ...QUERY_CLIENT_CONFIG,
  queryCache: new QueryCache({ onError: reportError }),
});

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
