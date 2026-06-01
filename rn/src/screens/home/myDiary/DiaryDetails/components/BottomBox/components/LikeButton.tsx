import LottieView from 'lottie-react-native';
import React from 'react';
import { Pressable, StyleSheet, View } from 'react-native';

import { CommunityDiaryDTO } from '@/api/community/types';
import { LottieHeartGreen } from '@/assets/lottie';
import Text from '@/components/common/Text';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS, MAX_DISPLAY_COUNT, OVERFLOW_COUNT_TEXT } from '@/constants';

import useLikeDiary from '../../../hooks/useLikeDiary';

interface LikeButtonProps {
  diary: CommunityDiaryDTO;
  isMyDiary: boolean;
}

function LikeButton({ diary, isMyDiary }: LikeButtonProps) {
  const { handleLike, isLiked, likeCount, isLikeAnimationVisible, isPending } = useLikeDiary({ diary, isMyDiary });

  return (
    <Pressable
      onPress={handleLike}
      disabled={isPending}
      style={styles.likeButton}
      accessibilityRole="button"
      accessibilityLabel={`좋아요 ${likeCount}개${isLiked ? ', 누름' : ''}`}
      accessibilityState={{ selected: isLiked, disabled: isPending }}
    >
      <View style={styles.countBox}>
        <VectorIcon
          type="Ionicons"
          name="heart"
          color={isMyDiary ? COLORS.GRAYSCALE.LIGHT_GRAY : isLiked ? COLORS.CORE.MAIN : COLORS.GRAYSCALE.LIGHT_GRAY}
          size={25}
        />
        {isLikeAnimationVisible && <LottieView source={LottieHeartGreen} autoPlay style={styles.likeLottie} />}
        <Text style={styles.countText}>{likeCount > MAX_DISPLAY_COUNT ? OVERFLOW_COUNT_TEXT : likeCount}</Text>
      </View>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  likeButton: {
    position: 'relative',
    marginRight: 20,
  },
  likeLottie: {
    position: 'absolute',
    left: -61,
    top: -65,
    width: 150,
    height: 150,
  },
  countBox: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  countText: {
    color: COLORS.GRAYSCALE.BLACK,
    fontSize: 16,
    marginLeft: 6,
  },
});

export default LikeButton;
