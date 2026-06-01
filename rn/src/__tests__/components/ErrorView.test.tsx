// ErrorView 컴포넌트 테스트 — reload 유무에 따른 버튼 라벨·동작 분기
import { fireEvent, render, screen } from '@testing-library/react-native';
import React from 'react';

import ErrorView from '@/components/common/stateView/ErrorView';
import { TEXT } from '@/constants';

const mockGoBack = jest.fn();
jest.mock('@react-navigation/native', () => ({ useNavigation: () => ({ goBack: mockGoBack }) }));
jest.mock('@/components/common/VectorIcon', () => () => null);

describe('ErrorView', () => {
  beforeEach(() => mockGoBack.mockClear());

  it('shows the retry label and calls reload when reload is provided', () => {
    const reload = jest.fn();
    render(<ErrorView reload={reload} />);

    fireEvent.press(screen.getByText(TEXT.ERROR.RETRY));
    expect(reload).toHaveBeenCalledTimes(1);
    expect(mockGoBack).not.toHaveBeenCalled();
  });

  it('shows the go-back label and navigates back when reload is absent', () => {
    render(<ErrorView />);

    fireEvent.press(screen.getByText(TEXT.ERROR.GO_BACK));
    expect(mockGoBack).toHaveBeenCalledTimes(1);
  });
});
