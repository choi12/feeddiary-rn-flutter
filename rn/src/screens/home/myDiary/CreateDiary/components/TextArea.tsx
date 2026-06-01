import React from 'react';
import { StyleSheet, TextInput, View } from 'react-native';

import Text from '@/components/common/Text';
import { COLORS, LAYOUT, FONTS, TEXT } from '@/constants';

import { DiaryStateUpdater } from '../types';

interface TextAreaProps {
  text: string;
  onSetDiaryState: DiaryStateUpdater;
}

function TextArea({ text, onSetDiaryState }: TextAreaProps) {
  return (
    <View style={styles.textInputBox}>
      <TextInput
        style={styles.textInput}
        value={text}
        onChangeText={(value) => onSetDiaryState({ text: value })}
        multiline
        placeholder={TEXT.PLACEHOLDER.DIARY}
        placeholderTextColor={COLORS.GRAYSCALE.LIGHT_GRAY}
      />
      <Text style={styles.countText}>{text.length} 글자 작성했어요.</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  textInputBox: {
    height: 300,
    borderWidth: 1,
    borderColor: COLORS.CORE.INPUT,
    borderRadius: LAYOUT.BORDER_RADIUS,
    paddingHorizontal: 15,
    paddingVertical: 5,
    marginHorizontal: LAYOUT.PADDING,
  },
  textInput: {
    flex: 1,
    lineHeight: 22,
    fontSize: 14,
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    fontFamily: FONTS.DOVEMAYO,
    textAlignVertical: 'top',
  },
  countText: {
    fontSize: 12,
    color: COLORS.GRAYSCALE.LIGHT_GRAY,
    marginBottom: 5,
    alignSelf: 'flex-end',
  },
});

export default TextArea;
