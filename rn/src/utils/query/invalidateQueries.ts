import { QueryClient } from '@tanstack/react-query';

import { MyDiaryDTO } from '@/api/diary/types';
import { QUERY_KEYS } from '@/constants';

type QueryKeyValue = (typeof QUERY_KEYS)[keyof typeof QUERY_KEYS];

const queryInvalidator = {
  one: (queryClient: QueryClient, queryKey: QueryKeyValue, diaryIdx?: number) => {
    queryClient.invalidateQueries({ queryKey: diaryIdx ? [queryKey, diaryIdx] : [queryKey] });
  },
  many: (queryClient: QueryClient, queryKeys: QueryKeyValue[]) => {
    queryClient.invalidateQueries({
      // 각 쿼리마다 이 함수가 실행되어 true를 반환하면 해당 쿼리를 무효화
      predicate: (query): boolean => {
        const rootKey = query.queryKey[0] as QueryKeyValue;
        return queryKeys.includes(rootKey);
      },
    });
  },
};

const DIARIES_GROUP = [QUERY_KEYS.DIARIES, QUERY_KEYS.MONTHLY_DIARIES, QUERY_KEYS.COMMUNITY_DIARIES];
const MISSION_GROUP = [QUERY_KEYS.MISSIONS, QUERY_KEYS.FLOWERPOT];

export const invalidateQueries = {
  // 일기 등록/편집(6) : [DIARY, diary.idx], DIARIES_GROUP, MISSION_GROUP
  diaryAction: (queryClient: QueryClient, diary?: MyDiaryDTO) => {
    if (!diary) {
      // 일기 신규 등록
      queryInvalidator.many(queryClient, [...DIARIES_GROUP, ...MISSION_GROUP]);
    } else {
      // 일기 편집
      queryInvalidator.one(queryClient, QUERY_KEYS.DIARY, diary.idx);
      queryInvalidator.many(queryClient, DIARIES_GROUP);
    }
  },
  // 일기 삭제(3) : DIARIES_GROUP
  deleteDiary: (queryClient: QueryClient) => {
    queryInvalidator.many(queryClient, DIARIES_GROUP);
  },

  // 일기 공개 설정(6) : [DIARY, diaryIdx], DIARIES_GROUP, MISSION_GROUP
  setVisibility: (queryClient: QueryClient, diaryIdx: number) => {
    queryInvalidator.one(queryClient, QUERY_KEYS.DIARY, diaryIdx);
    queryInvalidator.many(queryClient, [...DIARIES_GROUP, ...MISSION_GROUP]);
  },
  // 일기 좋아요(4) : [DIARY, diaryIdx], COMMUNITY_DIARIES, MISSION_GROUP
  likeDiary: (queryClient: QueryClient, diaryIdx: number) => {
    queryInvalidator.one(queryClient, QUERY_KEYS.DIARY, diaryIdx);
    queryInvalidator.many(queryClient, [QUERY_KEYS.COMMUNITY_DIARIES, ...MISSION_GROUP]);
  },

  // 댓글 등록(6) : [COMMENTS, diaryIdx], [DIARY, diaryIdx], DIARIES, COMMUNITY_DIARIES, MISSION_GROUP
  createComment: (queryClient: QueryClient, diaryIdx: number) => {
    queryInvalidator.one(queryClient, QUERY_KEYS.COMMENTS, diaryIdx);
    queryInvalidator.one(queryClient, QUERY_KEYS.DIARY, diaryIdx);
    queryInvalidator.many(queryClient, [QUERY_KEYS.DIARIES, QUERY_KEYS.COMMUNITY_DIARIES, ...MISSION_GROUP]);
  },
  // 댓글 삭제(4) : [COMMENTS, diaryIdx], [DIARY, diaryIdx], DIARIES, COMMUNITY_DIARIES
  deleteComment: (queryClient: QueryClient, diaryIdx: number) => {
    queryInvalidator.one(queryClient, QUERY_KEYS.COMMENTS, diaryIdx);
    queryInvalidator.one(queryClient, QUERY_KEYS.DIARY, diaryIdx);
    queryInvalidator.many(queryClient, [QUERY_KEYS.DIARIES, QUERY_KEYS.COMMUNITY_DIARIES]);
  },

  // 미션 완료(2) : MISSIONS (FLOWERPOT은 미션 컴포넌트 클린업할 때 해서 여기서는 생략함)
  completeMission: (queryClient: QueryClient) => {
    queryInvalidator.one(queryClient, QUERY_KEYS.MISSIONS);
  },
  // 물주기(1) : FLOWERPOT
  wateringPlant: (queryClient: QueryClient) => {
    queryInvalidator.one(queryClient, QUERY_KEYS.FLOWERPOT);
  },
  // 사랑주기(1) : FLOWERPOT
  lovePlant: (queryClient: QueryClient) => {
    queryInvalidator.one(queryClient, QUERY_KEYS.FLOWERPOT);
  },

  // 편지 등록(1) : LETTERS
  createLetter: (queryClient: QueryClient) => {
    queryInvalidator.one(queryClient, QUERY_KEYS.LETTERS);
  },
  // 편지 삭제(1) : LETTERS
  deleteLetter: (queryClient: QueryClient) => {
    queryInvalidator.one(queryClient, QUERY_KEYS.LETTERS);
  },

  // 일기 신고(유저 차단)(1) : COMMUNITY_DIARIES
  reportDiary: (queryClient: QueryClient) => {
    queryInvalidator.one(queryClient, QUERY_KEYS.COMMUNITY_DIARIES);
  },
};
