import React from 'react';
import { TextProps } from 'react-native';

import { VECTOR_ICONS } from './data';
import { VectorIconType } from './types';

interface VectorIconProps extends TextProps {
  type: VectorIconType;
  name: string;
  size: number;
  color: string;
}

function VectorIcon(props: VectorIconProps) {
  const Icon = VECTOR_ICONS[props.type];

  return <Icon {...props} />;
}
export default VectorIcon;
