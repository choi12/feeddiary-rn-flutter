import { useCallback, useState } from 'react';

// 스크롤 이벤트 핸들링은 이 훅을 사용하는 컴포넌트에서 구현
function useScrollStatus() {
  const [isScrolled, setIsScrolled] = useState(false);

  const startScroll = useCallback(() => setIsScrolled(true), []);
  const endScroll = useCallback(() => setIsScrolled(false), []);

  return {
    isScrolled,
    startScroll,
    endScroll,
  };
}

export default useScrollStatus;
