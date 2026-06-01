import { useEffect, useState } from 'react';
import { Keyboard } from 'react-native';

import { isAndroid } from '@/constants';

function useKeyboardState() {
  const [isKeyboardVisible, setIsKeyboardVisible] = useState(false);
  const [keyboardHeight, setKeyboardHeight] = useState(0);

  useEffect(() => {
    const showSubscription = Keyboard.addListener(isAndroid ? 'keyboardDidShow' : 'keyboardWillShow', (e) => {
      setKeyboardHeight(e.endCoordinates.height);
      setIsKeyboardVisible(true);
    });

    const hideSubscription = Keyboard.addListener(isAndroid ? 'keyboardDidHide' : 'keyboardWillHide', () => {
      setKeyboardHeight(0);
      setIsKeyboardVisible(false);
    });

    return () => {
      showSubscription.remove();
      hideSubscription.remove();
    };
  }, []);

  return { isKeyboardVisible, keyboardHeight };
}
export default useKeyboardState;
