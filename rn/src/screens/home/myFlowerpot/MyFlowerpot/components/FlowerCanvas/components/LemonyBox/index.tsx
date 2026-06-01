import React from 'react';
import { StyleSheet, useWindowDimensions, View } from 'react-native';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { calculateVerticalCenter } from '@/utils/common/calculateVerticalCenter';

import { useSidePannelContext } from '../../../../context/sidePannel/SidePannelContext';
import useFlowerpotStats from '../../../../hooks/useFlowerpotStats';

import FirstLemony from './components/FirstLemony';
import LottieBox from './components/LottieBox';
import SecondLemony from './components/SecondLemony';
import ThirdLemony from './components/ThirdLemony';

const LEMONY_COMPONENTS: Record<number, React.FC> = {
  1: FirstLemony, // 씨앗 단계
  2: SecondLemony, // 새싹 단계
  3: ThirdLemony, // 열매 단계
};

function LemonyBox() {
  const { width, height } = useWindowDimensions();
  const { bottom } = useSafeAreaInsets();

  const { isLoveAnimationVisible, isWateringAnimationVisible } = useSidePannelContext();

  const { level } = useFlowerpotStats();
  const LemonyComponent = LEMONY_COMPONENTS[level];

  const top = calculateVerticalCenter(height, bottom);

  return (
    <View style={[styles.container, { top, left: width / 2 }]}>
      <LemonyComponent />
      {isWateringAnimationVisible && <LottieBox type="watering" />}
      {isLoveAnimationVisible && <LottieBox type="love" />}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    justifyContent: 'center',
    alignItems: 'center',
    transform: [{ translateX: -90 }, { translateY: -180 }],
  },
});

export default LemonyBox;
