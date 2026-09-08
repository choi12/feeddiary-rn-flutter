// 일기 상세 조회 훅 — 일기 쿼리·내 일기 판별·공개여부 낙관적 토글 제공
import { useQuery, useQueryClient } from '@tanstack/react-query';
import { useCallback, useMemo, useOptimistic, useTransition } from 'react';

import { APIGetDiary, APIGetDiaryParams } from '@/api/diary/APIGetDiary';
import { APISetVisibility } from '@/api/diary/APISetVisibility';
import { QUERY_KEYS, TOAST_BOTTOM_OFFSET } from '@/constants';
import useUserInfo from '@/hooks/store/useUserInfo';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import { REALTIME_QUERY_CONFIG } from '@/utils/config/query';
import { invalidateQueries } from '@/utils/query/invalidateQueries';

interface UseDiaryDetailsProps {
  diaryIdx: number;
}

function useDiaryDetails({ diaryIdx }: UseDiaryDetailsProps) {
  const queryClient = useQueryClient();
  const userNickname = useUserInfo('nickname');
  const handleErrorWithToast = useErrorToast();

  const {
    data: diary,
    refetch,
    isLoading,
    isError,
  } = useQuery({
    ...REALTIME_QUERY_CONFIG,
    queryKey: [QUERY_KEYS.DIARY, diaryIdx],
    queryFn: async () => {
      const params: APIGetDiaryParams = { diaryIdx };
      return APIGetDiary(params);
    },
  });

  const actualIsVisible = !!diary?.isVisible;
  const [isVisible, applyVisibilityToggle] = useOptimistic(actualIsVisible, (state) => !state);
  const [isVisibilityPending, startVisibilityTransition] = useTransition();

  const isMyDiary = useMemo(() => diary?.nickname === userNickname, [diary, userNickname]);

  const toggleVisibility = useCallback((): boolean | null => {
    if (!diary) return null;
    const nextVisible = !isVisible;
    startVisibilityTransition(async () => {
      applyVisibilityToggle(null);
      try {
        await APISetVisibility({ diaryIdx: diary.idx });
        await invalidateQueries.setVisibility(queryClient, diary.idx); // 재조회 완료까지 낙관 값 유지
      } catch (error) {
        handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.DIARY_DETAILS);
      }
    });
    return nextVisible;
  }, [diary, isVisible, queryClient, applyVisibilityToggle, handleErrorWithToast]);

  return {
    diary,
    refetch,
    isLoading,
    isError,
    isMyDiary,
    isVisible,
    toggleVisibility,
    isVisibilityPending,
  };
}

export default useDiaryDetails;
