import { useCallback } from 'react';

import useToast from '@/hooks/store/useToast';
import { getErrorMessage } from '@/utils/error/getErrorMessage';
import { reportError } from '@/utils/error/reportError';

function useErrorToast() {
  const { showToast } = useToast();

  return useCallback(
    (error: unknown, bottomOffset: number) => {
      reportError(error);

      const errorMessage = getErrorMessage(error);
      showToast(errorMessage, bottomOffset);
    },
    [showToast],
  );
}

export default useErrorToast;
