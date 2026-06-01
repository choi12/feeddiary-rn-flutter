import { useCallback, useRef } from 'react';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type AnyFunction = (...args: any[]) => any;

type UseThrottleReturn<T extends AnyFunction> = (...args: Parameters<T>) => ReturnType<T> | undefined;

interface UseThrottleProps<T extends AnyFunction> {
  callback: T;
  delay?: number;
}

const THROTTLE_TIME = 500;

function useThrottle<T extends AnyFunction>({
  callback,
  delay = THROTTLE_TIME,
}: UseThrottleProps<T>): UseThrottleReturn<T> {
  const lastRun = useRef(0);

  const throttledCallback = useCallback(
    (...args: Parameters<T>) => {
      const now = Date.now();
      if (now - lastRun.current >= delay) {
        lastRun.current = now;

        return callback(...args);
      }
    },
    [callback, delay],
  );

  return throttledCallback;
}

export default useThrottle;
