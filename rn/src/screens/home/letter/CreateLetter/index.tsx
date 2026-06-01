// 편지 작성 화면 — 편지 본문을 입력해 전송하는 화면
import React from 'react';
import { ImageBackground, StyleSheet } from 'react-native';

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
      <ImageBackground source={LetterBoard} style={styles.background}>
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

const styles = StyleSheet.create({
  background: {
    flex: 1,
  },
});

export default CreateLetter;
