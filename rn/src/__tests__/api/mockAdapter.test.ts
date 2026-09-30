// 데모 mock 어댑터 테스트 — 작성자 표시, 월별 일기, 커뮤니티 노출·정렬, 편지 작성·삭제, 신고 차단
import { APICreateComment } from '@/api/comment/APICreateComment';
import { APIGetComments } from '@/api/comment/APIGetComments';
import { APIGetCommunityDiaries } from '@/api/community/APIGetCommunityDiaries';
import { APIReportDiary } from '@/api/community/APIReportDiary';
import { CommunityDiaryDTO } from '@/api/community/types';
import { APICreateDiary } from '@/api/diary/APICreateDiary';
import { APIEditDiary } from '@/api/diary/APIEditDiary';
import { APIGetDiaries } from '@/api/diary/APIGetDiaries';
import { APIGetDiary } from '@/api/diary/APIGetDiary';
import { APIGetMonthlyDiaries } from '@/api/diary/APIGetMonthlyDiaries';
import { APISetVisibility } from '@/api/diary/APISetVisibility';
import { APICreateLetter } from '@/api/letter/APICreateLetter';
import { APIDeleteLetter } from '@/api/letter/APIDeleteLetter';
import { APIGetLetters } from '@/api/letter/APIGetLetters';
import { setupMockAdapter } from '@/api/mock';
import { MOCK_COMMUNITY_DIARIES, MOCK_MY_DIARIES, MOCK_USER } from '@/api/mock/data';
import { APIUpdateProfile } from '@/api/user/APIUpdateProfile';
import { CommunitySort } from '@/types/community';

jest.mock('react-native-config', () => ({ __esModule: true, default: { USE_MOCK: 'true' } }));

const NEW_NICKNAME = '바뀐닉네임';

const buildFormData = (fields: Record<string, string>) => {
  const formData = new FormData();
  Object.entries(fields).forEach(([key, value]) => formData.append(key, value));
  return formData;
};

describe('mock adapter — author nickname', () => {
  beforeAll(() => setupMockAdapter());

  it('reports the current nickname on my diary and comment after renaming', async () => {
    const { diaryIdx } = await APICreateDiary({
      diaryFormData: buildFormData({ sticker: 'Star', text: '내 일기', date: new Date().toISOString() }),
    });
    await APICreateComment({ diaryIdx, text: '내 댓글' });

    await APIUpdateProfile({
      updateProfileFormData: buildFormData({ nickname: NEW_NICKNAME, background: '#FFE4B5', character: 'Chick' }),
    });

    const diary = await APIGetDiary({ diaryIdx });
    expect(diary.nickname).toBe(NEW_NICKNAME);

    const comments = await APIGetComments({ diaryIdx });
    const myComment = comments.find((c) => c.text === '내 댓글');
    expect(myComment?.nickname).toBe(NEW_NICKNAME);
    expect(comments.filter((c) => c.text !== '내 댓글').every((c) => c.nickname !== NEW_NICKNAME)).toBe(true);
  });
});

describe('mock adapter — monthly diaries', () => {
  beforeAll(() => setupMockAdapter());

  it('returns an empty list for a month without my diaries instead of another month\'s seed', async () => {
    const diaries = await APIGetMonthlyDiaries({ month: '2026-02' });
    expect(diaries).toEqual([]);
  });

  it('returns only diaries created in the requested month', async () => {
    const diaries = await APIGetMonthlyDiaries({ month: '2026-05' });
    expect(diaries.length).toBeGreaterThan(0);
    expect(diaries.every((d) => new Date(d.createdAt).getFullYear() === 2026 && new Date(d.createdAt).getMonth() === 4)).toBe(
      true,
    );
  });
});

// 페이지 크기에 기대지 않도록 빈 페이지가 나올 때까지 모은다
const collectCommunityFeed = async (sortType: CommunitySort) => {
  const all: CommunityDiaryDTO[] = [];
  for (let skip = 0; ; skip += 10) {
    const page = await APIGetCommunityDiaries({ skip, sortType });
    if (page.length === 0) return all;
    all.push(...page);
  }
};

describe('mock adapter — my public diaries in community feed', () => {
  beforeAll(() => setupMockAdapter());

  const communityIdxList = async () => (await collectCommunityFeed('latest')).map((d) => d.idx);

  it('lists a public seed diary of mine from the start', async () => {
    const publicSeed = MOCK_MY_DIARIES.find((d) => d.is_visible === 1);
    expect(await communityIdxList()).toContain(publicSeed?.idx);
  });

  it('adds a private seed diary when made public and removes it when made private again', async () => {
    const privateSeedIdx = MOCK_MY_DIARIES.find((d) => d.is_visible === 0)?.idx ?? -1;
    expect(await communityIdxList()).not.toContain(privateSeedIdx);

    await APISetVisibility({ diaryIdx: privateSeedIdx });
    expect(await communityIdxList()).toContain(privateSeedIdx);

    await APISetVisibility({ diaryIdx: privateSeedIdx });
    expect(await communityIdxList()).not.toContain(privateSeedIdx);
  });
});

describe('mock adapter — community feed sort', () => {
  beforeAll(() => setupMockAdapter());

  const isNonIncreasing = (values: number[]) => values.every((v, i) => i === 0 || values[i - 1] >= v);

  it('orders latest by created time across my diaries and others', async () => {
    const feed = await collectCommunityFeed('latest');
    expect(isNonIncreasing(feed.map((d) => new Date(d.createdAt).getTime()))).toBe(true);

    // 내 일기가 앞에 몰리지 않고 날짜순으로 다른 사람 일기와 섞여야 한다(내 것/남의 것 전환이 여러 번)
    const isMine = feed.map((d) => d.userIdx === MOCK_USER.idx);
    const switches = isMine.filter((mine, i) => i > 0 && mine !== isMine[i - 1]).length;
    expect(switches).toBeGreaterThan(1);
  });

  it('orders popular by like count', async () => {
    const feed = await collectCommunityFeed('popular');
    expect(feed.length).toBeGreaterThan(0);
    expect(isNonIncreasing(feed.map((d) => d.likeCount))).toBe(true);
  });
});

describe('mock adapter — letters', () => {
  beforeAll(() => setupMockAdapter());

  it('lists a written letter first and drops it after delete', async () => {
    const written = await APICreateLetter({ text: '새 편지' });
    const listed = await APIGetLetters({ skip: 0 });
    expect(listed[0]).toMatchObject({ idx: written.idx, text: '새 편지' });

    await APIDeleteLetter({ letterIdx: written.idx });
    expect((await APIGetLetters({ skip: 0 })).map((l) => l.idx)).not.toContain(written.idx);
  });
});

describe('mock adapter — report blocks author', () => {
  beforeAll(() => setupMockAdapter());

  it('hides the reported author\'s diaries from the community feed and keeps the rest', async () => {
    const reported = MOCK_COMMUNITY_DIARIES[0];
    const before = await collectCommunityFeed('latest');
    expect(before.some((d) => d.userIdx === reported.user_idx)).toBe(true);

    await APIReportDiary({ diaryIdx: reported.idx, text: '신고 사유', blockIdx: reported.user_idx });

    const after = await collectCommunityFeed('latest');
    expect(after.some((d) => d.userIdx === reported.user_idx)).toBe(false);
    expect(after).toEqual(before.filter((d) => d.userIdx !== reported.user_idx));
  });
});

describe('mock adapter — my diary ordering and missing diaries', () => {
  beforeAll(() => setupMockAdapter());

  const times = (items: { createdAt: string }[]) => items.map((d) => new Date(d.createdAt).getTime());

  it('returns a month oldest first so the calendar auto-selects the earliest day', async () => {
    const diaries = await APIGetMonthlyDiaries({ month: '2026-05' });
    expect(diaries.length).toBeGreaterThan(1);
    expect(times(diaries)).toEqual([...times(diaries)].sort((a, b) => a - b));
  });

  it('re-sorts my diary list newest first after a date edit', async () => {
    const oldest = MOCK_MY_DIARIES[MOCK_MY_DIARIES.length - 1];
    await APIEditDiary({
      diaryFormData: buildFormData({ diary_idx: String(oldest.idx), date: '2030-01-01T00:00:00.000Z' }),
    });

    const page = await APIGetDiaries({ skip: 0 });
    expect(page[0].idx).toBe(oldest.idx);
    expect(times(page)).toEqual([...times(page)].sort((a, b) => b - a));
  });

  it('rejects detail and visibility for an unknown diary', async () => {
    await expect(APIGetDiary({ diaryIdx: 999999 })).rejects.toBeDefined();
    await expect(APISetVisibility({ diaryIdx: 999999 })).rejects.toBeDefined();
  });
});
