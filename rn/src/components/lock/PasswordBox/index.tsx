import React from 'react';
import { StyleSheet, View } from 'react-native';

import Text from '@/components/common/Text';
import { COLORS, PASSWORD_LENGTH, TEXT } from '@/constants';
import { SettingPasswordStep } from '@/types/auth';

import PasswordDot from './components/PasswordDot';

interface PasswordBoxProps {
  step?: SettingPasswordStep;
  password: string;
  confirmedPassword?: string;
}

const PASSWORD_DOTS_ARRAY = Array.from({ length: PASSWORD_LENGTH });

function PasswordBox({ step = 1, password, confirmedPassword }: PasswordBoxProps) {
  const isPasswordCharVisible = (index: number) => {
    const targetPassword = step === 1 ? password : confirmedPassword;

    return (targetPassword?.length ?? 0) > index;
  };

  return (
    <View style={styles.topBox}>
      <Text style={styles.titleText}>{step === 1 ? TEXT.LOCK.PASSWORD_ENTER : TEXT.LOCK.PASSWORD_CONFIRM}</Text>
      <View style={styles.passwordImageBox}>
        <View style={styles.passwordBox}>
          {PASSWORD_DOTS_ARRAY.map((_, index) => (
            <PasswordDot key={index} isGrayscale />
          ))}
        </View>
        <View style={styles.passwordImageBox}>
          {PASSWORD_DOTS_ARRAY.map((_, index) => (
            <PasswordDot key={index} opacity={isPasswordCharVisible(index) ? 1 : 0} />
          ))}
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  topBox: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  titleText: {
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    fontSize: 15,
    marginBottom: 30,
  },
  passwordImageBox: { flexDirection: 'row', alignItems: 'center', gap: 10 },
  passwordBox: { flexDirection: 'row', alignItems: 'center', gap: 10, position: 'absolute' },
});

export default PasswordBox;
