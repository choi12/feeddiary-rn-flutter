import useTypedContext from '@/hooks/core/context/useTypedContext';
import { createNamedContext } from '@/utils/context/createNamedContext';

type SidePannelContext = {
  isWateringAnimationVisible: boolean;
  isLoveAnimationVisible: boolean;

  onWateringPlant: () => void;
  onLovePlant: () => void;
};

export const SidePannelContext = createNamedContext<SidePannelContext | undefined>('SidePannelContext', undefined);
export const useSidePannelContext = () => useTypedContext(SidePannelContext);
