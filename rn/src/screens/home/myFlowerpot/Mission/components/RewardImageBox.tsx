import React from 'react';
import { StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import { RewardItem } from '@/types/mission';

import { REWARD_PRESET } from '../data';

interface RewardImageBoxProps {
  reward: RewardItem;
}

function RewardImageBox({ reward }: RewardImageBoxProps) {
  return (
    <View style={styles.modalImageBox}>
      <View style={styles.itemBox}>
        <FastImage
          source={REWARD_PRESET[reward.item].image}
          style={[styles.modalImage, reward.item === 'love' && styles.rewardLoveImage]}
        />
        <Text style={styles.modalImageText}>{`${REWARD_PRESET[reward.item].name}`}</Text>
      </View>
      <Text style={styles.amountText}>×{reward.count}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  modalImageBox: {
    flexDirection: 'row',
    alignItems: 'flex-end',
    marginBottom: 13,
  },
  itemBox: {
    borderWidth: 2,
    borderColor: COLORS.GRAYSCALE.WHITE_GRAY,
    width: 55,
    height: 55,
    borderRadius: 7,
    alignItems: 'center',
    justifyContent: 'center',
  },
  modalImage: {
    width: 29,
    height: 29,
  },
  rewardLoveImage: {
    width: 24,
    height: 24,
    marginVertical: 2,
  },
  modalImageText: {
    fontSize: 10,
    color: COLORS.GRAYSCALE.BLACK,
    letterSpacing: -0.5,
  },
  amountText: {
    fontSize: 14,
    color: COLORS.CORE.MAIN,
    margin: 3,
  },
});

export default RewardImageBox;
