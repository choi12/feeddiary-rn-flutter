import React, { PropsWithChildren } from 'react';
import { StyleSheet, View } from 'react-native';

function ContentBox({ children }: PropsWithChildren) {
  return <View style={styles.contentBox}>{children}</View>;
}

const styles = StyleSheet.create({
  contentBox: { flex: 1 },
});

export default ContentBox;
