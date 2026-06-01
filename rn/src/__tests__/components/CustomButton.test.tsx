// CustomButton 컴포넌트 테스트 — 기본/disabled/loading 상태별 렌더와 press 동작
import { fireEvent, render, screen } from '@testing-library/react-native';
import React from 'react';

import CustomButton from '@/components/common/CustomButton';

describe('CustomButton', () => {
  it('renders the title and fires onPress when enabled', () => {
    const onPress = jest.fn();
    render(<CustomButton title="등록" onPress={onPress} />);

    fireEvent.press(screen.getByText('등록'));
    expect(onPress).toHaveBeenCalledTimes(1);
  });

  it('does not fire onPress when disabled', () => {
    const onPress = jest.fn();
    render(<CustomButton title="등록" onPress={onPress} disabled />);

    fireEvent.press(screen.getByText('등록'));
    expect(onPress).not.toHaveBeenCalled();
  });

  it('hides the title while loading', () => {
    render(<CustomButton title="등록" onPress={jest.fn()} isLoading />);
    expect(screen.queryByText('등록')).toBeNull();
  });
});
