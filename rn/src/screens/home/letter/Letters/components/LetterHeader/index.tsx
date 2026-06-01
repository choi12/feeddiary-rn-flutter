import React from 'react';

import CustomHeader from '@/components/common/CustomHeader';

import useLetters from '../../hooks/useLetters';

import EditButton from './components/EditButton';
import LetterHeaderTitleBox from './components/LetterHeaderTitleBox';

interface LetterHeaderProps {
  isEditMode: boolean;
  onToggleEditMode: () => void;
}

function LetterHeader({ isEditMode, onToggleEditMode }: LetterHeaderProps) {
  const { hasLetter } = useLetters();

  return (
    <CustomHeader
      title={<LetterHeaderTitleBox />}
      rightItem={hasLetter && <EditButton isEditMode={isEditMode} onToggleEditMode={onToggleEditMode} />}
    />
  );
}

export default LetterHeader;
