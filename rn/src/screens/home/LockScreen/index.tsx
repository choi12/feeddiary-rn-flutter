import React from 'react';

import Container from '@/components/common/Container';
import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import DigitKeypad from '@/components/lock/DigitKeypad';
import PasswordBox from '@/components/lock/PasswordBox';
import useTypedRoute from '@/hooks/core/navigation/useTypedRoute';

import useLockScreen from './hooks/useLockScreen';

function LockScreen() {
  const { params } = useTypedRoute<'LockScreen'>();
  const isBackground = params?.isBackground ?? false;

  const { currentPassword, handleSetPassword, handleClearPassword } = useLockScreen({ isBackground });

  return (
    <SafeAreaContainer>
      <Container>
        <PasswordBox password={currentPassword} />
        <DigitKeypad onDigitPress={handleSetPassword} onClear={handleClearPassword} />
      </Container>
    </SafeAreaContainer>
  );
}

export default LockScreen;
