import { useQueryClient } from '@tanstack/react-query';
import { useCallback, useOptimistic, useState, useTransition } from 'react';

import { CommunityDiaryDTO } from '@/api/community/types';
import { APILikeDiary } from '@/api/diary/APILikeDiary';
import { MESSAGE, TOAST_BOTTOM_OFFSET } from '@/constants';
import useToast from '@/hooks/store/useToast';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import { delay } from '@/utils/common/delay';
import { invalidateQueries } from '@/utils/query/invalidateQueries';

interface UseLikeDiaryProps {
  diary: CommunityDiaryDTO;
  isMyDiary: boolean;
}

const ANIMATION_DURATION = 500;

function useLikeDiary({ diary, isMyDiary }: UseLikeDiaryProps) {
  const queryClient = useQueryClient();

  const [isLikeAnimationVisible, setIsLikeAnimationVisible] = useState(false);

  const { showToast } = useToast();
  const handleErrorWithToast = useErrorToast();

  const [optimisticDiary, toggleOptimisticLike] = useOptimistic(diary, (state) => ({
    ...state,
    isLike: !state.isLike,
    likeCount: state.isLike ? state.likeCount - 1 : state.likeCount + 1,
  }));
  const [isPending, startTransition] = useTransition();

  const handleLike = useCallback(() => {
    if (isMyDiary) {
      showToast(MESSAGE.DIARY.LIKE_MY_DIARY, TOAST_BOTTOM_OFFSET.DIARY_DETAILS);
      return;
    }

    startTransition(async () => {
      toggleOptimisticLike(null);
      try {
        const response = await APILikeDiary({ diaryIdx: diary.idx });
        invalidateQueries.likeDiary(queryClient, diary.idx);

        if (response.isLike) {
          setIsLikeAnimationVisible(true);
          await delay(ANIMATION_DURATION);
          setIsLikeAnimationVisible(false);
        }
      } catch (error) {
        handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.DIARY_DETAILS);
      }
    });
  }, [diary.idx, isMyDiary, showToast, queryClient, handleErrorWithToast, toggleOptimisticLike]);

  return {
    handleLike,
    isLiked: optimisticDiary.isLike,
    likeCount: optimisticDiary.likeCount,
    isLikeAnimationVisible,
    isPending,
  };
}

export default useLikeDiary;
