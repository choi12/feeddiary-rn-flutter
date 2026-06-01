import * as Keychain from 'react-native-keychain';

const KEYCHAIN_SERVICE = 'feeddiary.accessToken';
const KEYCHAIN_USERNAME = 'accessToken';

let cachedAccessToken: string | null = null;

export const loadAccessToken = async (): Promise<void> => {
  try {
    const creds = await Keychain.getGenericPassword({ service: KEYCHAIN_SERVICE });
    cachedAccessToken = creds ? creds.password : null;
  } catch {
    cachedAccessToken = null;
  }
};

export const getAccessToken = (): string | null => cachedAccessToken;

export const setAccessToken = async (token: string): Promise<void> => {
  cachedAccessToken = token;
  await Keychain.setGenericPassword(KEYCHAIN_USERNAME, token, { service: KEYCHAIN_SERVICE });
};

export const clearAccessToken = async (): Promise<void> => {
  cachedAccessToken = null;
  await Keychain.resetGenericPassword({ service: KEYCHAIN_SERVICE });
};
