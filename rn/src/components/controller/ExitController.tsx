import { useIsFocused } from '@react-navigation/native';
import React, { PropsWithChildren, useEffect, useRef } from 'react';
import { BackHandler, ToastAndroid } from 'react-native';

import { isAndroid, MESSAGE } from '@/constants';
import { delay } from '@/utils/common/delay';

const EXIT_DELAY = 2000;

function ExitController({ children }: PropsWithChildren) {
  const isFocused = useIsFocused();
  const readyToExit = useRef(false);

  const showExitMessage = async () => {
    readyToExit.current = true;
    ToastAndroid.show(MESSAGE.SYSTEM.EXIT, ToastAndroid.SHORT);

    await delay(EXIT_DELAY);
    readyToExit.current = false;
  };

  useEffect(() => {
    if (!isAndroid || !isFocused) return;

    const backHandler = BackHandler.addEventListener('hardwareBackPress', () => {
      if (readyToExit.current) {
        BackHandler.exitApp();
      } else {
        showExitMessage();
        return true;
      }
    });
    return () => backHandler.remove();
  }, [isFocused]);

  return <>{children}</>;
}

export default ExitController;
