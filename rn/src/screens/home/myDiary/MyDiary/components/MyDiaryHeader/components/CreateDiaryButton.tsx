import React from 'react';
import { StyleSheet, View } from 'react-native';

import AnimatedPressable from '@/components/common/AnimatedPressable';
import Text from '@/components/common/Text';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';

function CreateDiaryButton() {
  const navigation = useScreenNavigation();

  return (
    <AnimatedPressable
      onPress={() => navigation.navigate('CreateDiary', { diary: undefined })}
      pressedScale={0.98}
      pressedOpacity={0.99}
      accessibilityRole="button"
      accessibilityLabel="일기 쓰러 가기"
    >
      <View style={[styles.createDiaryButton]}>
        <Text style={styles.createDiaryButtonText}>일기 쓰러 가기</Text>
        <VectorIcon type="Ionicons" name="caret-down-outline" size={20} color={COLORS.CORE.MAIN} style={styles.icon} />
      </View>
    </AnimatedPressable>
  );
}

const styles = StyleSheet.create({
  createDiaryButton: {
    width: 120,
    height: 43,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 2,
    backgroundColor: COLORS.GRAYSCALE.WHITE,
    borderRadius: 25,
  },
  createDiaryButtonText: {
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    fontSize: 13,
    marginLeft: 3,
    letterSpacing: -0.5,
  },
  icon: { transform: [{ rotate: '-90deg' }] },
});

export default CreateDiaryButton;
