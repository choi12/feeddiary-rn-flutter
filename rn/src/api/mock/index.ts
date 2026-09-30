// 데모 모드(USE_MOCK) axios mock 어댑터 — 전체 API 엔드포인트를 가변 상태로 시뮬레이션
import MockAdapter from 'axios-mock-adapter';
import Config from 'react-native-config';

import type { UserResponse } from '@/api/auth/types';
import type { CommentResponse } from '@/api/comment/types';
import type { CommunityDiaryResponse } from '@/api/community/types';
import type { DailyDiaryResponse, MyDiaryResponse } from '@/api/diary/types';
import type { FlowerpotResponse } from '@/api/flowerpot/types';
import type { LetterResponse } from '@/api/letter/types';
import type { CompleteMissionResponse, MissionsResponse } from '@/api/mission/types';
import type { Mission, RewardItem } from '@/types/mission';

import request from '../request';

import {
  MOCK_APP_VERSION,
  MOCK_COMMENTS,
  MOCK_COMMUNITY_DIARIES,
  MOCK_FLOWERPOT,
  MOCK_LETTERS,
  MOCK_MISSIONS,
  MOCK_MY_DIARIES,
  MOCK_USER,
} from './data';
import { getFormField, getImageUri, getNumber, getString } from './helpers';

const okResponse = <T>(resData: T) => ({ status: 'success' as const, resData });
const okStatus = () => ({ status: 'success' as const });

// 데모 실패 시연 센티넬 — 제출 텍스트에 포함되면 mock 이 500 을 반환한다(Flutter DemoApiAdapter 와 대칭).
const ERROR_SENTINEL = '#에러';
const SERVER_FAULT_MESSAGE = '서버 오류가 발생했어요. 잠시 후 다시 시도해 주세요.';
const hasErrorSentinel = (text: unknown): boolean => typeof text === 'string' && text.includes(ERROR_SENTINEL);
const failResponse = (message: string) => ({ status: 'failed' as const, message });

type MockInstalled = { __mockInstalled?: true };

export const setupMockAdapter = () => {
  if (Config.USE_MOCK !== 'true') return;
  if ((request as unknown as MockInstalled).__mockInstalled) return;
  (request as unknown as MockInstalled).__mockInstalled = true;

  const mock = new MockAdapter(request, { delayResponse: 600 });

  // mutable demo state — let UI changes feel real
  let userState: UserResponse = { ...MOCK_USER };
  let flowerpotState: FlowerpotResponse = { ...MOCK_FLOWERPOT };
  let myDiariesState: MyDiaryResponse[] = [...MOCK_MY_DIARIES];
  let missionsState: MissionsResponse = {
    completed: [...MOCK_MISSIONS.completed],
    inProgress: [...MOCK_MISSIONS.inProgress],
  };
  // 일기 작성·좋아요·공개·댓글이 해당 종류의 첫 진행중 미션을 1 올린다(목표 초과 금지) — Flutter _progressMission 과 대칭
  const progressMission = (type: Mission) => {
    const target = missionsState.inProgress.find((m) => m.type === type);
    if (!target) return;
    missionsState = {
      ...missionsState,
      inProgress: missionsState.inProgress.map((m) =>
        m === target ? { ...m, count: Math.min(m.count + 1, m.max_count) } : m,
      ),
    };
  };
  // 미션 종류별 보상 — 원본 백엔드 MISSION_REWARD(feedDiary-back router/mission.js) 와 같은 표
  const rewardFor = (type: Mission): RewardItem => {
    switch (type) {
      case 'diary':
        return { count: 3, item: 'watering' };
      case 'visible':
        return { count: 3, item: 'love' };
      case 'comment':
        return { count: 2, item: 'watering' };
      case 'like':
        return { count: 1, item: 'love' };
    }
  };
  let nextDiaryIdx = 1100;
  // 나에게 쓰는 편지 — 작성·삭제로 변형(미션과 무관, Flutter _letters 와 대칭). 새 편지 idx 는 시드(1~3) 다음부터
  let lettersState: LetterResponse[] = [...MOCK_LETTERS];
  let nextLetterIdx = MOCK_LETTERS.length + 1;
  // 신고로 차단된 작성자 user_idx — 커뮤니티 목록에서 제외(Flutter _blockedUsers 와 대칭)
  const blockedUsers = new Set<number>();
  // 일기 작성/수정 본문에 #에러 → 다음 일기 상세 GET 1회 실패(ErrorView 시연), 1회 소비 후 해제(Flutter _armedDiaryDetailFault 대칭).
  let armedDiaryDetailFault = false;
  const commentsByDiary: Record<number, CommentResponse[]> = {};
  const deletedFallbackCommentIdx = new Set<number>();
  const getComments = (diaryIdx: number): CommentResponse[] =>
    commentsByDiary[diaryIdx] ?? MOCK_COMMENTS.filter((c) => !deletedFallbackCommentIdx.has(c.idx));
  const getCommentCount = (diaryIdx: number): number => getComments(diaryIdx).length;
  const withCommentCount = <T extends { idx: number }>(d: T): T => ({ ...d, commentCount: getCommentCount(d.idx) });
  // 실서버는 조회 시 user 를 JOIN 해 작성자 정보를 채움 → 내 일기·댓글은 저장 시점 복사본 대신 현재 프로필로 응답
  const myCommentIdx = new Set<number>();
  const withMyNickname = <T extends { nickname: string }>(d: T): T => ({ ...d, nickname: userState.nickname });
  const withMyCommentAuthor = (c: CommentResponse): CommentResponse =>
    myCommentIdx.has(c.idx)
      ? {
          ...c,
          nickname: userState.nickname,
          background: userState.background,
          character: userState.character,
          user_image: userState.image,
        }
      : c;

  const likeByDiary: Record<number, { count: number; liked: boolean }> = {};
  const getLikeState = (idx: number) => {
    if (!likeByDiary[idx]) {
      const seed = MOCK_COMMUNITY_DIARIES.find((d) => d.idx === idx)?.like_count
        ?? myDiariesState.find((d) => d.idx === idx)?.like_count
        ?? 0;
      likeByDiary[idx] = { count: seed, liked: false };
    }
    return likeByDiary[idx];
  };
  const withLikeCount = <T extends { idx: number; like_count: number }>(d: T): T => ({
    ...d,
    like_count: getLikeState(d.idx).count,
  });
  const withLikeAndIsLike = <T extends { idx: number; like_count: number; isLike: boolean }>(d: T): T => {
    const s = getLikeState(d.idx);
    return { ...d, like_count: s.count, isLike: s.liked };
  };

  const toMyDiaryAsCommunity = (idx: number): CommunityDiaryResponse | null => {
    const my = myDiariesState.find((d) => d.idx === idx);
    if (!my) return null;
    const likeState = getLikeState(my.idx);
    return {
      ...my,
      nickname: userState.nickname,
      like_count: likeState.count,
      commentCount: getCommentCount(my.idx),
      user_image: userState.image,
      background: userState.background,
      character: userState.character,
      isLike: likeState.liked,
    };
  };

  // === Auth ===
  mock.onPost('/auth/sign-in').reply(() => [200, okResponse(userState)]);
  mock.onPost('/auth/sign-in-auto/v2').reply(() => [200, okResponse(userState)]);
  mock.onPost('/auth/sign-up').reply(() => [200, okResponse(userState)]);
  mock.onPost('/auth/sign-out').reply(200, okStatus());
  mock.onPost('/auth/check-nickname').reply(200, okStatus());

  // === Diary ===
  mock.onGet('/diary/list').reply((config) => {
    const skip = Number(config.params?.skip ?? 0);
    // 날짜 수정·과거 날짜 작성이 있어도 최신순 — Flutter _listDiaries 와 대칭
    const sorted = [...myDiariesState].sort(
      (a, b) => new Date(b.created_time).getTime() - new Date(a.created_time).getTime(),
    );
    const page = sorted.slice(skip, skip + 10).map(withMyNickname).map(withCommentCount).map(withLikeCount);
    return [200, okResponse(page)];
  });
  mock.onGet(/\/diary\/list-by-month\/[\w-]+$/).reply((config) => {
    const rawMonth = (config.url?.split('/').pop() ?? '').replace('-', '');
    const year = Number(rawMonth.slice(0, 4));
    const month = Number(rawMonth.slice(4, 6));
    const inMonth = myDiariesState
      .filter((d) => {
        const t = new Date(d.created_time);
        return t.getFullYear() === year && t.getMonth() + 1 === month;
      })
      .sort((a, b) => new Date(a.created_time).getTime() - new Date(b.created_time).getTime());
    // 해당 월 본인 일기만 오래된 순으로 반환(없으면 빈 배열) — Flutter DemoApiAdapter._monthlyDiaries 와 대칭
    const dailies: DailyDiaryResponse[] = inMonth.map((d) => ({
      idx: d.idx,
      sticker: d.sticker,
      text: d.text,
      image: d.image,
      created_time: d.created_time,
      updated_time: d.updated_time,
      is_visible: d.is_visible,
    }));
    return [200, okResponse(dailies)];
  });
  mock.onGet('/diary/community-list').reply((config) => {
    const skip = Number(config.params?.skip ?? 0);
    const sortType = config.params?.sort_type === 'popular' ? 'popular' : 'latest';
    // 실서비스와 같이 공개한 내 일기는 시드·새 일기 구분 없이 모두 공유 피드에 노출
    const publishedFromMy: CommunityDiaryResponse[] = myDiariesState
      .filter((d) => d.is_visible === 1)
      .map((d) => ({
        ...d,
        nickname: userState.nickname,
        user_image: userState.image,
        background: userState.background,
        character: userState.character,
        isLike: false,
      }));
    const merged = [...publishedFromMy, ...MOCK_COMMUNITY_DIARIES]
      .filter((d) => !blockedUsers.has(d.user_idx))
      .map(withCommentCount)
      .map(withLikeAndIsLike)
      // 내 일기·타작성자 일기를 합친 뒤 정렬하고 나서 페이징(Flutter DemoApiAdapter._communityList 와 대칭)
      .sort((a, b) =>
        sortType === 'popular'
          ? b.like_count - a.like_count
          : new Date(b.created_time).getTime() - new Date(a.created_time).getTime(),
      );
    return [200, okResponse(merged.slice(skip, skip + 10))];
  });
  mock.onGet(/\/diary\/\d+$/).reply((config) => {
    if (armedDiaryDetailFault) {
      armedDiaryDetailFault = false;
      return [500, failResponse(SERVER_FAULT_MESSAGE)];
    }
    const idx = Number(config.url?.split('/').pop());
    const my = toMyDiaryAsCommunity(idx);
    if (my) return [200, okResponse(my)];
    const community = MOCK_COMMUNITY_DIARIES.find((d) => d.idx === idx);
    // 없거나 삭제된 일기는 404 — Flutter _getDiary 와 대칭(상세 화면은 ErrorView)
    if (!community) return [404, failResponse('일기를 찾을 수 없습니다.')];
    return [200, okResponse(withLikeAndIsLike(withCommentCount(community)))];
  });
  mock.onPost('/diary').reply((config) => {
    const sticker = getString(getFormField(config.data, 'sticker'));
    const text = getString(getFormField(config.data, 'text'));
    if (hasErrorSentinel(text)) {
      armedDiaryDetailFault = true;
      return [500, failResponse(SERVER_FAULT_MESSAGE)];
    }
    const date = getString(getFormField(config.data, 'date')) || new Date().toISOString();
    const image = getImageUri(getFormField(config.data, 'image'));

    nextDiaryIdx += 1;
    const newDiary: MyDiaryResponse = {
      idx: nextDiaryIdx,
      user_idx: userState.idx,
      nickname: userState.nickname,
      sticker,
      text,
      image,
      created_time: date,
      is_visible: 0,
      like_count: 0,
      commentCount: 0,
    };
    myDiariesState = [newDiary, ...myDiariesState];
    progressMission('diary');
    return [200, okResponse({ diaryIdx: newDiary.idx })];
  });
  mock.onPut('/diary').reply((config) => {
    const diaryIdx = getNumber(getFormField(config.data, 'diary_idx'));
    const sticker = getString(getFormField(config.data, 'sticker'));
    const text = getString(getFormField(config.data, 'text'));
    if (hasErrorSentinel(text)) {
      armedDiaryDetailFault = true;
      return [500, failResponse(SERVER_FAULT_MESSAGE)];
    }
    const date = getString(getFormField(config.data, 'date'));
    const newImage = getImageUri(getFormField(config.data, 'image'));
    const imageText = getFormField(config.data, 'image_text');
    const keepExistingImage = typeof imageText === 'string' && imageText !== '';

    myDiariesState = myDiariesState.map((d) => {
      if (d.idx !== diaryIdx) return d;
      return {
        ...d,
        sticker: sticker || d.sticker,
        text: text || d.text,
        image: newImage ?? (keepExistingImage ? d.image : undefined),
        created_time: date || d.created_time,
        updated_time: new Date().toISOString(),
      };
    });
    return [200, okResponse({ diaryIdx })];
  });
  mock.onDelete(/\/diary\/\d+$/).reply((config) => {
    const idx = Number(config.url?.split('/').pop());
    myDiariesState = myDiariesState.filter((d) => d.idx !== idx);
    return [200, okStatus()];
  });
  mock.onPost('/diary/like').reply((config) => {
    const body = JSON.parse(config.data as string);
    const idx = Number(body.diary_idx);
    const state = getLikeState(idx);
    state.liked = !state.liked;
    state.count = Math.max(0, state.count + (state.liked ? 1 : -1));
    // 좋아요 취소는 미션을 되돌리지 않는다(Flutter 와 같음)
    if (state.liked) progressMission('like');
    return [200, okResponse({ like_count: state.count, isLike: state.liked })];
  });
  mock.onPost('/diary/visibility').reply((config) => {
    const body = JSON.parse(config.data as string);
    const idx = Number(body.diary_idx);
    if (!myDiariesState.some((d) => d.idx === idx)) return [404, failResponse('일기를 찾을 수 없습니다.')];
    let nextVisible: 1 | 0 = 1;
    myDiariesState = myDiariesState.map((d) => {
      if (d.idx !== idx) return d;
      nextVisible = d.is_visible === 1 ? 0 : 1;
      return { ...d, is_visible: nextVisible };
    });
    // 비공개 → 공개로 바뀐 경우에만 공개 미션 진행(Flutter 와 같음)
    if (nextVisible === 1) progressMission('visible');
    return [200, okResponse({ is_visible: nextVisible })];
  });
  mock.onPost('/diary/report').reply((config) => {
    const body = JSON.parse(config.data as string);
    if (hasErrorSentinel(body.text)) return [500, failResponse(SERVER_FAULT_MESSAGE)];
    // 신고한 일기의 작성자를 차단 — Flutter 처럼 block_idx 대신 diary_idx 로 작성자를 찾는다
    const diaryIdx = Number(body.diary_idx);
    const reported = [...myDiariesState, ...MOCK_COMMUNITY_DIARIES].find((d) => d.idx === diaryIdx);
    if (reported) blockedUsers.add(reported.user_idx);
    return [200, okStatus()];
  });

  // === Comment ===
  mock.onGet(/\/comment\/list\/\d+$/).reply((config) => {
    const diaryIdx = Number(config.url?.split('/').pop());
    return [200, okResponse(getComments(diaryIdx).map(withMyCommentAuthor))];
  });
  mock.onPost('/comment').reply((config) => {
    const body = JSON.parse(config.data as string);
    if (hasErrorSentinel(body.text)) return [500, failResponse(SERVER_FAULT_MESSAGE)];
    const diaryIdx = Number(body.diary_idx);
    const newComment: CommentResponse = {
      idx: Date.now(),
      nickname: userState.nickname,
      background: userState.background,
      character: userState.character,
      text: body.text,
      created_time: new Date().toISOString(),
      user_image: userState.image,
    };
    commentsByDiary[diaryIdx] = [...getComments(diaryIdx), newComment];
    myCommentIdx.add(newComment.idx);
    progressMission('comment');
    return [200, okStatus()];
  });
  mock.onDelete(/\/comment\/\d+$/).reply((config) => {
    const idx = Number(config.url?.split('/').pop());
    Object.keys(commentsByDiary).forEach((key) => {
      const diaryIdx = Number(key);
      commentsByDiary[diaryIdx] = commentsByDiary[diaryIdx].filter((c) => c.idx !== idx);
    });
    if (MOCK_COMMENTS.some((c) => c.idx === idx)) deletedFallbackCommentIdx.add(idx);
    return [200, okStatus()];
  });

  // === Letter ===
  mock.onGet('/letter/list').reply((config) => {
    const skip = Number(config.params?.skip ?? 0);
    const sorted = [...lettersState].sort(
      (a, b) => new Date(b.created_time).getTime() - new Date(a.created_time).getTime(),
    );
    return [200, okResponse(sorted.slice(skip, skip + 10))];
  });
  mock.onPost('/letter').reply((config) => {
    const body = JSON.parse(config.data as string);
    if (hasErrorSentinel(body.text)) return [500, failResponse(SERVER_FAULT_MESSAGE)];
    const letter: LetterResponse = { idx: nextLetterIdx, text: String(body.text ?? ''), created_time: new Date().toISOString() };
    nextLetterIdx += 1;
    lettersState = [letter, ...lettersState];
    return [200, okResponse(letter)];
  });
  // RN 클라이언트는 삭제 응답을 편지 스키마로 파싱하므로 지운 편지를 돌려준다(없으면 404)
  mock.onDelete(/\/letter\/\d+$/).reply((config) => {
    const idx = Number(config.url?.split('/').pop());
    const deleted = lettersState.find((l) => l.idx === idx);
    if (!deleted) return [404, failResponse('편지를 찾을 수 없습니다.')];
    lettersState = lettersState.filter((l) => l.idx !== idx);
    return [200, okResponse(deleted)];
  });

  // === Flowerpot ===
  // showBadge 는 받을 수 있는(목표 달성한) 진행중 미션이 있는지로 계산 — Flutter _flowerpotJson 과 대칭
  mock.onGet('/flowerpot').reply(() => [
    200,
    okResponse({ ...flowerpotState, showBadge: missionsState.inProgress.some((m) => m.count >= m.max_count) }),
  ]);
  mock.onPost('/flowerpot/watering').reply(() => {
    if (flowerpotState.watering_count > 0) {
      const nextExp = flowerpotState.exp + 10;
      const shouldLevelUp = nextExp >= flowerpotState.max_exp && flowerpotState.level < 3;
      flowerpotState = {
        ...flowerpotState,
        watering_count: flowerpotState.watering_count - 1,
        exp: shouldLevelUp ? nextExp - flowerpotState.max_exp : nextExp,
        level: shouldLevelUp ? flowerpotState.level + 1 : flowerpotState.level,
        max_exp: shouldLevelUp ? flowerpotState.max_exp + 100 : flowerpotState.max_exp,
      };
    }
    return [200, okStatus()];
  });
  mock.onPost('/flowerpot/love').reply(() => {
    if (flowerpotState.love_count > 0) {
      const nextExp = flowerpotState.exp + 5;
      const shouldLevelUp = nextExp >= flowerpotState.max_exp && flowerpotState.level < 3;
      flowerpotState = {
        ...flowerpotState,
        love_count: flowerpotState.love_count - 1,
        exp: shouldLevelUp ? nextExp - flowerpotState.max_exp : nextExp,
        level: shouldLevelUp ? flowerpotState.level + 1 : flowerpotState.level,
        max_exp: shouldLevelUp ? flowerpotState.max_exp + 100 : flowerpotState.max_exp,
      };
    }
    return [200, okStatus()];
  });

  // === Mission ===
  mock.onGet('/mission/list').reply(() => [200, okResponse(missionsState)]);
  // 진행중 미션을 완료로 옮기고 보상 충전을 화분에 더한다. 이미 완료했거나 없는 미션은 404(Flutter _completeMission 과 대칭)
  mock.onPost('/mission').reply((config) => {
    const body = JSON.parse(config.data as string);
    const mission = missionsState.inProgress.find((m) => m.idx === Number(body.mission_idx));
    if (!mission) return [404, failResponse('미션을 찾을 수 없습니다.')];
    missionsState = {
      completed: [{ ...mission, count: mission.max_count, is_completed: 1 }, ...missionsState.completed],
      inProgress: missionsState.inProgress.filter((m) => m !== mission),
    };
    const reward = rewardFor(mission.type);
    const chargeKey = reward.item === 'watering' ? 'watering_count' : 'love_count';
    flowerpotState = { ...flowerpotState, [chargeKey]: flowerpotState[chargeKey] + reward.count };
    const resData: CompleteMissionResponse = { missions: missionsState, reward };
    return [200, okResponse(resData)];
  });

  // === User ===
  mock.onPut('/user').reply((config) => {
    const nickname = getString(getFormField(config.data, 'nickname'), userState.nickname);
    const background = getString(getFormField(config.data, 'background'));
    const character = getString(getFormField(config.data, 'character'));
    const newImageUri = getImageUri(getFormField(config.data, 'image'));

    const image = newImageUri ?? (background && character ? '' : userState.image);

    userState = { ...userState, nickname, image, background, character };
    return [200, okResponse(userState)];
  });
  mock.onDelete('/user').reply(200, okStatus());

  // === etc ===
  mock.onGet('/etc/app-version').reply(200, okResponse(MOCK_APP_VERSION));

  // 정의 안 된 요청은 콘솔에 표시 + 404
  mock.onAny().reply((config) => {
    if (__DEV__) {
      console.warn('[mock] no handler for', config.method?.toUpperCase(), config.url);
    }
    return [404, { status: 'failed', message: 'mock handler not found' }];
  });
};
