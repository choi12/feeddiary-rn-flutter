import React, { PropsWithChildren, useCallback, useEffect, useRef } from 'react';
import { AppState, AppStateStatus } from 'react-native';

import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';
import { getUseLock } from '@/utils/storage/lock';

function LockScreenGuard({ children }: PropsWithChildren) {
  const navigation = useScreenNavigation();

  const appState = useRef(AppState.currentState);

  const checkLock = useCallback(() => {
    const lockEnabled = getUseLock();
    if (lockEnabled) {
      navigation.navigate('LockScreen', { isBackground: true });
    }
  }, [navigation]);

  const checkAppStateChange = useCallback(
    (nextAppState: AppStateStatus) => {
      // 앱이 백그라운드/비활성 상태에서 활성 상태로 전환될 때만 체크
      if (appState.current.match(/inactive|background/) && nextAppState === 'active') {
        checkLock();
      }
      appState.current = nextAppState;
    },
    [checkLock],
  );

  useEffect(() => {
    const appStateHandler = AppState.addEventListener('change', checkAppStateChange);
    return () => appStateHandler.remove();
  }, [checkAppStateChange]);

  return <>{children}</>;
}

export default LockScreenGuard;
