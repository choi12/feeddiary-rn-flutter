import React from 'react';
import { Pressable, PressableProps, StyleProp, StyleSheet, ViewStyle } from 'react-native';

import { COLORS, LAYOUT } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';

import VectorIcon from '../../VectorIcon';

function CloseButton(props: PressableProps) {
  const navigation = useScreenNavigation();

  return (
    <Pressable onPress={navigation.goBack} {...props} style={[styles.button, props.style] as StyleProp<ViewStyle>}>
      <VectorIcon type="Ionicons" name="close" size={28} color={COLORS.GRAYSCALE.BLACK} />
    </Pressable>
  );
}

const styles = StyleSheet.create({
  button: {
    alignItems: 'center',
    justifyContent: 'center',
    padding: 13,
    paddingRight: LAYOUT.PADDING,
  },
});

export default CloseButton;
