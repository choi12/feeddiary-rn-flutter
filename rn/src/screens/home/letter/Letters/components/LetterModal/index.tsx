import React from 'react';
import { StyleSheet } from 'react-native';
import { Image as FastImage } from 'expo-image';
import Animated, { AnimatedStyle } from 'react-native-reanimated';

import { LetterDTO } from '@/api/letter/types';
import { LetterPaper } from '@/assets/images';
import BaseModal from '@/components/modal/BaseModal';

import LetterModalContent from './components/LetterModalContent';

interface LetterModalProps {
  isVisible: boolean;
  onCloseModal: () => void;
  selectedLetter: LetterDTO;
  animatedStyle: AnimatedStyle;
}

function LetterModal({ isVisible, onCloseModal, selectedLetter, animatedStyle }: LetterModalProps) {
  return (
    <BaseModal isVisible={isVisible} onClose={onCloseModal} allowPropagation>
      <Animated.View style={[styles.modalBox, animatedStyle]}>
        <FastImage source={LetterPaper} style={styles.modalBackgroundImage} contentFit="fill" />
        <LetterModalContent selectedLetter={selectedLetter} />
      </Animated.View>
    </BaseModal>
  );
}

const styles = StyleSheet.create({
  modalBox: {
    width: 260,
    aspectRatio: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  modalBackgroundImage: {
    width: '100%',
    height: '100%',
  },
});

export default LetterModal;
