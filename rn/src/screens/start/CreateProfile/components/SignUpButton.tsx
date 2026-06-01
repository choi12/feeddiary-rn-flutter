import React from 'react';
import { StyleSheet, View } from 'react-native';

import CustomButton from '@/components/common/CustomButton';
import { COLORS } from '@/constants';
import { SignInParams } from '@/types/auth';

import useSignUp from '../hooks/useSignUp';

function SignUpButton({ type, email, uid }: SignInParams) {
  const { handleSignUp, isPending, isSignUpDisabled } = useSignUp({ type, email, uid });

  return (
    <View style={styles.buttonWrapper}>
      <CustomButton
        onPress={handleSignUp}
        disabled={isSignUpDisabled}
        title="새싹일기 시작하기"
        isAnimated
        isLoading={isPending}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  buttonWrapper: {
    backgroundColor: COLORS.GRAYSCALE.WHITE,
  },
});

export default SignUpButton;
