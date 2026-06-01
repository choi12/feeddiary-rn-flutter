import React from 'react';
import { Pressable, StyleSheet, View } from 'react-native';

import Text from '@/components/common/Text';
import VectorIcon from '@/components/common/VectorIcon';
import BaseModal from '@/components/modal/BaseModal';
import { COLORS, LAYOUT } from '@/constants';

interface ProfileImageTypeModalProps {
  isVisible: boolean;
  onCancel: () => void;
  onSelectPhotoType: () => void;
  onSelectCharacterType: () => void;
}

function ProfileImageTypeModal({
  isVisible,
  onCancel,
  onSelectPhotoType,
  onSelectCharacterType,
}: ProfileImageTypeModalProps) {
  return (
    <BaseModal isVisible={isVisible} onClose={onCancel}>
      <View style={styles.modalBox}>
        <View style={styles.buttonBox}>
          <Pressable onPress={onSelectPhotoType} style={styles.closeButton}>
            <VectorIcon
              type="MaterialIcons"
              name="add-photo-alternate"
              size={18}
              color={COLORS.GRAYSCALE.LIGHT_BLACK}
            />
            <Text style={styles.closeButtonText}>사진 선택하기</Text>
          </Pressable>
          <Pressable onPress={onSelectCharacterType} style={styles.confirmButton}>
            <VectorIcon type="FontAwesome" name="user" size={15} color={COLORS.CORE.MAIN} />
            <Text style={styles.confirmButtonText}>캐릭터 만들기</Text>
          </Pressable>
        </View>
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
  buttonBox: { flexDirection: 'row', height: 60 },
  confirmButton: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    height: '100%',
    borderLeftWidth: 1,
    borderColor: COLORS.GRAYSCALE.LIGHT_GRAY,
    flexDirection: 'row',
    gap: 5,
  },
  confirmButtonText: {
    color: COLORS.CORE.MAIN,
    fontSize: 14,
  },
  closeButton: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    height: '100%',
    flexDirection: 'row',
    gap: 2,
  },
  closeButtonText: {
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    fontSize: 14,
  },
});

export default ProfileImageTypeModal;
