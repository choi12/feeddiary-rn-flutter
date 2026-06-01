import React from 'react';
import { StyleSheet, View } from 'react-native';

import Text from '@/components/common/Text';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS } from '@/constants';

function InfoTextBox() {
  return (
    <View style={styles.infoTextBox}>
      <VectorIcon type="Feather" name="alert-circle" size={13} color={COLORS.ACCENT.SKYBLUE} />
      <Text style={styles.infoText}>편지는 하루에 최대 한 개만 보낼 수 있어요.</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  infoTextBox: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  infoText: {
    color: COLORS.ACCENT.SKYBLUE,
    fontSize: 13,
    marginLeft: 3,
  },
});

export default InfoTextBox;
