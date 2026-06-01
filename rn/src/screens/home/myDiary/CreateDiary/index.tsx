// 일기 작성/수정 화면 — 스티커·본문·이미지·날짜 입력 후 등록 또는 수정
import React from 'react';
import { StyleSheet, View } from 'react-native';

import CustomButton from '@/components/common/CustomButton';
import CustomHeader from '@/components/common/CustomHeader';
import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import ScrollContainer from '@/components/common/ScrollContainer';
import { COLORS } from '@/constants';
import useTypedRoute from '@/hooks/core/navigation/useTypedRoute';
import useVisibility from '@/hooks/ui/animation/useVisibility';

import CalendarButton from './components/CalendarButton';
import DatePicker from './components/DatePicker';
import DiaryImageBox from './components/DiaryImageBox';
import StickerBox from './components/StickerBox';
import TextArea from './components/TextArea';
import useWriteDiary from './hooks/useWriteDiary';

function CreateDiary() {
  const {
    params: { diary },
  } = useTypedRoute<'CreateDiary'>();

  const {
    diaryState,
    handleSetDiaryState,
    selectedDiaryImage,
    handleOpenImagePicker,
    handleClearDiaryImage,
    handleSubmitDiary,
    isPending,
  } = useWriteDiary({ diary });

  const { isVisible: isDatePickerVisible, show: openDatePicker, hide: closeDatePicker } = useVisibility();

  return (
    <SafeAreaContainer>
      <CustomHeader
        title={diary ? '일기 수정' : '일기 쓰기'}
        rightItem={<CalendarButton selectedDate={diaryState.date} onPress={openDatePicker} />}
        hasBackButton
      />
      <ScrollContainer>
        <StickerBox selectedStickerName={diaryState.sticker} setDiaryState={handleSetDiaryState} />
        <TextArea text={diaryState.text} onSetDiaryState={handleSetDiaryState} />
        <DiaryImageBox
          diaryImage={diary?.image}
          selectedImage={selectedDiaryImage}
          isDeleted={diaryState.isDeleted}
          onOpenImagePicker={handleOpenImagePicker}
          onClearImage={handleClearDiaryImage}
        />
      </ScrollContainer>
      <View style={styles.buttonWrapper}>
        <CustomButton
          title={diary ? '수정하기' : '일기 등록하기'}
          onPress={handleSubmitDiary}
          disabled={!diaryState.sticker || !diaryState.text}
          isAnimated
          isLoading={isPending}
        />
      </View>
      <DatePicker
        isVisible={isDatePickerVisible}
        selectedDate={diaryState.date}
        setDiaryState={handleSetDiaryState}
        onClose={closeDatePicker}
      />
    </SafeAreaContainer>
  );
}

const styles = StyleSheet.create({
  buttonWrapper: {
    backgroundColor: COLORS.GRAYSCALE.WHITE,
  },
});

export default CreateDiary;
