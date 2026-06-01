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
