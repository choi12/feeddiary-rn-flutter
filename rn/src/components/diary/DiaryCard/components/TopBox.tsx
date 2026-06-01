import React, { PropsWithChildren } from 'react';
import { StyleSheet, View } from 'react-native';

function TopBox({ children }: PropsWithChildren) {
  return <View style={styles.topBox}>{children}</View>;
}

const styles = StyleSheet.create({
  topBox: { gap: 10 },
});

export default TopBox;
