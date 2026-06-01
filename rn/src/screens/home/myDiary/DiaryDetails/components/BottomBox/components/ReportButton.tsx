import React from 'react';
import { Pressable, StyleSheet } from 'react-native';

import Text from '@/components/common/Text';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';

interface ReportButtonProps {
  diaryIdx: number;
}

function ReportButton({ diaryIdx }: ReportButtonProps) {
  const navigation = useScreenNavigation();

  return (
    <Pressable
      onPress={() => navigation.navigate('Report', { diaryIdx })}
      style={styles.reportButton}
      accessibilityRole="button"
    >
      <VectorIcon type="MaterialIcons" name="block" color={COLORS.ACCENT.RED} size={14} />
      <Text style={styles.reportText}>신고/차단</Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  reportButton: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 5,
  },
  reportText: {
    color: COLORS.ACCENT.RED,
    fontSize: 13,
    marginLeft: 2,
  },
});

export default ReportButton;
