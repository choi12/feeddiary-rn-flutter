// 일기 좋아요 훅 — 좋아요 낙관적 토글과 좋아요 애니메이션 노출 제어
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
        const refetched = invalidateQueries.likeDiary(queryClient, diary.idx);

        if (response.isLike) {
          setIsLikeAnimationVisible(true);
          await delay(ANIMATION_DURATION);
          setIsLikeAnimationVisible(false);
        }
        // transition 이 끝나면 낙관 값이 base(서버값)로 돌아가므로, 재조회가 끝날 때까지 기다린다
        await refetched;
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
