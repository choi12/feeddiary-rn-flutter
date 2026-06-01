import React from 'react';
import { TextInput, StyleSheet, View } from 'react-native';

import Text from '@/components/common/Text';
import { COLORS, FONTS, LAYOUT, NICKNAME_MAX_LENGTH, TEXT } from '@/constants';
import { useProfileContext } from '@/context/profile/ProfileContext';

import NotiBox from './NotiBox';

function NicknameSection() {
  const { nickname, onSetNickname } = useProfileContext();

  return (
    <View>
      <View style={styles.container}>
        <Text style={styles.inputTitleText}>닉네임</Text>
        <TextInput
          value={nickname}
          onChangeText={onSetNickname}
          style={styles.textInput}
          placeholder={TEXT.PLACEHOLDER.NICKNAME}
          maxLength={NICKNAME_MAX_LENGTH}
          placeholderTextColor={COLORS.GRAYSCALE.LIGHT_GRAY}
        />
      </View>
      <NotiBox />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  textInput: {
    borderWidth: 1,
    borderColor: COLORS.CORE.INPUT,
    backgroundColor: COLORS.GRAYSCALE.WHITE,
    borderRadius: LAYOUT.BORDER_RADIUS,
    flex: 1,
    height: LAYOUT.INPUT_HEIGHT,
    paddingHorizontal: 16,
    fontSize: 14,
    fontFamily: FONTS.DOVEMAYO,
    color: COLORS.GRAYSCALE.BLACK,
  },
  inputTitleText: {
    fontSize: 15,
    color: COLORS.GRAYSCALE.BLACK,
    width: 55,
  },
});

export default NicknameSection;
