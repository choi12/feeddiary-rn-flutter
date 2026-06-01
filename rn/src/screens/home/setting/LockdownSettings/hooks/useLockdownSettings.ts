// 잠금 설정 훅 — 잠금 사용 토글(비밀번호 없으면 설정 화면 유도)과 잠금 상태 동기화
import { useFocusEffect } from '@react-navigation/native';
import { useCallback, useState } from 'react';

import { MESSAGE, TOAST_BOTTOM_OFFSET } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';
import useToast from '@/hooks/store/useToast';
import { disableLock, enableLock, getLockPassword, getUseLock } from '@/utils/storage/lock';

function useLockdownSettings() {
  const navigation = useScreenNavigation();

  const [lockEnabled, setLockEnabled] = useState(false);

  const { showToast } = useToast();

  const getLockInfo = useCallback(() => {
    const storedLockState = getUseLock();
    setLockEnabled(storedLockState);
  }, []);

  const handleLockToggle = useCallback(() => {
    if (!lockEnabled) {
      const hasPassword = getLockPassword();
      if (!hasPassword) {
        navigation.navigate('SettingLockPassword');
        showToast(MESSAGE.LOCK.SET_PASSWORD_FIRST, TOAST_BOTTOM_OFFSET.INNER_SCREEN);
      } else {
        enableLock();

        showToast(MESSAGE.LOCK.APP_LOCK_ENABLED, TOAST_BOTTOM_OFFSET.INNER_SCREEN);
        getLockInfo();
      }
    } else {
      disableLock();
      getLockInfo();
    }
  }, [lockEnabled, navigation, showToast, getLockInfo]);

  useFocusEffect(
    useCallback(() => {
      getLockInfo();
    }, [getLockInfo]),
  );

  return { lockEnabled, handleLockToggle };
}

export default useLockdownSettings;
