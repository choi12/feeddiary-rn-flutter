import React, { ReactNode } from 'react';
import { StyleSheet, View, ViewProps, Text as RNText } from 'react-native';

import { COLORS, LAYOUT } from '@/constants';

import BackButton from './components/BackButton';
import CloseButton from './components/CloseButton';
import { FONT_STYLES, FontType } from './styles';

interface CustomHeaderProps extends ViewProps {
  title: string | ReactNode;
  rightItem?: ReactNode;
  font?: FontType;
  backgroundColor?: string;
  hasBackButton?: boolean;
  hasCloseButton?: boolean;
}

function CustomHeader({
  title,
  rightItem,
  font = 'DOVEMAYO',
  backgroundColor = COLORS.TRANSPARENT.TRANSPARENT,
  hasBackButton = false,
  hasCloseButton = false,
  ...props
}: CustomHeaderProps) {
  return (
    <View
      {...props}
      style={[styles.container, { backgroundColor }, hasCloseButton && { borderBottomWidth: 0 }, props.style]}
    >
      {hasBackButton && (
        <View style={styles.leftBox}>
          <BackButton />
        </View>
      )}
      {typeof title === 'string' ? <RNText style={FONT_STYLES[font]}>{title}</RNText> : title}
      <View style={styles.rightBox}>
        {hasCloseButton && <CloseButton style={styles.closeButton} />}
        {rightItem && rightItem}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
    height: LAYOUT.HEADER_HEIGHT,
    backgroundColor: COLORS.GRAYSCALE.WHITE,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    borderBottomWidth: 1,
    borderColor: COLORS.GRAYSCALE.WHITE_GRAY,
  },
  leftBox: {
    position: 'absolute',
    left: 0,
  },
  rightBox: {
    alignItems: 'center',
    justifyContent: 'center',
    position: 'absolute',
    right: LAYOUT.PADDING,
    height: '100%',
  },
  closeButton: {
    position: 'absolute',
    right: -LAYOUT.PADDING,
  },
});

export default CustomHeader;
