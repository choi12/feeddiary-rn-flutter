/* eslint-env jest */
jest.mock('react-native-config', () => ({
  __esModule: true,
  default: { USE_MOCK: 'false' },
}));

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
