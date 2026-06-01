// DigitKeypad 컴포넌트 테스트 — 숫자/지우기 접근성 라벨과 입력 콜백
import { fireEvent, render, screen } from '@testing-library/react-native';
import React from 'react';

import DigitKeypad from '@/components/lock/DigitKeypad';

jest.mock('@/components/common/VectorIcon', () => () => null);

describe('DigitKeypad', () => {
  it('calls onDigitPress with the tapped digit', () => {
    const onDigitPress = jest.fn();
    render(<DigitKeypad onDigitPress={onDigitPress} onClear={jest.fn()} />);

    fireEvent.press(screen.getByLabelText('숫자 5'));
    expect(onDigitPress).toHaveBeenCalledWith('5');
  });

  it('exposes an accessible label for every digit 0-9', () => {
    render(<DigitKeypad onDigitPress={jest.fn()} onClear={jest.fn()} />);

    for (let digit = 0; digit <= 9; digit += 1) {
      expect(screen.getByLabelText(`숫자 ${digit}`)).toBeTruthy();
    }
  });

  it('calls onClear when the delete button is pressed', () => {
    const onClear = jest.fn();
    render(<DigitKeypad onDigitPress={jest.fn()} onClear={onClear} />);

    fireEvent.press(screen.getByLabelText('지우기'));
    expect(onClear).toHaveBeenCalledTimes(1);
  });
});
