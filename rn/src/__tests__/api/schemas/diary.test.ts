import { z } from 'zod';

import {
  DailyDiariesDTOSchema,
  LikeDiaryDTOSchema,
  MyDiariesDTOSchema,
  MyDiaryDTOSchema,
  SetVisibilityDTOSchema,
} from '@/api/diary/types';

const validMyDiary = {
  idx: 1001,
  user_idx: 1,
  nickname: '새싹이',
  sticker: 'Sunny',
  text: 'hi',
  created_time: '2026-05-27T00:00:00Z',
  is_visible: 1 as const,
  like_count: 3,
  commentCount: 2,
};

describe('MyDiaryDTOSchema', () => {
  it('renames snake_case keys and drops the response-side originals', () => {
    const dto = MyDiaryDTOSchema.parse(validMyDiary);
    expect(dto.userIdx).toBe(1);
    expect(dto.createdAt).toBe('2026-05-27T00:00:00Z');
    expect(dto.isVisible).toBe(1);
    expect(dto.likeCount).toBe(3);
    expect(dto.commentCount).toBe(2);
    expect((dto as unknown as Record<string, unknown>).user_idx).toBeUndefined();
    expect((dto as unknown as Record<string, unknown>).deleted_time).toBeUndefined();
  });

  it('rejects is_visible outside {0,1}', () => {
    expect(() => MyDiaryDTOSchema.parse({ ...validMyDiary, is_visible: 2 })).toThrow(z.ZodError);
  });
});

describe('MyDiariesDTOSchema (array)', () => {
  it('parses an array end-to-end', () => {
    const arr = MyDiariesDTOSchema.parse([validMyDiary, { ...validMyDiary, idx: 1002 }]);
    expect(arr).toHaveLength(2);
    expect(arr[1].idx).toBe(1002);
  });
});

describe('DailyDiariesDTOSchema', () => {
  it('drops fields not present in DailyDiaryResponse and renames the rest', () => {
    const arr = DailyDiariesDTOSchema.parse([
      { idx: 1, sticker: 'S', text: 't', created_time: '2026-05-27', is_visible: 0 },
    ]);
    expect(arr[0].isVisible).toBe(0);
    expect(arr[0].createdAt).toBe('2026-05-27');
  });
});

describe('LikeDiaryDTOSchema', () => {
  it('renames like_count and keeps isLike as boolean', () => {
    const dto = LikeDiaryDTOSchema.parse({ like_count: 5, isLike: true });
    expect(dto.likeCount).toBe(5);
    expect(dto.isLike).toBe(true);
  });
});

describe('SetVisibilityDTOSchema', () => {
  it('renames is_visible to isVisible', () => {
    const dto = SetVisibilityDTOSchema.parse({ is_visible: 1 });
    expect(dto.isVisible).toBe(1);
  });
});
