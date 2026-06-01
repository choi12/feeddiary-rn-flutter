import React from 'react';
import { StyleSheet, View } from 'react-native';

import { LetterDTO } from '@/api/letter/types';
import Text from '@/components/common/Text';
import { COLORS, FONTS } from '@/constants';
import { formatDate } from '@/utils/common/formatDate';
import { removeLineBreaks } from '@/utils/common/removeLineBreaks';

interface LetterModalContentProps {
  selectedLetter: LetterDTO;
}

function LetterModalContent({ selectedLetter }: LetterModalContentProps) {
  return (
    <View style={styles.modalContentBox}>
      <View style={styles.modalTitleBox}>
        <Text style={styles.modalDateText}>{formatDate(selectedLetter.createdAt, 'diary')}</Text>
      </View>
      <Text style={styles.modalContentText}>{removeLineBreaks(selectedLetter.text)}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  modalContentBox: {
    position: 'absolute',
    width: '80%',
    padding: 30,
    paddingRight: 40,
    alignItems: 'center',
  },
  modalTitleBox: {
    marginBottom: 10,
  },
  modalDateText: {
    fontFamily: FONTS.ONGLE,
    fontSize: 14,
    color: COLORS.GRAYSCALE.GRAY,
  },
  modalContentText: {
    flex: 1,
    fontFamily: FONTS.ONGLE,
    fontSize: 18,
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    letterSpacing: -0.2,
  },
});

export default LetterModalContent;
