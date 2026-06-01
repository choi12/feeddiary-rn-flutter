import useTypedContext from '@/hooks/core/context/useTypedContext';
import { CommunitySort } from '@/types/community';
import { createNamedContext } from '@/utils/context/createNamedContext';

type CommunityHeaderContext = {
  isScrolled: boolean;
  startScroll: () => void;
  endScroll: () => void;

  sort: CommunitySort;
  onSetSortType: (sort: CommunitySort) => void;
};

export const CommunityHeaderContext = createNamedContext<CommunityHeaderContext | undefined>(
  'CommunityHeaderContext',
  undefined,
);
export const useCommunityHeaderContext = () => useTypedContext(CommunityHeaderContext);
