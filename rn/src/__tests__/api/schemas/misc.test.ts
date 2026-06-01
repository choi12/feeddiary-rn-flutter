import { CommentDTOSchema, CommentsDTOSchema } from '@/api/comment/types';
import { CommunityDiaryDTOSchema } from '@/api/community/types';
import { FlowerpotDTOSchema } from '@/api/flowerpot/types';
import { LetterDTOSchema } from '@/api/letter/types';
import { MissionsDTOSchema } from '@/api/mission/types';

describe('FlowerpotDTOSchema', () => {
  it('renames the snake_case counters', () => {
    const dto = FlowerpotDTOSchema.parse({
      level: 1,
      exp: 10,
      max_exp: 100,
      watering_count: 5,
      love_count: 3,
      showBadge: true,
    });
    expect(dto.maxExp).toBe(100);
    expect(dto.wateringCount).toBe(5);
    expect(dto.loveCount).toBe(3);
  });
});

describe('CommentDTOSchema / CommentsDTOSchema', () => {
  const comment = {
    idx: 1,
    nickname: 'n',
    background: '#fff',
    character: 'Dog',
    text: 'hi',
    created_time: '2026-05-27',
    user_image: 'img.png',
  };

  it('renames created_time and user_image', () => {
    const dto = CommentDTOSchema.parse(comment);
    expect(dto.createdAt).toBe('2026-05-27');
    expect(dto.userImage).toBe('img.png');
  });

  it('parses an array of comments', () => {
    const arr = CommentsDTOSchema.parse([comment, { ...comment, idx: 2 }]);
    expect(arr.map((c) => c.idx)).toEqual([1, 2]);
  });
});

describe('LetterDTOSchema', () => {
  it('drops deleted_time and renames created_time', () => {
    const dto = LetterDTOSchema.parse({
      idx: 1,
      text: 'letter',
      created_time: '2026-05-27',
      deleted_time: '2026-06-01',
    });
    expect(dto.createdAt).toBe('2026-05-27');
    expect((dto as unknown as Record<string, unknown>).deleted_time).toBeUndefined();
  });
});

describe('CommunityDiaryDTOSchema', () => {
  it('merges diary + community fields with rename', () => {
    const dto = CommunityDiaryDTOSchema.parse({
      idx: 1,
      user_idx: 100,
      nickname: 'guest',
      sticker: 'S',
      text: 't',
      created_time: '2026-05-27',
      is_visible: 1,
      like_count: 2,
      commentCount: 0,
      user_image: 'avatar.png',
      background: '#fff',
      character: 'Fox',
      isLike: true,
    });
    expect(dto.userImage).toBe('avatar.png');
    expect(dto.userIdx).toBe(100);
    expect(dto.isLike).toBe(true);
  });
});

describe('MissionsDTOSchema (nested transform)', () => {
  it('maps both `completed` and `inProgress` arrays', () => {
    const dto = MissionsDTOSchema.parse({
      completed: [{ idx: 1, type: 'diary', count: 5, max_count: 5, is_completed: 1 }],
      inProgress: [
        { idx: 2, type: 'comment', count: 1, max_count: 3, is_completed: 0 },
        { idx: 3, type: 'like', count: 0, max_count: 5, is_completed: 0 },
      ],
    });
    expect(dto.completed[0].maxCount).toBe(5);
    expect(dto.completed[0].isCompleted).toBe(1);
    expect(dto.inProgress).toHaveLength(2);
    expect(dto.inProgress[1].type).toBe('like');
  });
});
