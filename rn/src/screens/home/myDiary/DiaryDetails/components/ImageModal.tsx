import React from 'react';
import { Dimensions, StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import BaseModal from '@/components/modal/BaseModal';

interface ImageModalProps {
  isVisible: boolean;
  onToggleModal: () => void;
  image: string;
}

function ImageModal({ isVisible, onToggleModal, image }: ImageModalProps) {
  const { width, height } = Dimensions.get('screen');

  return (
    <BaseModal isVisible={isVisible} onClose={onToggleModal} allowPropagation isImageModal>
      <View style={{ width, height }}>
        <FastImage source={{ uri: image }} style={styles.image} contentFit="contain" />
      </View>
    </BaseModal>
  );
}

const styles = StyleSheet.create({
  image: {
    width: '100%',
    height: '100%',
  },
});

export default ImageModal;
