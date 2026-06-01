import React from 'react';
import { StyleSheet, Text as BaseText, TextProps } from 'react-native';

import { FONTS } from '@/constants';

function Text(props: TextProps) {
  return <BaseText {...props} style={[styles.text, props.style]} />;
}

const styles = StyleSheet.create({
  text: { fontFamily: FONTS.DOVEMAYO },
});

export default Text;
