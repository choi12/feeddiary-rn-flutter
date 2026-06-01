import React from 'react';
import { GestureResponderEvent, Modal, Pressable, StyleSheet } from 'react-native';

import { COLORS, LAYOUT } from '@/constants';
import useAlertModal from '@/hooks/store/useAlertModal';
import { useStore } from '@/store';

import AlertModalButtonBox from './components/AlertModalButtonBox';
import AlertModalContentBox from './components/AlertModalContentBox';

function AlertModal() {
  const { isVisible, content } = useStore((state) => state.alert);
  const { closeAlertModal: closeModal } = useAlertModal();

  return (
    <Modal
      animationType="fade"
      visible={isVisible}
      transparent={true}
      onRequestClose={closeModal}
      statusBarTranslucent
      navigationBarTranslucent
    >
      <Pressable
        onPress={content?.onPressBackground ?? closeModal}
        style={styles.background}
        accessibilityRole="button"
        accessibilityLabel="배경을 눌러 닫기"
      >
        <Pressable
          onPress={(e: GestureResponderEvent) => e.stopPropagation()}
          style={styles.modalBox}
          accessibilityViewIsModal
        >
          <AlertModalContentBox />
          <AlertModalButtonBox />
        </Pressable>
      </Pressable>
    </Modal>
  );
}

const styles = StyleSheet.create({
  background: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: COLORS.TRANSPARENT.BLACK_30,
  },
  modalBox: {
    width: 300,
    backgroundColor: COLORS.GRAYSCALE.WHITE,
    borderRadius: LAYOUT.BORDER_RADIUS,
  },
});

export default AlertModal;
