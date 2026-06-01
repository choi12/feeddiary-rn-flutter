import React from 'react';
import { StyleSheet, View } from 'react-native';

import { COLORS, MESSAGE, TEXT } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';

import AnimatedPressable from '../AnimatedPressable';
import Text from '../Text';
import VectorIcon from '../VectorIcon';

interface ErrorViewProps {
  reload?: () => void;
}

function ErrorView({ reload }: ErrorViewProps) {
  const navigation = useScreenNavigation();

  const handleRetry = async () => {
    if (reload) {
      reload();
    } else {
      navigation.goBack();
    }
  };

  return (
    <View style={[StyleSheet.absoluteFill, styles.container]}>
      <View style={styles.textBox}>
        <VectorIcon type="Feather" name="alert-circle" size={14} color={COLORS.ACCENT.ORANGE} />
        <Text style={styles.text}>{MESSAGE.SYSTEM.TRY_AGAIN}</Text>
      </View>
      <AnimatedPressable onPress={handleRetry} style={styles.button}>
        <Text style={styles.buttonText}>{reload ? TEXT.ERROR.RETRY : TEXT.ERROR.GO_BACK}</Text>
      </AnimatedPressable>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    justifyContent: 'center',
    alignItems: 'center',
    gap: 20,
    zIndex: -1,
  },
  textBox: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    gap: 4,
  },
  text: {
    color: COLORS.ACCENT.ORANGE,
    fontSize: 14,
    letterSpacing: -0.5,
  },
  button: {
    backgroundColor: COLORS.ACCENT.ORANGE,
    width: 80,
    height: 40,
    borderRadius: 7,
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonText: {
    color: COLORS.GRAYSCALE.WHITE,
    fontSize: 13,
  },
});

export default ErrorView;
