// delay 유틸 테스트 (fake timers)
import { delay } from '@/utils/common/delay';

describe('delay', () => {
  beforeEach(() => jest.useFakeTimers());
  afterEach(() => jest.useRealTimers());

  it('resolves only after the given milliseconds elapse', async () => {
    const onResolved = jest.fn();
    const promise = delay(1000).then(onResolved);

    await Promise.resolve();
    expect(onResolved).not.toHaveBeenCalled();

    jest.advanceTimersByTime(1000);
    await promise;
    expect(onResolved).toHaveBeenCalledTimes(1);
  });
});
