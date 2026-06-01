// 댓글 목록 조회 훅 — 특정 일기의 댓글을 실시간 설정으로 조회
import { useQuery } from '@tanstack/react-query';

import { APIGetComments, APIGetCommentsParams } from '@/api/comment/APIGetComments';
import { QUERY_KEYS } from '@/constants';
import { REALTIME_QUERY_CONFIG } from '@/utils/config/query';

interface UseCommentsQueryProps {
  diaryIdx: number;
}

function useCommentsQuery({ diaryIdx }: UseCommentsQueryProps) {
  return useQuery({
    ...REALTIME_QUERY_CONFIG,
    queryKey: [QUERY_KEYS.COMMENTS, diaryIdx],
    queryFn: () => {
      const params: APIGetCommentsParams = { diaryIdx };
      return APIGetComments(params);
    },
  });
}

export default useCommentsQuery;
