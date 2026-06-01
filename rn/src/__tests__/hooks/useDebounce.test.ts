// useDebounce 훅 테스트 — 지연 후 값 반영, 연속 변경 시 마지막 값만 반영
import { act, renderHook } from '@testing-library/react-native';

import useDebounce from '@/hooks/core/useDebounce';

describe('useDebounce', () => {
  beforeEach(() => jest.useFakeTimers());
  afterEach(() => jest.useRealTimers());

  it('returns the initial value immediately', () => {
    const { result } = renderHook(() => useDebounce({ value: 'a' }));
    expect(result.current).toBe('a');
  });

  it('updates only after the delay elapses', () => {
    const { result, rerender } = renderHook(({ value }: { value: string }) => useDebounce({ value }), {
      initialProps: { value: 'a' },
    });

    rerender({ value: 'b' });
    expect(result.current).toBe('a');

    act(() => jest.advanceTimersByTime(300));
    expect(result.current).toBe('b');
  });

  it('keeps only the last value when changes happen within the delay', () => {
    const { result, rerender } = renderHook(({ value }: { value: string }) => useDebounce({ value }), {
      initialProps: { value: 'a' },
    });

    rerender({ value: 'b' });
    act(() => jest.advanceTimersByTime(200));
    rerender({ value: 'c' });
    act(() => jest.advanceTimersByTime(200));
    expect(result.current).toBe('a');

    act(() => jest.advanceTimersByTime(100));
    expect(result.current).toBe('c');
  });
});
