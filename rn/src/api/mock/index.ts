import MockAdapter from 'axios-mock-adapter';
import Config from 'react-native-config';

import type { UserResponse } from '@/api/auth/types';
import type { CommentResponse } from '@/api/comment/types';
import type { CommunityDiaryResponse } from '@/api/community/types';
import type { DailyDiaryResponse, MyDiaryResponse } from '@/api/diary/types';
import type { FlowerpotResponse } from '@/api/flowerpot/types';

import request from '../request';

import {
  MOCK_APP_VERSION,
  MOCK_COMMENTS,
  MOCK_COMMUNITY_DIARIES,
  MOCK_COMPLETE_MISSION,
  MOCK_DAILY_DIARIES_BY_MONTH,
  MOCK_FLOWERPOT,
  MOCK_LETTERS,
  MOCK_MISSIONS,
  MOCK_MY_DIARIES,
  MOCK_USER,
} from './data';
import { getFormField, getImageUri, getNumber, getString } from './helpers';

const okResponse = <T>(resData: T) => ({ status: 'success' as const, resData });
const okStatus = () => ({ status: 'success' as const });

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
  let nextDiaryIdx = 1100;
  const commentsByDiary: Record<number, CommentResponse[]> = {};
  const deletedFallbackCommentIdx = new Set<number>();
  const getComments = (diaryIdx: number): CommentResponse[] =>
    commentsByDiary[diaryIdx] ?? MOCK_COMMENTS.filter((c) => !deletedFallbackCommentIdx.has(c.idx));
  const getCommentCount = (diaryIdx: number): number => getComments(diaryIdx).length;
  const withCommentCount = <T extends { idx: number }>(d: T): T => ({ ...d, commentCount: getCommentCount(d.idx) });

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
    const page = myDiariesState.slice(skip, skip + 10).map(withCommentCount).map(withLikeCount);
    return [200, okResponse(page)];
  });
  mock.onGet(/\/diary\/list-by-month\/[\w-]+$/).reply((config) => {
    const rawMonth = (config.url?.split('/').pop() ?? '').replace('-', '');
    const year = Number(rawMonth.slice(0, 4));
    const month = Number(rawMonth.slice(4, 6));
    const inMonth = myDiariesState.filter((d) => {
      const t = new Date(d.created_time);
      return t.getFullYear() === year && t.getMonth() + 1 === month;
    });
    const dailies: DailyDiaryResponse[] =
      inMonth.length > 0
        ? inMonth.map((d) => ({
            idx: d.idx,
            sticker: d.sticker,
            text: d.text,
            image: d.image,
            created_time: d.created_time,
            updated_time: d.updated_time,
            is_visible: d.is_visible,
          }))
        : MOCK_DAILY_DIARIES_BY_MONTH[rawMonth] ?? MOCK_DAILY_DIARIES_BY_MONTH['202605'];
    return [200, okResponse(dailies)];
  });
  mock.onGet('/diary/community-list').reply((config) => {
    const skip = Number(config.params?.skip ?? 0);
    const publishedFromMy: CommunityDiaryResponse[] = myDiariesState
      .filter((d) => d.is_visible === 1 && d.idx >= 1100)
      .map((d) => ({
        ...d,
        user_image: userState.image,
        background: userState.background,
        character: userState.character,
        isLike: false,
      }));
    const merged = [...publishedFromMy, ...MOCK_COMMUNITY_DIARIES]
      .map(withCommentCount)
      .map(withLikeAndIsLike);
    return [200, okResponse(merged.slice(skip, skip + 10))];
  });
  mock.onGet(/\/diary\/\d+$/).reply((config) => {
    const idx = Number(config.url?.split('/').pop());
    const my = toMyDiaryAsCommunity(idx);
    if (my) return [200, okResponse(my)];
    const community = MOCK_COMMUNITY_DIARIES.find((d) => d.idx === idx) ?? MOCK_COMMUNITY_DIARIES[0];
    return [200, okResponse(withLikeAndIsLike(withCommentCount(community)))];
  });
  mock.onPost('/diary').reply((config) => {
    const sticker = getString(getFormField(config.data, 'sticker'));
    const text = getString(getFormField(config.data, 'text'));
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
    return [200, okResponse({ diaryIdx: newDiary.idx })];
  });
  mock.onPut('/diary').reply((config) => {
    const diaryIdx = getNumber(getFormField(config.data, 'diary_idx'));
    const sticker = getString(getFormField(config.data, 'sticker'));
    const text = getString(getFormField(config.data, 'text'));
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
    return [200, okResponse({ like_count: state.count, isLike: state.liked })];
  });
  mock.onPost('/diary/visibility').reply((config) => {
    const body = JSON.parse(config.data as string);
    const idx = Number(body.diary_idx);
    let nextVisible: 1 | 0 = 1;
    myDiariesState = myDiariesState.map((d) => {
      if (d.idx !== idx) return d;
      nextVisible = d.is_visible === 1 ? 0 : 1;
      return { ...d, is_visible: nextVisible };
    });
    return [200, okResponse({ is_visible: nextVisible })];
  });
  mock.onPost('/diary/report').reply(200, okStatus());

  // === Comment ===
  mock.onGet(/\/comment\/list\/\d+$/).reply((config) => {
    const diaryIdx = Number(config.url?.split('/').pop());
    return [200, okResponse(getComments(diaryIdx))];
  });
  mock.onPost('/comment').reply((config) => {
    const body = JSON.parse(config.data as string);
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
    return [200, okResponse(MOCK_LETTERS.slice(skip, skip + 6))];
  });
  mock.onPost('/letter').reply(200, okResponse(MOCK_LETTERS[0]));
  mock.onDelete(/\/letter\/\d+$/).reply(200, okResponse(MOCK_LETTERS[0]));

  // === Flowerpot ===
  mock.onGet('/flowerpot').reply(() => [200, okResponse(flowerpotState)]);
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
  mock.onGet('/mission/list').reply(200, okResponse(MOCK_MISSIONS));
  mock.onPost('/mission').reply(200, okResponse(MOCK_COMPLETE_MISSION));

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

  // === Error 시연 (A-10 ErrorView 데모용) ===
  mock.onGet('/_demo/error-unauthorized').reply(401);
  mock.onGet('/_demo/error-timeout').timeout();
  mock.onGet('/_demo/error-network').networkError();

  // 정의 안 된 요청은 콘솔에 표시 + 404
  mock.onAny().reply((config) => {
    if (__DEV__) {
      console.warn('[mock] no handler for', config.method?.toUpperCase(), config.url);
    }
    return [404, { status: 'failed', message: 'mock handler not found' }];
  });
};
