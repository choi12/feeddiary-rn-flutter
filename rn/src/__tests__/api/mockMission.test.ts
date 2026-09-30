// 데모 mock 미션 테스트 — 일기·좋아요·공개·댓글이 미션을 진행시키고, 완료 보상이 화분에 한 번만 들어가는지(Flutter DemoApiAdapter 규칙)
import { APICreateComment } from '@/api/comment/APICreateComment';
import { APICreateDiary } from '@/api/diary/APICreateDiary';
import { APILikeDiary } from '@/api/diary/APILikeDiary';
import { APISetVisibility } from '@/api/diary/APISetVisibility';
import { APIGetFlowerpot } from '@/api/flowerpot/APIGetFlowerpot';
import { APICompleteMission } from '@/api/mission/APICompleteMission';
import { APIGetMissions } from '@/api/mission/APIGetMissions';
import { setupMockAdapter } from '@/api/mock';
import { MOCK_COMMUNITY_DIARIES, MOCK_MY_DIARIES } from '@/api/mock/data';
import { Mission } from '@/types/mission';

jest.mock('react-native-config', () => ({ __esModule: true, default: { USE_MOCK: 'true' } }));

const inProgressCount = async (type: Mission) =>
  (await APIGetMissions()).inProgress.find((m) => m.type === type)?.count;

const buildFormData = (fields: Record<string, string>) => {
  const formData = new FormData();
  Object.entries(fields).forEach(([key, value]) => formData.append(key, value));
  return formData;
};

// 모듈 상태가 테스트 사이에 이어지므로 순서대로 실행되는 시나리오로 둔다(시드: diary 1/1 완료 · comment 1/3 · visible 0/1 · like 2/5)
describe('mock adapter — missions', () => {
  beforeAll(() => setupMockAdapter());

  it('keeps the completed diary mission out of progress when writing a diary', async () => {
    await APICreateDiary({
      diaryFormData: buildFormData({ sticker: 'Star', text: '미션 일기', date: new Date().toISOString() }),
    });
    const missions = await APIGetMissions();
    expect(missions.inProgress.some((m) => m.type === 'diary')).toBe(false);
    expect(missions.completed.find((m) => m.type === 'diary')).toMatchObject({ count: 1, maxCount: 1 });
  });

  it('raises the like mission on like but not on unlike', async () => {
    const diaryIdx = MOCK_COMMUNITY_DIARIES[0].idx;
    expect(await inProgressCount('like')).toBe(2);

    await APILikeDiary({ diaryIdx });
    expect(await inProgressCount('like')).toBe(3);

    await APILikeDiary({ diaryIdx });
    expect(await inProgressCount('like')).toBe(3);
  });

  it('raises the visible mission only when a diary turns public', async () => {
    const privateSeedIdx = MOCK_MY_DIARIES.find((d) => d.is_visible === 0)?.idx ?? -1;
    const publicSeedIdx = MOCK_MY_DIARIES.find((d) => d.is_visible === 1)?.idx ?? -1;
    expect(await inProgressCount('visible')).toBe(0);

    await APISetVisibility({ diaryIdx: publicSeedIdx }); // 공개 → 비공개
    expect(await inProgressCount('visible')).toBe(0);

    await APISetVisibility({ diaryIdx: privateSeedIdx }); // 비공개 → 공개
    expect(await inProgressCount('visible')).toBe(1);
  });

  it('raises the comment mission on comment create', async () => {
    expect(await inProgressCount('comment')).toBe(1);
    await APICreateComment({ diaryIdx: MOCK_COMMUNITY_DIARIES[0].idx, text: '미션 댓글' });
    expect(await inProgressCount('comment')).toBe(2);
  });

  it('completes a mission once and adds its reward to the flowerpot', async () => {
    const visible = (await APIGetMissions()).inProgress.find((m) => m.type === 'visible');
    expect(visible).toBeDefined();
    const before = await APIGetFlowerpot();
    expect(before.showBadge).toBe(true);

    const { reward, missions } = await APICompleteMission({ missionIdx: visible?.idx ?? -1, type: 'visible' });
    expect(reward).toEqual({ count: 3, item: 'love' });
    expect(missions.inProgress.some((m) => m.type === 'visible')).toBe(false);
    expect(missions.completed[0]).toMatchObject({ idx: visible?.idx, count: 1, is_completed: 1 });

    const after = await APIGetFlowerpot();
    expect(after.loveCount).toBe(before.loveCount + 3);
    expect(after.wateringCount).toBe(before.wateringCount);
    // 남은 진행중 미션(comment 2/3 · like 3/5)은 받을 게 없으므로 배지가 꺼진다
    expect(after.showBadge).toBe(false);

    await expect(APICompleteMission({ missionIdx: visible?.idx ?? -1, type: 'visible' })).rejects.toBeDefined();
    expect((await APIGetFlowerpot()).loveCount).toBe(after.loveCount);
  });

  // 보상 표는 원본 백엔드 MISSION_REWARD 와 같다(diary 는 시드에서 이미 완료라 여기서 못 받음)
  it('pays the backend reward table for comment and like', async () => {
    const { inProgress } = await APIGetMissions();
    const idxOf = (type: Mission) => inProgress.find((m) => m.type === type)?.idx ?? -1;

    expect((await APICompleteMission({ missionIdx: idxOf('comment'), type: 'comment' })).reward).toEqual({
      count: 2,
      item: 'watering',
    });
    expect((await APICompleteMission({ missionIdx: idxOf('like'), type: 'like' })).reward).toEqual({
      count: 1,
      item: 'love',
    });
  });
});
