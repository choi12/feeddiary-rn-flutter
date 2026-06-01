import { useCallback, useEffect, useState } from 'react';

import { MESSAGE, PASSWORD_LENGTH, TOAST_BOTTOM_OFFSET } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';
import useToast from '@/hooks/store/useToast';
import { SettingPasswordStep } from '@/types/auth';
import { enableLock, setLockPassword } from '@/utils/storage/lock';

function useSettingLockPassword() {
  const navigation = useScreenNavigation();

  const [password, setPassword] = useState('');
  const [confirmedPassword, setConfirmedPassword] = useState('');
  const [step, setStep] = useState<SettingPasswordStep>(1);

  const { showToast } = useToast();

  const savePassword = useCallback(() => {
    enableLock();
    setLockPassword(confirmedPassword);

    navigation.goBack();
    showToast(MESSAGE.LOCK.PASSWORD_SET, TOAST_BOTTOM_OFFSET.INNER_SCREEN);
  }, [confirmedPassword, showToast, navigation]);

  const handleSetPassword = useCallback(
    (number: string) => {
      if (step === 1) {
        setPassword((prev) => (prev.length < PASSWORD_LENGTH ? prev + number : prev));
      }
      if (step === 2) {
        setConfirmedPassword((prev) => (prev.length < PASSWORD_LENGTH ? prev + number : prev));
      }
    },
    [step],
  );

  const handleClearPassword = useCallback(() => {
    if (step === 1) {
      setPassword((prev) => prev.slice(0, -1));
    }
    if (step === 2) {
      setConfirmedPassword((prev) => prev.slice(0, -1));
    }
  }, [step]);

  useEffect(() => {
    if (password.length === PASSWORD_LENGTH) {
      setStep(2);
    }
  }, [password]);

  useEffect(() => {
    const verifyPassword = () => {
      if (confirmedPassword.length !== PASSWORD_LENGTH) return;

      if (password !== confirmedPassword) {
        showToast(MESSAGE.LOCK.PASSWORD_MISMATCH, TOAST_BOTTOM_OFFSET.INNER_SCREEN);
        setConfirmedPassword('');
        return;
      }
      savePassword();
    };

    verifyPassword();
  }, [confirmedPassword, password, savePassword, showToast]);

  return {
    step,
    password,
    confirmedPassword,
    handleSetPassword,
    handleClearPassword,
  };
}

export default useSettingLockPassword;
