// EmptyStateView 컴포넌트 테스트 — 전달된 메시지 렌더
import { render, screen } from '@testing-library/react-native';
import React from 'react';

import EmptyStateView from '@/components/common/EmptyStateView';

jest.mock('expo-image', () => ({ Image: () => null }));
jest.mock('@/assets/images', () => ({ Lemony3PreviewGrayscale: 0 }));

describe('EmptyStateView', () => {
  it('renders the given message', () => {
    render(<EmptyStateView message="아직 일기가 없어요." />);
    expect(screen.getByText('아직 일기가 없어요.')).toBeTruthy();
  });
});
