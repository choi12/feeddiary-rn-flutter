import React from 'react';
import { StyleSheet } from 'react-native';
import Animated from 'react-native-reanimated';

import VisibilityController from '@/components/controller/VisibilityController';
import { COLORS } from '@/constants';
import useToastBox from '@/hooks/ui/feedback/useToastBox';

import Text from './Text';
import VectorIcon from './VectorIcon';

function ToastBox() {
  const { isVisible, toastPosition, message } = useToastBox();

  return (
    <VisibilityController isVisible={isVisible}>
      <Animated.View style={[styles.container, { bottom: toastPosition }]}>
        <VectorIcon type="Feather" name="alert-circle" size={15} color={COLORS.CORE.MAIN} />
        <Text style={styles.text}>{message}</Text>
      </Animated.View>
    </VisibilityController>
  );
}

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    bottom: -100,
    alignSelf: 'center',
    width: '90%',
    backgroundColor: COLORS.GRAYSCALE.PALE_GRAY,
    borderRadius: 10,
    padding: 15,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 5,
  },
  text: {
    flex: 1,
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    fontSize: 13,
  },
});

export default ToastBox;
