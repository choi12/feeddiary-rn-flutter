import React from 'react';
import { StyleSheet, View } from 'react-native';

import { LetterDTO } from '@/api/letter/types';
import Text from '@/components/common/Text';
import { COLORS, FONTS } from '@/constants';
import { formatDate } from '@/utils/common/formatDate';

interface LetterCardContentProps {
  letter: LetterDTO;
}

function LetterCardContent({ letter }: LetterCardContentProps) {
  return (
    <View style={styles.letterTextBox}>
      <View style={styles.dateTextBox}>
        <Text style={styles.dateText}>{formatDate(letter.createdAt, 'diary')}</Text>
        <Text style={styles.ofText}>의</Text>
      </View>
      <Text style={styles.toText}>나에게</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  letterTextBox: {
    width: '80%',
    position: 'absolute',
    alignItems: 'center',
    justifyContent: 'center',
    paddingRight: 5,
  },
  dateTextBox: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  dateText: {
    fontFamily: FONTS.ONGLE,
    fontSize: 14,
    color: COLORS.GRAYSCALE.GRAY,
  },
  ofText: {
    fontFamily: FONTS.ONGLE,
    fontSize: 13,
    color: COLORS.GRAYSCALE.DARK_GRAY,
    marginLeft: 1,
  },
  toText: {
    fontFamily: FONTS.ONGLE,
    fontSize: 15,
    color: COLORS.GRAYSCALE.DARK_GRAY,
  },
});

export default LetterCardContent;
