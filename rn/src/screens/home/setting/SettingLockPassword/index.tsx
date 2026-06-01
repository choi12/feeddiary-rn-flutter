import React from 'react';

import Container from '@/components/common/Container';
import CustomHeader from '@/components/common/CustomHeader';
import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import DigitKeypad from '@/components/lock/DigitKeypad';
import PasswordBox from '@/components/lock/PasswordBox';
import { COLORS } from '@/constants';

import useSettingLockPassword from './hooks/useSettingLockPassword';

function SettingLockPassword() {
  const { step, password, confirmedPassword, handleSetPassword, handleClearPassword } = useSettingLockPassword();

  return (
    <SafeAreaContainer backgroundColor={COLORS.CORE.BACKGROUND}>
      <CustomHeader title="잠금 비밀번호 설정" hasCloseButton />
      <Container backgroundColor={COLORS.CORE.BACKGROUND}>
        <PasswordBox step={step} password={password} confirmedPassword={confirmedPassword} />
        <DigitKeypad onDigitPress={handleSetPassword} onClear={handleClearPassword} />
      </Container>
    </SafeAreaContainer>
  );
}

export default SettingLockPassword;
