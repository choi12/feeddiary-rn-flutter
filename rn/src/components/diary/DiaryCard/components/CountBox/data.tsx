import React, { ReactNode } from 'react';

import VectorIcon from '@/components/common/VectorIcon';
import { COLORS } from '@/constants';

import { CountType } from './types';

export const COUNTBOX_ICONS: Record<CountType, ReactNode> = {
  like: <VectorIcon type="Ionicons" name="heart" color={COLORS.GRAYSCALE.LIGHT_GRAY} size={20} />,
  comment: (
    <VectorIcon type="MaterialCommunityIcons" name="comment-processing" color={COLORS.GRAYSCALE.LIGHT_GRAY} size={20} />
  ),
};
