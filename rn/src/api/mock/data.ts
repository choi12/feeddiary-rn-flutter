import type { CommunityDiaryResponse } from '@/api/community/types';
import type { CommentResponse } from '@/api/comment/types';
import type { MyDiaryResponse, DailyDiaryResponse, CreateDiaryResponse } from '@/api/diary/types';
import type { LetterResponse } from '@/api/letter/types';
import type { MissionResponse, MissionsResponse, CompleteMissionResponse } from '@/api/mission/types';
import type { UserResponse } from '@/api/auth/types';
import type { FlowerpotResponse } from '@/api/flowerpot/types';

const NOW = '2026-05-27T10:00:00.000Z';

export const MOCK_USER: UserResponse = {
  idx: 1,
  account: 'demo@example.com',
  user_id: 'demo_user_1',
  nickname: '새싹이',
  image: '',
  background: '#FFE4B5',
  character: 'Chick',
  type: 'google',
  created_time: new Date('2026-01-01T00:00:00.000Z'),
  token: 'mock_jwt_token',
  fcm_token: 'mock_fcm_token',
};

const COMMUNITY_NICKNAMES = [
  '하늘이',
  '구름이',
  '바람이',
  '햇살이',
  '별빛이',
  '달빛이',
  '봄날이',
  '꽃잎이',
  '나무늘보',
  '솜사탕',
];
const COMMUNITY_CHARACTERS = ['Dog', 'Rabbit', 'Panda', 'Fox', 'Hamster', 'Frog', 'Chick', 'Hedgehog'];
const COMMUNITY_BACKGROUNDS = ['#FFD93D', '#B5E4FF', '#D5B5FF', '#B5FFD5', '#FFB5D5', '#FFDEAD', '#C5FFC5'];
const COMMUNITY_USER_IMAGES = Array.from({ length: 10 }, (_, i) => `https://i.pravatar.cc/200?u=community-${i + 1}`);
const COMMUNITY_DIARY_IMAGES: Record<number, string> = {
  2: 'https://images.unsplash.com/photo-1493612276216-ee3925520721?w=800&q=80',
};

export const MOCK_FLOWERPOT: FlowerpotResponse = {
  level: 1,
  exp: 20,
  max_exp: 100,
  watering_count: 5,
  love_count: 3,
  showBadge: true,
};

const STICKERS = ['CloudSun', 'Star', 'Snow', 'Sunny', 'Smile', 'Happiness'];
const TEXTS = [
  '오늘은 정말 좋은 하루였다. 햇살이 따뜻하고 바람도 시원했다.',
  '비가 종일 내렸지만 카페에서 책 읽기 좋았다.',
  '친구들과 오랜만에 만나서 즐거운 시간을 보냈다.',
  '작은 식물 하나를 들였다. 이름은 콩이.',
];

const makeDiary = (idx: number): MyDiaryResponse => ({
  idx,
  user_idx: 1,
  nickname: MOCK_USER.nickname,
  sticker: STICKERS[idx % STICKERS.length],
  text: TEXTS[idx % TEXTS.length],
  image: undefined,
  created_time: new Date(2026, 4, 27 - (idx % 30)).toISOString(),
  is_visible: idx % 3 === 0 ? 0 : 1,
  like_count: (idx * 3) % 17,
  commentCount: (idx * 2) % 11,
});

const MY_DIARY_DATES = [
  '2026-05-25',
  '2026-05-21',
  '2026-05-16',
  '2026-05-11',
  '2026-05-05',
  '2026-04-28',
  '2026-04-22',
  '2026-04-15',
  '2026-04-08',
  '2026-03-30',
  '2026-03-22',
  '2026-03-14',
];

export const MOCK_MY_DIARIES: MyDiaryResponse[] = MY_DIARY_DATES.map((date, i) => ({
  idx: 1001 + i,
  user_idx: 1,
  nickname: MOCK_USER.nickname,
  sticker: STICKERS[i % STICKERS.length],
  text: TEXTS[i % TEXTS.length],
  image: undefined,
  created_time: new Date(date).toISOString(),
  is_visible: i % 3 === 0 ? 0 : 1,
  like_count: (i * 3) % 17,
  commentCount: (i * 2) % 11,
}));

const makeCommunityDiary = (idx: number): CommunityDiaryResponse => ({
  ...makeDiary(idx),
  image: COMMUNITY_DIARY_IMAGES[idx],
  user_idx: 100 + (idx % COMMUNITY_NICKNAMES.length),
  nickname: COMMUNITY_NICKNAMES[idx % COMMUNITY_NICKNAMES.length],
  user_image: idx % 3 === 0 ? '' : COMMUNITY_USER_IMAGES[idx % COMMUNITY_USER_IMAGES.length],
  background: COMMUNITY_BACKGROUNDS[idx % COMMUNITY_BACKGROUNDS.length],
  character: COMMUNITY_CHARACTERS[idx % COMMUNITY_CHARACTERS.length],
  isLike: idx % 4 === 0,
});

export const MOCK_COMMUNITY_DIARIES: CommunityDiaryResponse[] = Array.from({ length: 30 }, (_, i) =>
  makeCommunityDiary(i + 1),
);

export const MOCK_DAILY_DIARIES_BY_MONTH: Record<string, DailyDiaryResponse[]> = {
  '202605': Array.from({ length: 8 }, (_, i) => ({
    idx: 1001 + i,
    sticker: STICKERS[i % STICKERS.length],
    text: TEXTS[i % TEXTS.length],
    created_time: new Date(2026, 4, (i + 1) * 3).toISOString(),
    is_visible: i % 3 === 0 ? 0 : 1,
  })),
};

export const MOCK_LETTERS: LetterResponse[] = Array.from({ length: 3 }, (_, i) => ({
  idx: i + 1,
  text: `오늘 나에게 보내는 작은 편지 ${i + 1}: 잘하고 있어, 천천히 가도 괜찮아.`,
  created_time: new Date(2026, 4, 27 - (i % 25)).toISOString(),
}));

export const MOCK_COMMENTS: CommentResponse[] = Array.from({ length: 6 }, (_, i) => ({
  idx: i + 1,
  nickname: COMMUNITY_NICKNAMES[i % COMMUNITY_NICKNAMES.length],
  background: COMMUNITY_BACKGROUNDS[i % COMMUNITY_BACKGROUNDS.length],
  character: COMMUNITY_CHARACTERS[i % COMMUNITY_CHARACTERS.length],
  text: ['공감되네요', '오늘도 화이팅', '저도 그런 날 있어요', '응원합니다', '같이 힘내요', '글이 따뜻해요'][i],
  created_time: new Date(2026, 4, 27 - i).toISOString(),
  user_image: i % 2 === 0 ? '' : COMMUNITY_USER_IMAGES[i % COMMUNITY_USER_IMAGES.length],
}));

const mkMission = (idx: number, type: MissionResponse['type'], count: number, max: number): MissionResponse => ({
  idx,
  type,
  count,
  max_count: max,
  is_completed: count >= max ? 1 : 0,
});

export const MOCK_MISSIONS: MissionsResponse = {
  completed: [mkMission(1, 'diary', 5, 5)],
  inProgress: [mkMission(2, 'comment', 1, 3), mkMission(3, 'visible', 0, 1), mkMission(4, 'like', 2, 5)],
};

export const MOCK_COMPLETE_MISSION: CompleteMissionResponse = {
  missions: MOCK_MISSIONS,
  reward: { count: 1, item: 'watering' },
};

export const MOCK_CREATE_DIARY: CreateDiaryResponse = { diaryIdx: 999 };

export const MOCK_APP_VERSION = {
  app_version_android: '0.0.1',
  app_version_ios: '0.0.1',
};
