import { useEffect, useState } from 'react';

interface UseDebounceProps<T> {
  value: T;
  delay?: number;
}

const DEBOUNCE_TIME = 300;

function useDebounce<T>({ value, delay = DEBOUNCE_TIME }: UseDebounceProps<T>): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value);

  useEffect(() => {
    const timer = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => {
      clearTimeout(timer);
    };
  }, [value, delay]);

  return debouncedValue;
}

export default useDebounce;
