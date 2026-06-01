/* eslint-env jest */
jest.mock('react-native-config', () => ({
  __esModule: true,
  default: { USE_MOCK: 'false' },
}));

// reanimated v4의 공식 mock은 ESM이라 jest 변환 대상에서 제외됨 → 사용분만 경량 mock
jest.mock('react-native-reanimated', () => {
  const { View } = require('react-native');
  return {
    __esModule: true,
    default: { View, createAnimatedComponent: (component) => component },
    View,
    useSharedValue: (initial) => ({ value: initial }),
    useAnimatedStyle: () => ({}),
    withTiming: (value) => value,
    withSpring: (value) => value,
    Easing: { ease: () => {} },
  };
});

jest.mock('react-native-safe-area-context', () => {
  const inset = { top: 0, right: 0, bottom: 0, left: 0 };
  return {
    __esModule: true,
    SafeAreaProvider: ({ children }) => children,
    SafeAreaView: ({ children }) => children,
    useSafeAreaInsets: () => inset,
    useSafeAreaFrame: () => ({ x: 0, y: 0, width: 390, height: 844 }),
  };
});

jest.mock('@sentry/react-native', () => ({
  __esModule: true,
  init: jest.fn(),
  wrap: (component) => component,
  setUser: jest.fn(),
  captureException: jest.fn(),
  reactNavigationIntegration: jest.fn(() => ({ registerNavigationContainer: jest.fn() })),
  reactNativeTracingIntegration: jest.fn(),
  reactNativeErrorHandlersIntegration: jest.fn(),
}));

jest.mock('react-native-keychain', () => {
  const store = new Map();
  return {
    __esModule: true,
    getGenericPassword: jest.fn(async ({ service }) => {
      const password = store.get(service);
      return password ? { service, username: 'mock', password } : false;
    }),
    setGenericPassword: jest.fn(async (_username, password, { service }) => {
      store.set(service, password);
      return true;
    }),
    resetGenericPassword: jest.fn(async ({ service }) => {
      store.delete(service);
      return true;
    }),
    __resetStore: () => store.clear(),
  };
});
