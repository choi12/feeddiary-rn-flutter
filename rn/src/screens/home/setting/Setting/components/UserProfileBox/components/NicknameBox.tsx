import React from 'react';
import { StyleSheet } from 'react-native';

import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import useUserInfo from '@/hooks/store/useUserInfo';

function NicknameBox() {
  const nickname = useUserInfo('nickname');

  return (
    <Text style={styles.nicknameText}>
      {(nickname || '') + ' '}
      <Text style={styles.myProfileText}> 내 정보 수정</Text>
    </Text>
  );
}

const styles = StyleSheet.create({
  nicknameText: {
    color: COLORS.GRAYSCALE.BLACK,
    fontSize: 17,
    marginBottom: 7,
  },
  myProfileText: {
    color: COLORS.CORE.MAIN,
    fontSize: 12,
    letterSpacing: -0.5,
  },
});

export default NicknameBox;
