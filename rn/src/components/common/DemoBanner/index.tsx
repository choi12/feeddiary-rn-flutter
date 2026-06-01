import React, { PropsWithChildren } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import Config from 'react-native-config';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { COLORS, FONTS } from '@/constants';

const EXTRA_HEIGHT = 20;

function DemoBanner({ children }: PropsWithChildren) {
  const insets = useSafeAreaInsets();

  if (Config.USE_MOCK !== 'true') return <>{children}</>;

  return (
    <View style={[styles.root, { paddingTop: EXTRA_HEIGHT }]}>
      {children}
      <View
        pointerEvents="none"
        accessibilityRole="alert"
        accessibilityLabel={`Demo 모드, ${Config.APP_ENV}`}
        style={[styles.banner, { height: insets.top + EXTRA_HEIGHT, paddingTop: insets.top }]}
      >
        <Text style={styles.text}>DEMO · {Config.APP_ENV === 'PRODUCTION' ? 'PROD' : 'DEV'} · Mock 데이터로 시연 중</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  root: {
    flex: 1,
  },
  banner: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    backgroundColor: COLORS.ACCENT.RED,
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 9999,
    elevation: 9999,
  },
  text: {
    color: COLORS.GRAYSCALE.WHITE,
    fontFamily: FONTS.DOVEMAYO,
    fontSize: 12,
    letterSpacing: 0.2,
  },
});

export default DemoBanner;
