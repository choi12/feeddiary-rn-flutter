import React from 'react';
import { StyleSheet } from 'react-native';

import Text from '@/components/common/Text';
import { COLORS } from '@/constants';

const MISSION_RESET_TIME = '오전 5시';

function MissionListHeaderText() {
  return (
    <Text style={styles.infoText}>
      * 매일 <Text style={styles.underlinedText}>{MISSION_RESET_TIME}</Text>에 미션이 초기화돼요.
    </Text>
  );
}

const styles = StyleSheet.create({
  bottomBox: {
    marginTop: 20,
    gap: 10,
  },
  infoText: {
    color: COLORS.GRAYSCALE.GRAY,
    fontSize: 13,
    marginBottom: 3,
  },
  underlinedText: {
    textDecorationLine: 'underline',
    color: COLORS.ACCENT.YELLOW,
  },
});

export default MissionListHeaderText;
