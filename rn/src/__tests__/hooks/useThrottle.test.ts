// useThrottle 훅 테스트 — delay 내 중복 호출 차단, 경과 후 재허용
import { act, renderHook } from '@testing-library/react-native';

import useThrottle from '@/hooks/core/useThrottle';

describe('useThrottle', () => {
  beforeEach(() => {
    jest.useFakeTimers();
    // lastRun이 0으로 시작하므로 첫 호출이 통과하도록 충분히 큰 기준 시각 설정
    jest.setSystemTime(new Date('2026-06-02T00:00:00Z'));
  });
  afterEach(() => jest.useRealTimers());

  it('runs the callback on the first call', () => {
    const callback = jest.fn();
    const { result } = renderHook(() => useThrottle({ callback }));

    result.current();
    expect(callback).toHaveBeenCalledTimes(1);
  });

  it('blocks repeated calls within the delay window', () => {
    const callback = jest.fn();
    const { result } = renderHook(() => useThrottle({ callback }));

    result.current();
    result.current();
    result.current();
    expect(callback).toHaveBeenCalledTimes(1);
  });

  it('allows the callback again after the delay elapses', () => {
    const callback = jest.fn();
    const { result } = renderHook(() => useThrottle({ callback }));

    result.current();
    act(() => jest.advanceTimersByTime(500));
    result.current();
    expect(callback).toHaveBeenCalledTimes(2);
  });

  it('forwards arguments to the callback', () => {
    const callback = jest.fn();
    const { result } = renderHook(() => useThrottle({ callback }));

    result.current('hello', 42);
    expect(callback).toHaveBeenCalledWith('hello', 42);
  });
});
