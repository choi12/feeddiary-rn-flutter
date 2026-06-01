import React, { PropsWithChildren } from 'react';
import { StyleSheet } from 'react-native';
import { SafeAreaView, SafeAreaViewProps } from 'react-native-safe-area-context';

import { COLORS } from '@/constants';

interface ContainerProps extends SafeAreaViewProps {
  backgroundColor?: string;
}

function SafeAreaContainer({
  children,
  backgroundColor = COLORS.GRAYSCALE.WHITE,
  ...props
}: PropsWithChildren<ContainerProps>) {
  return (
    <SafeAreaView {...props} style={[styles.container, { backgroundColor }]}>
      {children}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

export default SafeAreaContainer;
