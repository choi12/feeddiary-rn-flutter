import useTypedContext from '@/hooks/core/context/useTypedContext';
import { createNamedContext } from '@/utils/context/createNamedContext';

import { Diary, DiaryCardSize } from '../types';

type DiaryCardContext = {
  diary: Diary;
  size: DiaryCardSize;
};

export const DiaryCardContext = createNamedContext<DiaryCardContext | undefined>('DiaryCardContext', undefined);
export const useDiaryCardContext = () => useTypedContext(DiaryCardContext);
