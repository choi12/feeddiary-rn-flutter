import { useMutation, useQueryClient } from '@tanstack/react-query';
import dayjs from 'dayjs';
import { useCallback, useState } from 'react';

import { APICreateDiary } from '@/api/diary/APICreateDiary';
import { APIEditDiary } from '@/api/diary/APIEditDiary';
import { APIWriteDiaryParams, MyDiaryDTO } from '@/api/diary/types';
import { MESSAGE, TIMEZONE_OFFSET, TOAST_BOTTOM_OFFSET } from '@/constants';
import useScreenNavigation from '@/hooks/core/navigation/useScreenNavigation';
import usePrefetchNextDiary from '@/hooks/prefetch/usePrefetchNextDiary';
import useToast from '@/hooks/store/useToast';
import useErrorToast from '@/hooks/ui/feedback/useErrorToast';
import useImagePicker from '@/hooks/ui/interaction/useImagePicker';
import { delay } from '@/utils/common/delay';
import { invalidateQueries } from '@/utils/query/invalidateQueries';

import { STICKER_ICONS } from '../data';
import { DiaryState } from '../types';

interface UseWriteDiaryProps {
  diary?: MyDiaryDTO;
}

function useWriteDiary({ diary }: UseWriteDiaryProps) {
  const navigation = useScreenNavigation();
  const queryClient = useQueryClient();

  const [diaryState, setDiaryState] = useState<DiaryState>({
    text: diary ? diary.text : '',
    sticker: diary ? diary.sticker : STICKER_ICONS[0].name,
    date: diary ? dayjs(diary.createdAt) : dayjs(),
    isDeleted: false,
  });

  const prefetchNextDiary = usePrefetchNextDiary();
  const { handleOpenImagePicker, selectedImage, handleClearImage } = useImagePicker();

  const { showToast } = useToast();
  const handleErrorWithToast = useErrorToast();

  const handleSetDiaryState = useCallback((updates: Partial<DiaryState>) => {
    setDiaryState((prev) => ({ ...prev, ...updates }));
  }, []);

  const handleClearDiaryImage = useCallback(() => {
    handleClearImage();
    handleSetDiaryState({ isDeleted: true });
  }, [handleClearImage, handleSetDiaryState]);

  const prepareDiaryData = (): FormData => {
    const data = new FormData();
    data.append('sticker', diaryState.sticker);
    data.append('image', selectedImage ?? null);
    data.append('text', diaryState.text.trim());
    data.append('date', dayjs(diaryState.date).add(TIMEZONE_OFFSET, 'hour').toISOString());
    if (diary) {
      data.append('diary_idx', diary.idx);
      data.append('image_text', diaryState.isDeleted ? '' : diary.image);
    }
    return data;
  };

  const { mutateAsync: diaryActionMutation, isPending } = useMutation({
    mutationFn: async () => {
      const formData = prepareDiaryData();
      const data: APIWriteDiaryParams = { diaryFormData: formData };

      return diary ? await APIEditDiary(data) : await APICreateDiary(data);
    },
    onSuccess: () => invalidateQueries.diaryAction(queryClient, diary),
  });

  const handleSubmitDiary = useCallback(async () => {
    try {
      const response = await diaryActionMutation();
      await prefetchNextDiary(response.diaryIdx);
      navigation.replace('DiaryDetails', { diaryIdx: response.diaryIdx });

      await delay(100);
      showToast(MESSAGE.DIARY.updated(!!diary), TOAST_BOTTOM_OFFSET.DIARY_DETAILS);
    } catch (error) {
      handleErrorWithToast(error, TOAST_BOTTOM_OFFSET.BUTTON_SCREEN);
    }
  }, [diary, diaryActionMutation, handleErrorWithToast, prefetchNextDiary, navigation, showToast]);

  return {
    diaryState,
    handleSetDiaryState,
    selectedDiaryImage: selectedImage,
    handleOpenImagePicker,
    handleClearDiaryImage,
    handleSubmitDiary,
    isPending,
  };
}
export default useWriteDiary;
