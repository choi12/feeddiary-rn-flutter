import React from 'react';
import { StyleSheet, View } from 'react-native';

import AnimatedPressable from '@/components/common/AnimatedPressable';
import Text from '@/components/common/Text';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS, FONTS } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';

import useLetters from '../hooks/useLetters';

function CreateLetterButton() {
  const navigation = useScreenNavigation();
  const { isTodayLetterWritten } = useLetters();

  return (
    <AnimatedPressable
      onPress={() => navigation.navigate('CreateLetter')}
      disabled={isTodayLetterWritten}
      accessibilityRole="button"
      accessibilityLabel={isTodayLetterWritten ? '오늘의 편지 작성 완료' : '오늘의 나에게 편지 쓰기'}
      accessibilityState={{ disabled: isTodayLetterWritten }}
    >
      <View
        style={[styles.createDiaryButton, isTodayLetterWritten && { backgroundColor: COLORS.GRAYSCALE.LIGHT_GRAY }]}
      >
        <Text style={styles.createDiaryButtonText}>
          {!isTodayLetterWritten ? '오늘의 나에게 편지 쓰기' : '오늘의 편지 작성 완료!'}
        </Text>
        {!isTodayLetterWritten && (
          <VectorIcon
            type="Ionicons"
            name="caret-down-outline"
            size={20}
            color={COLORS.GRAYSCALE.WHITE}
            style={styles.icon}
          />
        )}
      </View>
    </AnimatedPressable>
  );
}

const styles = StyleSheet.create({
  createDiaryButton: {
    height: 50,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: COLORS.ACCENT.SKYBLUE,
    borderRadius: 25,
  },
  createDiaryButtonText: {
    fontFamily: FONTS.ONGLE,
    color: COLORS.GRAYSCALE.WHITE,
    fontSize: 18,
    letterSpacing: -0.2,
  },
  icon: { transform: [{ rotate: '-90deg' }], marginLeft: 3 },
});

export default CreateLetterButton;
