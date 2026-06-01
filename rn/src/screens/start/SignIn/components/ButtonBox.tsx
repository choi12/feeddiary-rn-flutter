import React from 'react';
import { StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import { Field } from '@/assets/images';
import { isAndroid } from '@/constants';
import { SignInType } from '@/types/auth';

import SignInButton from './SignInButton';

const BUTTON_ORDER: SignInType[] = isAndroid ? ['google', 'apple'] : ['apple', 'google'];

function ButtonBox() {
  return (
    <View style={styles.bottomBox}>
      <FastImage source={Field} style={styles.fieldImage} contentFit="fill" />
      <View style={styles.buttonWrapper}>
        {BUTTON_ORDER.map((signInType) => (
          <SignInButton key={signInType} type={signInType} />
        ))}
      </View>
    </View>
  );
}
const styles = StyleSheet.create({
  bottomBox: { flex: 1, position: 'relative', alignItems: 'center' },
  fieldImage: { position: 'absolute', bottom: 0, height: '100%', width: '100%', overflow: 'visible' },
  buttonWrapper: { flex: 1, paddingHorizontal: 20, justifyContent: 'center', width: '100%', gap: 10 },
});

export default ButtonBox;
