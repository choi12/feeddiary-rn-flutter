import { useCallback, useState } from 'react';
import { launchImageLibrary, MediaType, PhotoQuality } from 'react-native-image-picker';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { LAYOUT } from '@/constants';
import { SelectedImage } from '@/types/profile';

import useErrorToast from '../feedback/useErrorToast';

function useImagePicker() {
  const { bottom: safeAreaBottomInset } = useSafeAreaInsets();
  const [selectedImage, setSelectedImage] = useState<SelectedImage | undefined>(undefined);
  const handleErrorWithToast = useErrorToast();

  const handleOpenImagePicker = useCallback(() => {
    const options = {
      mediaType: 'photo' as MediaType,
      quality: 0.5 as PhotoQuality,
      selectionLimit: 1,
    };

    launchImageLibrary(options, (response) => {
      if (response.didCancel) return;
      if (response.errorCode) {
        console.error('image selection failed: ', {
          code: response.errorCode,
          message: response.errorMessage,
        });
        handleErrorWithToast(response.errorMessage, LAYOUT.BUTTON_HEIGHT + LAYOUT.PADDING + safeAreaBottomInset);
        return;
      }
      if (!response.assets || response.assets.length < 1) return;

      const selected = response.assets[0];
      const covert = {
        uri: selected.uri ?? '',
        name: selected.fileName ?? 'image.jpg',
        type: selected.type ?? '',
      };
      console.log('selected image', covert);

      return setSelectedImage(covert);
    });
  }, [handleErrorWithToast, safeAreaBottomInset]);

  const handleClearImage = useCallback(() => setSelectedImage(undefined), []);

  return { selectedImage, handleOpenImagePicker, handleClearImage };
}

export default useImagePicker;
