import React from 'react';
import { StyleSheet, View } from 'react-native';

import { COLORS, LAYOUT } from '@/constants';
import useAlertModal from '@/hooks/store/useAlertModal';
import { useStore } from '@/store';

import BaseModal from '../BaseModal';

import AlertModalButtonBox from './components/AlertModalButtonBox';
import AlertModalContentBox from './components/AlertModalContentBox';

function AlertModal() {
  const { isVisible, content } = useStore((state) => state.alert);
  const { closeAlertModal: closeModal } = useAlertModal();

  return (
    <BaseModal isVisible={isVisible} onClose={content?.onPressBackground ?? closeModal} onRequestClose={closeModal}>
      <View style={styles.modalBox}>
        <AlertModalContentBox />
        <AlertModalButtonBox />
      </View>
    </BaseModal>
  );
}

const styles = StyleSheet.create({
  modalBox: {
    width: 300,
    backgroundColor: COLORS.GRAYSCALE.WHITE,
    borderRadius: LAYOUT.BORDER_RADIUS,
  },
});

export default AlertModal;
