import React from 'react';
import { Pressable, StyleSheet, Switch } from 'react-native';

import Container from '@/components/common/Container';
import CustomHeader from '@/components/common/CustomHeader';
import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import Text from '@/components/common/Text';
import { COLORS, isAndroid, LAYOUT } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';

import useLockdownSettings from './hooks/useLockdownSettings';

function LockdownSettings() {
  const navigation = useScreenNavigation();

  const { handleLockToggle, lockEnabled } = useLockdownSettings();

  return (
    <SafeAreaContainer>
      <CustomHeader title="잠금 설정" hasBackButton />
      <Container>
        <Pressable onPress={handleLockToggle} style={styles.box}>
          <Text style={styles.text}>비밀번호 잠금 사용</Text>
          <Switch
            onValueChange={handleLockToggle}
            value={lockEnabled}
            trackColor={{ true: COLORS.CORE.MAIN }}
            thumbColor={COLORS.GRAYSCALE.WHITE}
            style={styles.switch}
          />
        </Pressable>
        <Pressable
          onPress={() => navigation.navigate('SettingLockPassword')}
          disabled={!lockEnabled}
          style={styles.box}
        >
          <Text style={[styles.text, !lockEnabled && styles.disabledText]}>비밀번호 재설정</Text>
        </Pressable>
      </Container>
    </SafeAreaContainer>
  );
}

const styles = StyleSheet.create({
  box: {
    width: '100%',
    height: 70,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: LAYOUT.PADDING,
    borderBottomWidth: 1,
    borderColor: COLORS.GRAYSCALE.WHITE_GRAY,
  },
  text: {
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    fontSize: 15,
  },
  disabledText: {
    color: COLORS.GRAYSCALE.LIGHT_GRAY,
  },
  switch: {
    transform: [{ scale: isAndroid ? 1 : 0.8 }],
  },
});

export default LockdownSettings;
