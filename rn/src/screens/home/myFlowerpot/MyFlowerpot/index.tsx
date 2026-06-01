import React from 'react';
import { StatusBar } from 'react-native';

import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import ExitController from '@/components/controller/ExitController';

import Background from './components/Background';
import FlowerCanvas from './components/FlowerCanvas';
import MyFlowerpotProviders from './context/MyFlowerpotProviders';

function MyFlowerpot() {
  return (
    <MyFlowerpotProviders>
      <ExitController>
        <SafeAreaContainer edges={['bottom']}>
          <StatusBar translucent backgroundColor="transparent" />
          <Background>
            <FlowerCanvas />
          </Background>
        </SafeAreaContainer>
      </ExitController>
    </MyFlowerpotProviders>
  );
}

export default MyFlowerpot;
