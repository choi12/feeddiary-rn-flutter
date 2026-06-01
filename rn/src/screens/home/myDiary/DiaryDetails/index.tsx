// 일기 상세 화면 — 일기 내용·공개여부·작성자 액션과 이미지 모달을 표시
import React from 'react';

import SafeAreaContainer from '@/components/common/SafeAreaContainer';
import ErrorView from '@/components/common/stateView/ErrorView';
import LoadingView from '@/components/common/stateView/LoadingView';
import useTypedRoute from '@/hooks/core/navigation/useTypedRoute';
import useVisibility from '@/hooks/ui/animation/useVisibility';

import BottomBox from './components/BottomBox';
import DiaryContent from './components/DiaryContent';
import DiaryDetailsHeader from './components/DiaryDetailsHeader';
import ImageModal from './components/ImageModal';
import useDiaryActions from './hooks/useDiaryActions';
import useDiaryDetails from './hooks/useDiaryDetails';

function DiaryDetails() {
  const {
    params: { diaryIdx },
  } = useTypedRoute<'DiaryDetails'>();

  const { diary, refetch, isLoading, isError, isMyDiary, isVisible, toggleVisibility } = useDiaryDetails({ diaryIdx });
  const { handleOpenDiaryActionModal } = useDiaryActions({ diary, isVisible, toggleVisibility });
  const { isVisible: isImageModalVisible, toggle: handleToggleImageModal } = useVisibility();

  return (
    <SafeAreaContainer>
      <DiaryDetailsHeader diary={diary} isMyDiary={isMyDiary} onOpenDiaryActionModal={handleOpenDiaryActionModal} />
      {isLoading ? (
        <LoadingView />
      ) : isError ? (
        <ErrorView reload={refetch} />
      ) : (
        diary && (
          <>
            <DiaryContent onToggleImageModal={handleToggleImageModal} diary={diary} />
            <BottomBox diary={diary} isMyDiary={isMyDiary} isVisible={isVisible} />
            {diary.image && (
              <ImageModal isVisible={isImageModalVisible} onToggleModal={handleToggleImageModal} image={diary.image} />
            )}
          </>
        )
      )}
    </SafeAreaContainer>
  );
}

export default DiaryDetails;
