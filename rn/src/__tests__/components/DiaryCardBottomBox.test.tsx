// DiaryCard BottomBox 테스트 — likeCount 'in' 가드로 일기 종류별 카운트 렌더 분기
import { render, screen } from '@testing-library/react-native';
import React, { PropsWithChildren } from 'react';

import { CommunityDiaryDTO } from '@/api/community/types';
import { DailyDiaryDTO } from '@/api/diary/types';
import BottomBox from '@/components/diary/DiaryCard/components/BottomBox';
import { DiaryCardContext } from '@/components/diary/DiaryCard/context/DiaryCardContext';
import { Diary } from '@/components/diary/DiaryCard/types';

jest.mock('@/components/common/VectorIcon', () => () => null);

const withDiary = (diary: Diary) => {
  const wrapper = ({ children }: PropsWithChildren) => (
    <DiaryCardContext.Provider value={{ diary, size: 'large' }}>{children}</DiaryCardContext.Provider>
  );
  return wrapper;
};

const communityDiary = (overrides: Partial<CommunityDiaryDTO> = {}): CommunityDiaryDTO => ({
  idx: 1,
  userIdx: 10,
  nickname: 'n',
  sticker: 'S',
  text: 't',
  image: undefined,
  createdAt: '2026-05-27',
  updatedAt: undefined,
  isVisible: 1,
  likeCount: 5,
  commentCount: 3,
  userImage: 'a.png',
  background: '#fff',
  character: 'Dog',
  isLike: false,
  ...overrides,
});

const dailyDiary: DailyDiaryDTO = {
  idx: 1,
  sticker: 'S',
  text: 't',
  image: undefined,
  createdAt: '2026-05-27',
  updatedAt: undefined,
  isVisible: 1,
};

describe('DiaryCard BottomBox', () => {
  it('renders like and comment counts for a diary that has them', () => {
    render(<BottomBox />, { wrapper: withDiary(communityDiary({ likeCount: 5, commentCount: 3 })) });

    expect(screen.getByText('5')).toBeTruthy();
    expect(screen.getByText('3')).toBeTruthy();
  });

  it('caps the like count display at 99+', () => {
    render(<BottomBox />, { wrapper: withDiary(communityDiary({ likeCount: 150 })) });

    expect(screen.getByText('99+')).toBeTruthy();
  });

  it('renders nothing for a daily diary without a like count', () => {
    const { toJSON } = render(<BottomBox />, { wrapper: withDiary(dailyDiary) });

    expect(toJSON()).toBeNull();
  });
});
