import { AlertModalContent, BottomSheetModalContent } from '@/types/modal';

export interface ModalSlice {
  alert: {
    isVisible: boolean;
    content: AlertModalContent | null;
  };
  bottomSheet: {
    isVisible: boolean;
    contentArr: BottomSheetModalContent[];
  };
  openAlertModal: (content: AlertModalContent) => void;
  closeAlertModal: () => void;
  openBottomSheetModal: (content: BottomSheetModalContent[]) => void;
  closeBottomSheetModal: () => void;
}
