import { useFocusEffect } from '@react-navigation/native';
import React, { useCallback } from 'react';
import { StyleSheet, ImageBackground } from 'react-native';

import { LetterBoard } from '@/assets/images';
import Container from '@/components/common/Container';
import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import ErrorView from '@/components/common/stateView/ErrorView';
import LoadingView from '@/components/common/stateView/LoadingView';
import StatusBarBox from '@/components/common/StatusBarBox';
import { COLORS, LAYOUT } from '@/constants';
import useVisibility from '@/hooks/ui/animation/useVisibility';

import CreateLetterButton from './components/CreateLetterButton';
import LetterHeader from './components/LetterHeader';
import LetterList from './components/LetterList';
import LetterModal from './components/LetterModal';
import useAnimatedLetterModal from './hooks/useAnimatedLetterModal';
import useLetters from './hooks/useLetters';

function Letters() {
  const { isVisible: isEditMode, toggle: toggleEditMode, hide: hideEditMode } = useVisibility();
  const { isLoading, isError, refetch } = useLetters();
  const { selectedLetter, letterModalVisible, animatedStyle, handleCloseLetterModal, handleOpenLetterModal } =
    useAnimatedLetterModal();

  useFocusEffect(
    useCallback(() => {
      return () => {
        if (isEditMode) {
          hideEditMode();
        }
      };
    }, [isEditMode, hideEditMode]),
  );

  if (isLoading) return <LoadingView />;
  if (isError) return <ErrorView reload={refetch} />;

  return (
    <SafeAreaContainer edges={[]}>
      <ImageBackground source={LetterBoard} style={styles.imageBackground}>
        <StatusBarBox backgroundColor={COLORS.TRANSPARENT.TRANSPARENT} />
        <LetterHeader isEditMode={isEditMode} onToggleEditMode={toggleEditMode} />
        <Container backgroundColor={COLORS.TRANSPARENT.TRANSPARENT} style={styles.container}>
          <CreateLetterButton />
          <LetterList editMode={isEditMode} onOpenLetterModal={handleOpenLetterModal} />
        </Container>
        {selectedLetter && (
          <LetterModal
            isVisible={letterModalVisible}
            onCloseModal={handleCloseLetterModal}
            selectedLetter={selectedLetter}
            animatedStyle={animatedStyle}
          />
        )}
      </ImageBackground>
    </SafeAreaContainer>
  );
}

const styles = StyleSheet.create({
  container: {
    paddingHorizontal: LAYOUT.PADDING,
  },
  imageBackground: {
    flex: 1,
  },
});

export default Letters;
