import React from 'react';
import { Pressable, StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import { REWARD_PRESET } from '@/screens/home/myFlowerpot/Mission/data';
import { useSidePannelContext } from '@/screens/home/myFlowerpot/MyFlowerpot/context/sidePannel/SidePannelContext';
import useFlowerpotStats from '@/screens/home/myFlowerpot/MyFlowerpot/hooks/useFlowerpotStats';
import { PlantAction } from '@/types/mission';

import { ActionControlConfig } from './types';

interface ActionButtonProps {
  type: PlantAction;
}

function ActionButton({ type }: ActionButtonProps) {
  const { onWateringPlant, onLovePlant } = useSidePannelContext();
  const { wateringCount, loveCount, canWater, canLove } = useFlowerpotStats();

  const ACTION_STATE: Record<PlantAction, ActionControlConfig> = {
    watering: {
      onPress: onWateringPlant,
      disabled: !canWater,
      count: wateringCount,
      style: styles.wateringImage,
    },
    love: {
      onPress: onLovePlant,
      disabled: !canLove,
      count: loveCount,
      style: styles.loveImage,
    },
  };
  const currentAction = ACTION_STATE[type];

  return (
    <Pressable
      onPress={currentAction.onPress}
      disabled={currentAction.disabled}
      style={({ pressed }) => [
        styles.button,
        pressed && styles.buttonPressed,
        currentAction.disabled && styles.buttonDisabled,
      ]}
    >
      <FastImage source={REWARD_PRESET[type].image} style={currentAction.style} />
      <Text style={styles.buttonText}>{REWARD_PRESET[type].name}</Text>
      {currentAction.count > 0 && (
        <View style={styles.badge}>
          <Text style={styles.badgeText}>{currentAction.count}</Text>
        </View>
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
  buttonDisabled: {
    opacity: 0.7,
  },
  wateringImage: {
    width: 33,
    height: 33,
    marginTop: 2,
  },
  loveImage: {
    marginTop: 2,
    width: 26,
    height: 26,
    marginBottom: 2,
  },
  buttonText: {
    fontSize: 11,
    color: COLORS.GRAYSCALE.BLACK,
    marginTop: 1,
    letterSpacing: -0.5,
  },
  badge: {
    width: 19,
    height: 19,
    backgroundColor: COLORS.ACCENT.RED,
    borderRadius: 9.5,
    position: 'absolute',
    right: -8,
    top: -8,
    alignItems: 'center',
    justifyContent: 'center',
    paddingTop: 2,
  },
  badgeText: {
    fontSize: 12,
    color: COLORS.GRAYSCALE.WHITE,
  },
});

export default ActionButton;
