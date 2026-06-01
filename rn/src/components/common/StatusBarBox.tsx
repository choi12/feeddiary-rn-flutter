import React from 'react';
import { StyleSheet, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

interface StatusBarBoxProps {
  backgroundColor: string;
}

function StatusBarBox({ backgroundColor }: StatusBarBoxProps) {
  const { top: safeAreaTopInset } = useSafeAreaInsets();

  return <View style={[styles.container, { height: safeAreaTopInset, backgroundColor }]} />;
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
  },
});

export default StatusBarBox;
