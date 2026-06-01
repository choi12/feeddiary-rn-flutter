type Url = `https://${string}`;
type EmailAddress = `${string}@${string}.${string}`;

declare module 'react-native-config' {
  export interface NativeConfig {
    APP_ENV: 'DEVELOPMENT' | 'PRODUCTION';
    USE_MOCK?: 'true' | 'false';
    SENTRY_DSN?: Url | '';
    API_SERVER: string;
    API_LOCAL?: string;
    SERVER_IP?: string;
    EMAIL_ADDRESS: EmailAddress;
    GOOGLE_CLIENT_ID_IOS?: string;
    GOOGLE_CLIENT_ID_ANDROID?: string;
    APPLE_CLIENT_ID_ANDROID?: string;
    APPLE_REDIRECT_URI?: Url;
    GOOGLE_PLAY_STORE_LINK?: Url;
    APPLE_APP_STORE_LINK?: Url;
  }

  export const Config: NativeConfig;
  export default Config;
}
