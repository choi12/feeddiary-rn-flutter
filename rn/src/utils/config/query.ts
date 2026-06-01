import { QueryClientConfig } from '@tanstack/react-query';

// 기본 설정
export const QUERY_CLIENT_CONFIG: QueryClientConfig = {
  defaultOptions: {
    queries: {
      retry: false,
      staleTime: 5 * 60 * 1000,
      gcTime: 30 * 60 * 1000,
    },
    mutations: {
      retry: false,
    },
  },
};

// 본인의 액션으로만 변경되는 데이터
export const INDEPENDENT_QUERY_CONFIG = {
  staleTime: Infinity,
  gcTime: Infinity,
  refetchOnMount: false,
  refetchOnReconnect: false,
} as const;

// 다른 사용자의 액션으로도 변경될 수 있는 데이터
export const REALTIME_QUERY_CONFIG = {
  staleTime: 30 * 1000,
} as const;
