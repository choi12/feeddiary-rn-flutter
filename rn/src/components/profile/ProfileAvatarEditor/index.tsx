import React, { useEffect } from 'react';

import BaseModal from '@/components/modal/BaseModal';
import useVisibility from '@/hooks/ui/animation/useVisibility';

import CharacterBox from '../CharacterBox';
import ColorPicker from '../ColorPicker';

import BackgroundSelector from './components/BackgroundSelector';
import CharacterSelector from './components/CharacterSelector';

interface ProfileAvatarEditorProps {
  background?: string;
  onSetBackground: (background?: string) => void;
  character?: string;
  onSetCharacter: (character?: string) => void;
  scrollToEnd: () => void;
}

function ProfileAvatarEditor({
  background,
  character,
  onSetBackground,
  onSetCharacter,
  scrollToEnd,
}: ProfileAvatarEditorProps) {
  const {
    isVisible: isColorPickerVisible,
    show: handleOpenColorPicker,
    hide: handleCloseColorPicker,
  } = useVisibility();

  const {
    isVisible: isCharacterPickerVisible,
    hide: closeCharacterPicker,
    toggle: toggleCharacterPicker,
  } = useVisibility();

  useEffect(() => {
    if (background) {
      handleCloseColorPicker();
    }
  }, [background, handleCloseColorPicker]);

  useEffect(() => {
    if (character) {
      closeCharacterPicker();
    }
  }, [character, closeCharacterPicker]);

  return (
    <>
      <BackgroundSelector background={background} onOpenColorPicker={handleOpenColorPicker} />
      <CharacterSelector
        character={character}
        toggleCharacterPicker={toggleCharacterPicker}
        scrollToEnd={scrollToEnd}
        isCharacterPickerVisible={isCharacterPickerVisible}
      />
      {isCharacterPickerVisible && <CharacterBox character={character} onSetCharacter={onSetCharacter} />}
      <BaseModal isVisible={isColorPickerVisible} onClose={handleCloseColorPicker}>
        <ColorPicker onSetBackground={onSetBackground} />
      </BaseModal>
    </>
  );
}

export default ProfileAvatarEditor;
