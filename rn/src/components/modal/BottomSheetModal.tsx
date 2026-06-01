import React, { useCallback, useEffect } from 'react';
import { BackHandler, GestureResponderEvent, Modal, Pressable, StyleSheet } from 'react-native';
import Animated from 'react-native-reanimated';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import Text from '@/components/common/Text';
import { COLORS, LAYOUT } from '@/constants';
import useBottomSheetModal from '@/hooks/store/useBottomSheetModal';
import useModalAnimation from '@/hooks/ui/animation/useModalAnimation';
import { useStore } from '@/store';

function BottomSheetModal() {
  const { bottom: safeAreaBottomInset } = useSafeAreaInsets();
  const { isVisible: isModalVisible, contentArr } = useStore((state) => state.bottomSheet);
  const { closeBottomSheetModal: closeModal } = useBottomSheetModal();
  const { showAnimation, hideAnimation, animatedOpacityStyle, animatedTranslateYStyle } = useModalAnimation();

  const handleCloseModal = useCallback(async () => {
    await hideAnimation();
    closeModal();
  }, [hideAnimation, closeModal]);

  const handleBottomSheetItemPress = async (onItemSelect: () => void) => {
    await handleCloseModal();
    onItemSelect();
  };

  useEffect(() => {
    if (isModalVisible) {
      showAnimation();
    }
  }, [isModalVisible, showAnimation]);

  useEffect(() => {
    const backHandler = BackHandler.addEventListener('hardwareBackPress', () => {
      if (isModalVisible) {
        handleCloseModal();
        return true;
      }
    });

    return () => backHandler.remove();
  }, [isModalVisible, handleCloseModal]);

  return (
    <Modal
      animationType="none"
      visible={isModalVisible}
      transparent
      onRequestClose={handleCloseModal}
      statusBarTranslucent
      navigationBarTranslucent
    >
      <Animated.View style={[styles.container, animatedOpacityStyle]}>
        <Pressable
          onPress={handleCloseModal}
          style={styles.background}
          accessibilityRole="button"
          accessibilityLabel="배경을 눌러 닫기"
        >
          <Animated.View style={animatedTranslateYStyle}>
            <Pressable
              onPress={(e: GestureResponderEvent) => e.stopPropagation()}
              style={[styles.modalBox, { paddingBottom: safeAreaBottomInset }]}
              accessibilityViewIsModal
            >
              {contentArr.map((bottomSheetItem, bottomSheetIndex) => (
                <Pressable
                  key={bottomSheetItem.title}
                  onPress={() => handleBottomSheetItemPress(bottomSheetItem.onPress)}
                  style={[styles.button, contentArr.length - 1 === bottomSheetIndex && styles.lastButton]}
                  accessibilityRole="button"
                  accessibilityLabel={bottomSheetItem.title}
                >
                  {bottomSheetItem.icon && bottomSheetItem.icon}
                  <Text style={[styles.buttonText, { color: bottomSheetItem.color }]}>{bottomSheetItem.title}</Text>
                </Pressable>
              ))}
            </Pressable>
          </Animated.View>
        </Pressable>
      </Animated.View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    top: 0,
    bottom: 0,
    left: 0,
    right: 0,
  },
  background: {
    flex: 1,
    justifyContent: 'flex-end',
    backgroundColor: COLORS.TRANSPARENT.BLACK_30,
  },
  modalBox: {
    width: '100%',
    backgroundColor: COLORS.GRAYSCALE.WHITE,
    borderTopLeftRadius: LAYOUT.BORDER_RADIUS,
    borderTopRightRadius: LAYOUT.BORDER_RADIUS,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 20,
    paddingVertical: 5,
  },
  button: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    width: '100%',
    borderColor: COLORS.GRAYSCALE.WHITE_GRAY,
    paddingVertical: 25,
    gap: 7,
    borderBottomWidth: 1,
  },
  lastButton: {
    borderBottomWidth: 0,
  },
  buttonText: {
    fontSize: 16,
  },
});

export default BottomSheetModal;
