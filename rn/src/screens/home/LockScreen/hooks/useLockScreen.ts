import { useCallback, useEffect, useState } from 'react';
import { BackHandler } from 'react-native';

import { isAndroid, MESSAGE, PASSWORD_LENGTH, TOAST_BOTTOM_OFFSET } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';
import usePrefetchFlowerpot from '@/hooks/prefetch/usePrefetchFlowerpot';
import useToast from '@/hooks/store/useToast';
import { getLockPassword } from '@/utils/storage/lock';

interface UseLockScreenProps {
  isBackground: boolean;
}

function useLockScreen({ isBackground }: UseLockScreenProps) {
  const navigation = useScreenNavigation();

  const [storedPassword, setStoredPassword] = useState('');
  const [currentPassword, setCurrentPassword] = useState('');

  const prefetchFlowerpot = usePrefetchFlowerpot();
  const { showToast } = useToast();

  const handleSetPassword = useCallback((number: string) => {
    setCurrentPassword((prev) => (prev.length < PASSWORD_LENGTH ? prev + number : prev));
  }, []);

  const handleClearPassword = useCallback(() => {
    if (!currentPassword) {
      return setCurrentPassword('');
    }
    setCurrentPassword((prev) => prev.slice(0, -1));
  }, [currentPassword]);

  // 백그라운드에서 복귀 시 안드로이드 뒤로가기 버튼으로 잠금화면을 우회하는 것을 방지
  useEffect(() => {
    if (isAndroid && isBackground) {
      const backHandler = BackHandler.addEventListener('hardwareBackPress', () => true);

      return () => backHandler.remove();
    }
  }, [isBackground]);

  useEffect(() => {
    const getLockInfo = () => {
      const stored = getLockPassword();
      if (stored) {
        setStoredPassword(stored);
      }
    };
    getLockInfo();
  }, []);

  useEffect(() => {
    const verifyPassword = async () => {
      if (currentPassword.length !== PASSWORD_LENGTH) return;

      if (currentPassword !== storedPassword) {
        showToast(MESSAGE.LOCK.PASSWORD_MISMATCH, TOAST_BOTTOM_OFFSET.INNER_SCREEN);
        setCurrentPassword('');
        return;
      }

      if (isBackground) {
        navigation.goBack();
      } else {
        await prefetchFlowerpot();
        navigation.replace('BottomTab', { screen: 'MyFlowerpot' });
      }
    };

    verifyPassword();
  }, [currentPassword, storedPassword, isBackground, navigation, showToast, prefetchFlowerpot]);

  return {
    currentPassword,
    handleSetPassword,
    handleClearPassword,
  };
}

export default useLockScreen;
