import { z } from 'zod';

import { UserDTOSchema, UserResponseSchema } from '@/api/auth/types';

describe('UserResponseSchema', () => {
  it('accepts a minimal payload and coerces created_time to Date', () => {
    const parsed = UserResponseSchema.parse({
      idx: 1,
      account: 'a@b.c',
      user_id: 'demo',
      nickname: 'nick',
      image: '',
      background: '',
      character: '',
      type: 'google',
      created_time: '2026-01-01T00:00:00.000Z',
      token: 't',
    });
    expect(parsed.created_time).toBeInstanceOf(Date);
    expect(parsed.fcm_token).toBeUndefined();
  });

  it('rejects unknown SignInType', () => {
    expect(() =>
      UserResponseSchema.parse({
        idx: 1,
        account: '',
        user_id: '',
        nickname: '',
        image: '',
        background: '',
        character: '',
        type: 'kakao',
        created_time: new Date(),
        token: '',
      }),
    ).toThrow(z.ZodError);
  });
});

describe('UserDTOSchema (transform)', () => {
  it('maps snake_case to camelCase and preserves optional fcmToken', () => {
    const dto = UserDTOSchema.parse({
      idx: 7,
      account: 'a@b.c',
      user_id: 'snake_user',
      nickname: '새싹이',
      image: 'img.png',
      background: '#fff',
      character: 'Chick',
      type: 'apple',
      created_time: '2026-05-27T00:00:00Z',
      token: 'tok',
      fcm_token: 'fcm',
    });
    expect(dto.userId).toBe('snake_user');
    expect(dto.createdAt).toBeInstanceOf(Date);
    expect(dto.fcmToken).toBe('fcm');
    expect(dto.type).toBe('apple');
    expect((dto as unknown as Record<string, unknown>).user_id).toBeUndefined();
    expect((dto as unknown as Record<string, unknown>).created_time).toBeUndefined();
  });
});
