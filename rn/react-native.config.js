module.exports = {
  project: {
    ios: {},
    android: {},
  },
  assets: ['./assets/fonts'],
  dependencies: {
    'react-native-vector-icons': {
      platforms: {
        // iOS는 Info.plist + Xcode 수동 등록 (Fonts/ 통합 관리)
        ios: null,
      },
    },
  },
};
