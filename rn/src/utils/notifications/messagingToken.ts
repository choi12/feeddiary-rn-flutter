// Firebase 모듈을 데모 트랙에서 제거. 원본은 @react-native-firebase/messaging의 getToken/deleteToken 사용.
// 어필 코드는 src/에 보존하되 빌드 통과를 위해 mock으로 우회.

export const getFCMToken = async (): Promise<string> => {
  return 'mock_fcm_token';
};

export const deleteMessagingToken = async (): Promise<void> => {
  // no-op
};
