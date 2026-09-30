import React from 'react';
import { StyleSheet } from 'react-native';

import AnimatedPressable from '@/components/common/AnimatedPressable';
import Text from '@/components/common/Text';
import { COLORS, LAYOUT } from '@/constants';

interface EditButtonProps {
  isEditMode: boolean;
  onToggleEditMode: () => void;
}

function EditButton({ isEditMode, onToggleEditMode }: EditButtonProps) {
  return (
    <AnimatedPressable onPress={onToggleEditMode} pressedOpacity={0.8} pressedScale={0.97} style={styles.button}>
      <Text style={[styles.buttonText, isEditMode && { color: COLORS.ACCENT.ORANGE }]}>
        {!isEditMode ? '편집' : '편집 취소'}
      </Text>
    </AnimatedPressable>
  );
}

const styles = StyleSheet.create({
  // 헤더의 오른쪽 칸(rightBox)이 세로 가운데를 맞추도록 일반 배치로 두고, 오른쪽 여백만큼 밖으로 밀어 탭 영역을 넓힌다
  button: {
    marginRight: -LAYOUT.PADDING,
    padding: LAYOUT.PADDING,
  },
  buttonText: {
    fontSize: 13,
    color: COLORS.CORE.MAIN,
    textDecorationLine: 'underline',
  },
});

export default EditButton;
