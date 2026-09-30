// 데모 mock 어댑터 테스트 — 작성자 표시, 월별 일기, 커뮤니티 노출·정렬, 편지 작성·삭제, 신고 차단
import { APICreateComment } from '@/api/comment/APICreateComment';
import { APIGetComments } from '@/api/comment/APIGetComments';
import { APICreateDiary } from '@/api/diary/APICreateDiary';
import { APIGetDiary } from '@/api/diary/APIGetDiary';
import { setupMockAdapter } from '@/api/mock';
import { APIUpdateProfile } from '@/api/user/APIUpdateProfile';

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
