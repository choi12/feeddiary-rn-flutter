import React, { PropsWithChildren } from 'react';
import { StyleSheet, View, ViewProps } from 'react-native';

import { LAYOUT, COLORS } from '@/constants';

interface ContainerProps extends ViewProps {
  isMain?: boolean;
  hasPadding?: boolean;
  backgroundColor?: string;
}

function Container({
  children,
  isMain = false,
  hasPadding = false,
  backgroundColor = COLORS.GRAYSCALE.WHITE,
  ...props
}: PropsWithChildren<ContainerProps>) {
  return (
    <View
      {...props}
      style={[
        styles.container,
        { backgroundColor },
        isMain && { paddingBottom: LAYOUT.BOTTOM_TAB_HEIGHT },
        hasPadding && { padding: LAYOUT.PADDING },
        props.style,
      ]}
    >
      {children}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

export default Container;
