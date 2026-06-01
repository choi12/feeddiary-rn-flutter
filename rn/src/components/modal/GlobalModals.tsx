import React from 'react';

import LoadingBox from '../common/LoadingBox';
import ToastBox from '../common/ToastBox';

import AlertModal from './AlertModal';
import BottomSheetModal from './BottomSheetModal';

// zustand store로 관리되는 전역 모달 컴포넌트
function GlobalModals() {
  return (
    <>
      <BottomSheetModal />
      <AlertModal />
      <ToastBox />
      <LoadingBox />
    </>
  );
}

export default GlobalModals;
