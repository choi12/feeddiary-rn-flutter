// BaseModal 컴포넌트 테스트 — 가시성 분기와 배경 press → onClose
import { fireEvent, render, screen } from '@testing-library/react-native';
import React from 'react';
import { Text } from 'react-native';

import BaseModal from '@/components/modal/BaseModal';

describe('BaseModal', () => {
  it('renders nothing when not visible', () => {
    const { toJSON } = render(
      <BaseModal isVisible={false} onClose={jest.fn()}>
        <Text>content</Text>
      </BaseModal>,
    );
    expect(toJSON()).toBeNull();
  });

  it('renders children when visible', () => {
    render(
      <BaseModal isVisible onClose={jest.fn()}>
        <Text>content</Text>
      </BaseModal>,
    );
    expect(screen.getByText('content')).toBeTruthy();
  });

  it('calls onClose when the background is pressed', () => {
    const onClose = jest.fn();
    render(
      <BaseModal isVisible onClose={onClose}>
        <Text>content</Text>
      </BaseModal>,
    );

    fireEvent.press(screen.getByLabelText('배경을 눌러 닫기'));
    expect(onClose).toHaveBeenCalledTimes(1);
  });
});
