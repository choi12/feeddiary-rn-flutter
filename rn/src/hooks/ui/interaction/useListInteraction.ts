import { RefObject, useCallback, useState } from 'react';
import { FlatList, NativeScrollEvent, NativeSyntheticEvent } from 'react-native';

import { SCROLL_THRESHOLD } from '@/constants';
import useThrottle from '@/hooks/core/useThrottle';

interface UseListInteractionProps<T> {
  flatListRef: RefObject<FlatList | null>;
  refetch: () => Promise<T>;
  startScroll: () => void;
  endScroll: () => void;
}

function useListInteraction<T>({ flatListRef, refetch, startScroll, endScroll }: UseListInteractionProps<T>) {
  const [isRefreshing, setIsRefreshing] = useState(false);

  const scrollChange = useCallback(
    (scrollOffset: number) => {
      if (scrollOffset > SCROLL_THRESHOLD) {
        startScroll();
      } else {
        endScroll();
      }
    },
    [startScroll, endScroll],
  );

  const throttledScrollChange = useThrottle({ callback: scrollChange, delay: 200 });

  const handleScroll = useCallback(
    (event: NativeSyntheticEvent<NativeScrollEvent>) => {
      const scrollOffset = event.nativeEvent.contentOffset.y;
      throttledScrollChange(scrollOffset);
    },
    [throttledScrollChange],
  );

  const handleRefresh = useCallback(() => {
    setIsRefreshing(true);
    refetch().finally(() => setIsRefreshing(false));
  }, [refetch]);

  const scrollToTop = useCallback(() => {
    if (flatListRef.current) {
      flatListRef.current.scrollToOffset({ animated: true, offset: 0 });
    }
  }, [flatListRef]);

  return { flatListRef, isRefreshing, handleScroll, handleRefresh, scrollToTop };
}

export default useListInteraction;
