export interface UISlice {
  loading: {
    isVisible: boolean;
  };
  toast: {
    isVisible: boolean;
    message: string;
    bottomOffset: number;
  };
  showLoading: () => void;
  hideLoading: () => void;
  showToast: (message: string, bottomOffset: number) => void;
  hideToast: () => void;
}
