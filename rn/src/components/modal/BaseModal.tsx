import React, { PropsWithChildren } from 'react';
import { GestureResponderEvent, Modal, ModalProps, Pressable, StyleSheet } from 'react-native';

import { COLORS } from '@/constants';

interface BaseModalProps extends ModalProps {
  isVisible: boolean;
  onClose: () => void;
  allowPropagation?: boolean;
  isImageModal?: boolean;
}

function BaseModal({
  isVisible,
  children,
  onClose,
  allowPropagation = false,
  isImageModal = false,
  ...props
}: PropsWithChildren<BaseModalProps>) {
  if (!isVisible) return null;

  return (
    <Modal
      animationType="fade"
      visible={isVisible}
      transparent={true}
      onRequestClose={onClose}
      statusBarTranslucent
      navigationBarTranslucent
      {...props}
    >
      <Pressable
        onPress={onClose}
        style={[styles.background, isImageModal && { backgroundColor: COLORS.TRANSPARENT.BLACK_90 }]}
        accessibilityRole="button"
        accessibilityLabel="배경을 눌러 닫기"
      >
        <Pressable
          onPress={allowPropagation ? onClose : (e: GestureResponderEvent) => e.stopPropagation()}
          accessibilityViewIsModal
        >
          {children}
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
});

export default BaseModal;
