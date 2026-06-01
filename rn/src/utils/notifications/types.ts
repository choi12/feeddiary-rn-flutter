// Firebase 모듈 제거 후 RemoteMessage 타입을 자체 선언으로 대체.
// 원본은 @react-native-firebase/messaging의 RemoteMessage.
export type RemoteMessage = {
  data?: Record<string, string | object | undefined>;
  notification?: {
    title?: string;
    body?: string;
  };
};
