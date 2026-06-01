import * as Keychain from 'react-native-keychain';

import {
  clearAccessToken,
  getAccessToken,
  loadAccessToken,
  setAccessToken,
} from '@/utils/storage/auth';

const SERVICE = 'feeddiary.accessToken';

beforeEach(async () => {
  (Keychain as unknown as { __resetStore: () => void }).__resetStore();
  await loadAccessToken();
});

describe('auth storage (Keychain-backed)', () => {
  it('loadAccessToken returns null when the Keychain is empty', async () => {
    await loadAccessToken();
    expect(getAccessToken()).toBeNull();
  });

  it('setAccessToken caches in memory AND writes to the Keychain', async () => {
    await setAccessToken('abc123');
    expect(getAccessToken()).toBe('abc123');
    expect(Keychain.setGenericPassword).toHaveBeenCalledWith(
      'accessToken',
      'abc123',
      expect.objectContaining({ service: SERVICE }),
    );
  });

  it('loadAccessToken hydrates the in-memory cache from a prior Keychain entry', async () => {
    await Keychain.setGenericPassword('accessToken', 'persisted', { service: SERVICE });
    await loadAccessToken();
    expect(getAccessToken()).toBe('persisted');
  });

  it('clearAccessToken wipes both the cache and the Keychain entry', async () => {
    await setAccessToken('to-be-cleared');
    await clearAccessToken();
    expect(getAccessToken()).toBeNull();
    expect(Keychain.resetGenericPassword).toHaveBeenCalledWith(
      expect.objectContaining({ service: SERVICE }),
    );
  });

  it('loadAccessToken swallows a Keychain error and leaves the cache empty', async () => {
    const spy = (Keychain.getGenericPassword as jest.Mock).mockRejectedValueOnce(
      new Error('biometry locked'),
    );
    await loadAccessToken();
    expect(getAccessToken()).toBeNull();
    spy.mockRestore?.();
  });
});
