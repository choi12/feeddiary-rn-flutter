import React from 'react';
import { StyleSheet } from 'react-native';

import AnimatedPressable from '@/components/common/AnimatedPressable';
import { LAYOUT } from '@/constants';
import { SignInType } from '@/types/auth';

import useSignIn from '../../hooks/useSignIn';

import ButtonContent from './components/ButtonContent';
import { SIGN_IN_COLOR } from './data';

interface SignInButtonProps {
  type: SignInType;
}

function SignInButton({ type }: SignInButtonProps) {
  const { handleSignIn } = useSignIn();

  return (
    <AnimatedPressable
      onPress={() => handleSignIn(type)}
      style={[styles.button, { backgroundColor: SIGN_IN_COLOR[type].background }]}
      pressedOpacity={0.99}
    >
      <ButtonContent type={type} />
    </AnimatedPressable>
  );
}

const styles = StyleSheet.create({
  button: {
    width: '100%',
    height: LAYOUT.BUTTON_HEIGHT,
    borderRadius: LAYOUT.BORDER_RADIUS,
    alignItems: 'center',
    justifyContent: 'center',
    flexDirection: 'row',
  },
});

export default SignInButton;
