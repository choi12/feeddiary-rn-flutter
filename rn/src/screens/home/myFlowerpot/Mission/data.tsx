import React, { ReactNode } from 'react';
import { ImageRequireSource } from 'react-native';

import { LovePlant, WateringPlant } from '@/assets/images';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS, TEXT } from '@/constants';
import { Mission, PlantAction } from '@/types/mission';

type MissionConfig = {
  title: string;
  icon: ReactNode;
  content: string;
};

export const MISSION_PRESET: Record<Mission, MissionConfig> = {
  diary: {
    title: TEXT.MISSION.DIARY.TITLE,
    icon: <VectorIcon type="FontAwesome5" name="book" color={COLORS.ACCENT.ORANGE} size={20} />,
    content: TEXT.MISSION.DIARY.CONTENT,
  },
  visible: {
    title: TEXT.MISSION.VISIBLE.TITLE,
    icon: <VectorIcon type="Ionicons" name="eye" color={COLORS.ACCENT.ORANGE} size={20} />,
    content: TEXT.MISSION.VISIBLE.CONTENT,
  },
  comment: {
    title: TEXT.MISSION.COMMENT.TITLE,
    icon: <VectorIcon type="MaterialCommunityIcons" name="comment-processing" color={COLORS.ACCENT.ORANGE} size={21} />,
    content: TEXT.MISSION.COMMENT.CONTENT,
  },
  like: {
    title: TEXT.MISSION.LIKE.TITLE,
    icon: <VectorIcon type="Ionicons" name="heart" color={COLORS.ACCENT.ORANGE} size={22} />,
    content: TEXT.MISSION.LIKE.CONTENT,
  },
};

type ActionRewardConfig = {
  name: string;
  image: ImageRequireSource;
};

export const REWARD_PRESET: Record<PlantAction, ActionRewardConfig> = {
  watering: {
    name: TEXT.REWARD.WATERING,
    image: WateringPlant,
  },
  love: {
    name: TEXT.REWARD.LOVE,
    image: LovePlant,
  },
};
