// 로그인 화면 — 캐릭터 캔버스와 소셜 로그인 버튼을 배치하는 진입 화면
import React from 'react';
import { StyleSheet } from 'react-native';

import Container from '@/components/common/Container';
import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import StatusBarBox from '@/components/common/StatusBarBox';
import ExitController from '@/components/controller/ExitController';
import { COLORS } from '@/constants';

import ButtonBox from './components/ButtonBox';
import CharacterCanvas from './components/CharacterCanvas';

function SignIn() {
  return (
    <ExitController>
      <SafeAreaContainer edges={['bottom']} backgroundColor={COLORS.BRAND.FIELD_GREEN}>
        <StatusBarBox backgroundColor={COLORS.GRAYSCALE.WHITE} />
        <Container style={styles.container}>
          <CharacterCanvas />
          <ButtonBox />
        </Container>
      </SafeAreaContainer>
    </ExitController>
  );
}

const styles = StyleSheet.create({
  container: { justifyContent: 'space-between' },
});

export default SignIn;
