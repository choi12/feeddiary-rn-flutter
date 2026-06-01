import React, { PropsWithChildren, useMemo } from 'react';

import usePlantInteraction from '../../hooks/usePlantInteraction';

import { SidePannelContext } from './SidePannelContext';

function SidePannelProvider({ children }: PropsWithChildren) {
  const { isWateringAnimationVisible, isLoveAnimationVisible, handleWateringPlant, handleLovePlant } =
    usePlantInteraction();

  const contextValue = useMemo(
    () => ({
      isWateringAnimationVisible,
      isLoveAnimationVisible,
      onWateringPlant: handleWateringPlant,
      onLovePlant: handleLovePlant,
    }),
    [isWateringAnimationVisible, isLoveAnimationVisible, handleWateringPlant, handleLovePlant],
  );

  return <SidePannelContext.Provider value={contextValue}>{children}</SidePannelContext.Provider>;
}

export default SidePannelProvider;
