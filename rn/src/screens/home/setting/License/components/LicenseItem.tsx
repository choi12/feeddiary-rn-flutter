import React from 'react';
import { StyleSheet, View } from 'react-native';

import Text from '@/components/common/Text';
import { COLORS } from '@/constants';

type LicenseItem = {
  libraryName: string;
  _license: string;
  _description: string;
};

interface LicenseBoxProps {
  licenseInfo: LicenseItem;
}

function LicenseBox({ licenseInfo }: LicenseBoxProps) {
  return (
    <View style={styles.listBox}>
      <Text style={styles.libraryName}>{licenseInfo.libraryName}</Text>
      <Text style={styles.license}>{licenseInfo._license}</Text>
      <Text style={styles.description}>{licenseInfo._description}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  listBox: {
    padding: 10,
    marginBottom: 20,
    gap: 5,
  },
  libraryName: {
    fontSize: 13,
    color: COLORS.GRAYSCALE.BLACK,
  },
  license: {
    fontSize: 13,
    color: COLORS.CORE.MAIN,
  },
  description: {
    fontSize: 11,
    color: COLORS.GRAYSCALE.DARK_GRAY,
  },
});

export default LicenseBox;
