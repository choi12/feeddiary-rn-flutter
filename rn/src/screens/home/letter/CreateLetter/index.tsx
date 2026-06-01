import React from 'react';
import { ImageBackground } from 'react-native';

import { LetterBoard } from '@/assets/images';
import Container from '@/components/common/Container';
import CustomButton from '@/components/common/CustomButton';
import CustomHeader from '@/components/common/CustomHeader';
import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import StatusBarBox from '@/components/common/StatusBarBox';
import { COLORS } from '@/constants';

import InfoTextBox from './components/InfoTextBox';
import LetterInput from './components/LetterInput';
import useCreateLetter from './hooks/useCreateLetter';

function CreateLetter() {
  const { text, setText, handleSubmitLetter, isPending } = useCreateLetter();

  return (
    <SafeAreaContainer edges={[]}>
      <ImageBackground source={LetterBoard} style={{ flex: 1 }}>
        <StatusBarBox backgroundColor={COLORS.TRANSPARENT.TRANSPARENT} />
        <CustomHeader title="편지 쓰기" font="ONGLE" hasCloseButton />
        <Container backgroundColor={COLORS.TRANSPARENT.TRANSPARENT} hasPadding>
          <LetterInput text={text} onSetText={setText} />
          <InfoTextBox />
          <CustomButton
            title="보내기"
            onPress={handleSubmitLetter}
            disabled={text.trim().length < 1}
            isLoading={isPending}
          />
        </Container>
      </ImageBackground>
    </SafeAreaContainer>
  );
}

export default CreateLetter;
