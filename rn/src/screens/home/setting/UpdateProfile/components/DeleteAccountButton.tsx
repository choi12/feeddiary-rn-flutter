import React from 'react';
import { StyleSheet, TouchableOpacity } from 'react-native';

import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import useDeleteAccount from '@/hooks/features/auth/useDeleteAccount';

function DeleteAccountButton() {
  const { openDeleteAccountModal } = useDeleteAccount();

  return (
    <TouchableOpacity onPress={openDeleteAccountModal} style={styles.button}>
      <Text style={styles.buttonText}>탈퇴하기</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  button: {
    paddingVertical: 15,
  },
  buttonText: {
    fontSize: 14,
    color: COLORS.ACCENT.ORANGE,
    textDecorationLine: 'underline',
  },
});

export default DeleteAccountButton;
