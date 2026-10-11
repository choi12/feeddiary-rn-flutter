// 프리페치 훅 실패 테스트 — API 가 실패해도 훅이 던지지 않고(호출부는 await 뒤 화면을 넘긴다), 실패는 QueryCache onError 로 한 번 보고되는지
import { QueryCache, QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { renderHook } from '@testing-library/react-native';
import React, { PropsWithChildren } from 'react';

import { APIGetDiary } from '@/api/diary/APIGetDiary';
import { APIGetFlowerpot } from '@/api/flowerpot/APIGetFlowerpot';
import { APIGetMissions } from '@/api/mission/APIGetMissions';
import usePrefetchFlowerpot from '@/hooks/prefetch/usePrefetchFlowerpot';
import usePrefetchMissions from '@/hooks/prefetch/usePrefetchMissions';
import usePrefetchNextDiary from '@/hooks/prefetch/usePrefetchNextDiary';

jest.mock('@/api/diary/APIGetDiary', () => ({ APIGetDiary: jest.fn() }));
jest.mock('@/api/flowerpot/APIGetFlowerpot', () => ({ APIGetFlowerpot: jest.fn() }));
jest.mock('@/api/mission/APIGetMissions', () => ({ APIGetMissions: jest.fn() }));

const networkError = new Error('network down');

// App.tsx 와 같이 QueryCache onError 를 단 클라이언트
const createWrapper = () => {
  const onError = jest.fn();
  const queryClient = new QueryClient({
    queryCache: new QueryCache({ onError }),
    defaultOptions: { queries: { retry: false, gcTime: Infinity } },
  });
  const wrapper = ({ children }: PropsWithChildren) => (
    <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
  );
  return { wrapper, onError };
};

describe('prefetch hooks on failure', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('usePrefetchNextDiary resolves and reports once', async () => {
    (APIGetDiary as jest.Mock).mockRejectedValue(networkError);
    const { wrapper, onError } = createWrapper();
    const { result } = renderHook(() => usePrefetchNextDiary(), { wrapper });

    await expect(result.current(1)).resolves.toBeUndefined();
    expect(onError).toHaveBeenCalledTimes(1);
    expect(onError.mock.calls[0][0]).toBe(networkError);
  });

  it('usePrefetchFlowerpot resolves and reports once', async () => {
    (APIGetFlowerpot as jest.Mock).mockRejectedValue(networkError);
    const { wrapper, onError } = createWrapper();
    const { result } = renderHook(() => usePrefetchFlowerpot(), { wrapper });

    await expect(result.current()).resolves.toBeUndefined();
    expect(onError).toHaveBeenCalledTimes(1);
    expect(onError.mock.calls[0][0]).toBe(networkError);
  });

  it('usePrefetchMissions resolves and reports once', async () => {
    (APIGetMissions as jest.Mock).mockRejectedValue(networkError);
    const { wrapper, onError } = createWrapper();
    const { result } = renderHook(() => usePrefetchMissions(), { wrapper });

    await expect(result.current()).resolves.toBeUndefined();
    expect(onError).toHaveBeenCalledTimes(1);
    expect(onError.mock.calls[0][0]).toBe(networkError);
  });
});
