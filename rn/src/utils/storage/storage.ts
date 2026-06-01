import { MMKV } from 'react-native-mmkv';

interface Storage {
  set: <T>(key: string, value: T) => void;
  get: <T>(key: string) => T | null;
  delete: (key: string) => void;
  clear: () => void;
  contains: (key: string) => boolean;
}

const mmkvStorage = new MMKV();

const parseStorageValue = <T>(value: string | undefined): T | null => {
  if (!value) return null;

  try {
    const parsed = JSON.parse(value);
    // null의 타입이 'object'를 반환하는 JS의 특성 때문에 null 체크 필요
    if (typeof parsed === 'object' && parsed !== null) {
      return parsed as T;
    }
    return value as T;
  } catch (error) {
    return value as T;
  }
};

const stringifyStorageValue = <T>(value: T): string => {
  return typeof value === 'string' ? value : JSON.stringify(value);
};

export const storage: Storage = {
  set: <T>(key: string, value: T): void => {
    mmkvStorage.set(key, stringifyStorageValue(value));
  },
  get: <T>(key: string): T | null => {
    const value = mmkvStorage.getString(key);
    return parseStorageValue(value);
  },
  delete: (key: string): void => mmkvStorage.delete(key),
  clear: (): void => mmkvStorage.clearAll(),
  contains: (key: string): boolean => mmkvStorage.contains(key),
};
