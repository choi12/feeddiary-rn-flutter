import { STORAGE_KEY } from '@/constants';

import { storage } from './storage';

export const setLockPassword = (password: string): void => {
  storage.set(STORAGE_KEY.LOCK.PASSWORD, password);
};

export const enableLock = (): void => {
  storage.set(STORAGE_KEY.LOCK.LOCK_ENABLED, true);
};

export const disableLock = (): void => {
  storage.delete(STORAGE_KEY.LOCK.LOCK_ENABLED);
};

export const getUseLock = (): boolean => {
  return storage.contains(STORAGE_KEY.LOCK.LOCK_ENABLED);
};

export const getLockPassword = (): string | null => {
  return storage.get(STORAGE_KEY.LOCK.PASSWORD);
};
