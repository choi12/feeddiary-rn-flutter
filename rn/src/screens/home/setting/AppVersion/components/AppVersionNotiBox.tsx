import React from 'react';
import { StyleSheet, View } from 'react-native';

import Text from '@/components/common/Text';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS, TEXT } from '@/constants';

interface AppVersionNotiBoxProps {
  latestVersion: string;
  isLatest: boolean;
}

function AppVersionNotiBox({ latestVersion, isLatest }: AppVersionNotiBoxProps) {
  return (
    <View style={styles.notiBox}>
      {latestVersion && (
        <>
          <VectorIcon
            type="Feather"
            name="alert-circle"
            size={13}
            color={isLatest ? COLORS.CORE.MAIN : COLORS.ACCENT.ORANGE}
          />
          <Text style={[styles.notiText, !isLatest && { color: COLORS.ACCENT.ORANGE }]}>
            {isLatest ? TEXT.UPDATE.LATEST_VERSION : TEXT.UPDATE.required(latestVersion)}
          </Text>
        </>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  notiBox: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 5,
    marginBottom: 20,
    height: 20,
  },
  notiText: {
    fontSize: 14,
    color: COLORS.CORE.MAIN,
  },
});

export default AppVersionNotiBox;
