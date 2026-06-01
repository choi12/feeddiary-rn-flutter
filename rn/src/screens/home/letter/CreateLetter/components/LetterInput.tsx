import { useFocusEffect } from '@react-navigation/native';
import React, { useCallback, useRef } from 'react';
import { StyleSheet, TextInput, View } from 'react-native';

import Text from '@/components/common/Text';
import { COLORS, FONTS, LAYOUT, LETTER_MAX_LENGTH, TEXT } from '@/constants';

interface LetterInputProps {
  text: string;
  onSetText: (text: string) => void;
}

function LetterInput({ text, onSetText }: LetterInputProps) {
  const inputRef = useRef<TextInput>(null);

  useFocusEffect(
    useCallback(() => {
      const timer = setTimeout(() => {
        inputRef.current?.focus();
      }, 100);

      return () => clearTimeout(timer);
    }, []),
  );

  return (
    <View style={styles.textInputBox}>
      <TextInput
        ref={inputRef}
        onChangeText={onSetText}
        style={styles.textInput}
        multiline
        placeholder={TEXT.PLACEHOLDER.LETTER}
        placeholderTextColor={COLORS.GRAYSCALE.LIGHT_GRAY}
        maxLength={LETTER_MAX_LENGTH}
      />
      <Text style={styles.countText}>
        {text.length} / 최대 {LETTER_MAX_LENGTH}자
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  textInputBox: {
    width: '100%',
    height: 120,
    borderWidth: 1,
    borderColor: COLORS.GRAYSCALE.WHITE_GRAY,
    borderRadius: LAYOUT.BORDER_RADIUS,
    paddingHorizontal: 15,
    paddingVertical: 5,
    marginTop: -LAYOUT.PADDING,
    marginBottom: 15,
    backgroundColor: COLORS.TRANSPARENT.WHITE_90,
  },
  textInput: {
    flex: 1,
    fontFamily: FONTS.ONGLE,
    lineHeight: 22,
    fontSize: 17,
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    textAlignVertical: 'top',
  },
  countText: {
    fontFamily: FONTS.ONGLE,
    fontSize: 13,
    color: COLORS.GRAYSCALE.GRAY,
    marginBottom: 5,
    alignSelf: 'flex-end',
  },
});

export default LetterInput;
