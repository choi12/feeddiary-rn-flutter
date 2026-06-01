import React, { useEffect } from 'react';
import { Pressable, StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';
import Animated, { cancelAnimation, Easing, useSharedValue, withRepeat, withTiming } from 'react-native-reanimated';

import { Mission } from '@/assets/images';
import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';
import usePrefetchMissions from '@/hooks/prefetch/usePrefetchMissions';
import useFlowerpotStats from '@/screens/home/myFlowerpot/MyFlowerpot/hooks/useFlowerpotStats';

const INITIAL_OPACITY_VALUE = 0.2;

function MissionButton() {
  const navigation = useScreenNavigation();

  const opacity = useSharedValue(INITIAL_OPACITY_VALUE);

  const { showBadge } = useFlowerpotStats();
  const prefetchMissions = usePrefetchMissions();

  const navigateToMission = async () => {
    await prefetchMissions();
    navigation.navigate('Mission');
  };

  useEffect(() => {
    if (showBadge) {
      opacity.value = withRepeat(withTiming(0.6, { duration: 600, easing: Easing.linear }), -1, true);
    } else {
      cancelAnimation(opacity);
      opacity.value = INITIAL_OPACITY_VALUE;
    }

    return () => {
      cancelAnimation(opacity);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [showBadge]);

  return (
    <Pressable onPress={navigateToMission} style={({ pressed }) => [styles.button, pressed && styles.buttonPressed]}>
      <FastImage source={Mission} style={styles.missionImage} />
      <Text style={styles.buttonText}>미션</Text>
      {showBadge && (
        <Animated.View style={[styles.badgeBox, { opacity: opacity }]}>
          <View style={styles.badge} />
        </Animated.View>
      )}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  button: {
    borderWidth: 2,
    borderRadius: 10,
    borderColor: COLORS.TRANSPARENT.WHITE_70,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: COLORS.TRANSPARENT.WHITE_30,
    width: 65,
    height: 65,
  },
  buttonPressed: {
    opacity: 0.8,
  },
  missionImage: {
    marginTop: 2,
    width: 25,
    height: 25,
  },
  buttonText: {
    fontSize: 11,
    color: COLORS.GRAYSCALE.BLACK,
    marginTop: 6,
  },
  badgeBox: { position: 'absolute', right: 7, top: 6 },
  badge: {
    width: 9,
    height: 9,
    backgroundColor: COLORS.ACCENT.RED,
    borderRadius: 4.5,
  },
});

export default MissionButton;
