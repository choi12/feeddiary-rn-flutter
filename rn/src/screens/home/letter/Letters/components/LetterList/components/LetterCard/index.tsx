import React from 'react';
import { GestureResponderEvent, StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';
import Animated, { FadeIn, FadeOut } from 'react-native-reanimated';

import { LetterDTO } from '@/api/letter/types';
import { LetterPaper, Pin } from '@/assets/images';
import AnimatedPressable from '@/components/common/AnimatedPressable';

import { LETTER_NUM_COLUMNS } from '../..';
import useDeleteLetter from '../../../../hooks/useDeleteLetter';
import useLetterSwingAnimation from '../../../../hooks/useLetterSwingAnimation';

import DeleteButton from './components/DeleteButton';
import LetterCardContent from './components/LetterCardContent';

export const LETTER_CARD_SIZE = 100;

interface LetterCardProps {
  letter: LetterDTO;
  letterIndex: number;
  editMode: boolean;
  onOpenLetterModal: (event: GestureResponderEvent, letter: LetterDTO) => void;
}

function LetterCard({ letter, letterIndex, editMode, onOpenLetterModal }: LetterCardProps) {
  const { handleOpenDeleteModal } = useDeleteLetter();
  const { evenAnimatedStyle, oddAnimatedStyle } = useLetterSwingAnimation();

  const isEvenColumn = letterIndex % LETTER_NUM_COLUMNS === 0;

  return (
    <View style={[styles.letterContainer, { marginTop: isEvenColumn ? 0 : 80 }]}>
      <Animated.View style={[isEvenColumn ? evenAnimatedStyle : oddAnimatedStyle]} entering={FadeIn} exiting={FadeOut}>
        <AnimatedPressable
          onPress={(event) => onOpenLetterModal(event, letter)}
          pressedScale={0.98}
          pressedOpacity={0.99}
          style={styles.letterBox}
        >
          <FastImage
            source={LetterPaper}
            style={styles.letterBackgroundImage}
            contentFit="contain"
          />
          <LetterCardContent letter={letter} />
        </AnimatedPressable>
        {editMode && <DeleteButton onPress={() => handleOpenDeleteModal(letter.idx)} />}
      </Animated.View>
      <FastImage source={Pin} style={styles.pinImage} contentFit="contain" />
    </View>
  );
}

const styles = StyleSheet.create({
  letterContainer: {
    width: '50%',
    alignItems: 'center',
  },
  letterBox: {
    width: LETTER_CARD_SIZE,
    aspectRatio: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  letterBackgroundImage: {
    width: '100%',
    aspectRatio: 1,
  },
  pinImage: {
    position: 'absolute',
    width: 25,
    height: 25,
    top: -3,
    transform: [{ rotate: '40deg' }],
    zIndex: 1,
  },
});

export default LetterCard;
