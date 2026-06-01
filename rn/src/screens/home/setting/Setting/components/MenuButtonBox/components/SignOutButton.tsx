import React from 'react';
import { StyleSheet, TouchableOpacity } from 'react-native';

import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import useSignOut from '@/hooks/features/auth/useSignOut';

function SignOutButton() {
  const { openSignOutModal } = useSignOut();

  return (
    <TouchableOpacity onPress={openSignOutModal} style={styles.signoutButton}>
      <Text style={styles.signoutButtonText}>로그아웃</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  signoutButton: {
    alignSelf: 'center',
    paddingVertical: 10,
    paddingHorizontal: 15,
    marginTop: 20,
  },
  signoutButtonText: {
    color: COLORS.ACCENT.ORANGE,
    fontSize: 14,
    textDecorationLine: 'underline',
  },
});

export default SignOutButton;
