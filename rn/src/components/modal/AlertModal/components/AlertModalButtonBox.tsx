import React from 'react';
import { ActivityIndicator, Pressable, StyleSheet, View } from 'react-native';

import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import { useStore } from '@/store';

function AlertModalButtonBox() {
  const modalContent = useStore((state) => state.alert.content);

  return (
    <View style={styles.buttonBox}>
      {modalContent?.buttons.map((modalButton) => (
        <Pressable
          key={modalButton.text}
          onPress={modalButton.onPress}
          disabled={modalButton.isLoading}
          style={modalButton.style === 'cancel' ? styles.cancelButton : styles.defaultButton}
        >
          {modalButton.isLoading ? (
            <ActivityIndicator color={COLORS.CORE.MAIN} size="small" />
          ) : (
            <Text style={modalButton.style === 'cancel' ? styles.cancelButtonText : styles.defaultButtonText}>
              {modalButton.text}
            </Text>
          )}
        </Pressable>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  buttonBox: {
    flexDirection: 'row',
    width: '100%',
    height: 50,
    borderTopWidth: 1,
    borderColor: COLORS.GRAYSCALE.WHITE_GRAY,
  },
  cancelButton: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    height: '100%',
    borderRightWidth: 1,
    borderColor: COLORS.GRAYSCALE.WHITE_GRAY,
  },
  cancelButtonText: {
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    fontSize: 14,
  },
  defaultButton: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    height: '100%',
  },
  defaultButtonText: {
    color: COLORS.CORE.MAIN,
    fontSize: 14,
  },
});

export default AlertModalButtonBox;
