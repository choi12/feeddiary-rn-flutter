import React from 'react';
import { Pressable, StyleSheet, TouchableOpacity, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import VectorIcon from '@/components/common/VectorIcon';
import { COLORS } from '@/constants';
import useUserInfo from '@/hooks/store/useUserInfo';
import { SelectedImage } from '@/types/profile';

interface ProfilePhotoSelectorProps {
  selectedImage: SelectedImage | undefined;
  onOpenImagePicker: () => void;
  onClearImage: () => void;
}

function ProfilePhotoSelector({ onOpenImagePicker, selectedImage, onClearImage }: ProfilePhotoSelectorProps) {
  const userImage = useUserInfo('image');

  return (
    <>
      {!selectedImage ? (
        userImage && userImage !== '' ? (
          <FastImage source={{ uri: userImage }} style={styles.image} contentFit="cover" />
        ) : (
          <VectorIcon type="AntDesign" name="plus" size={30} color={COLORS.GRAYSCALE.WHITE} />
        )
      ) : (
        <View style={styles.imageBox}>
          <TouchableOpacity onPress={onOpenImagePicker}>
            <FastImage
              source={{ uri: selectedImage.uri }}
              style={styles.image}
              contentFit="cover"
            />
          </TouchableOpacity>
          <Pressable onPress={onClearImage} style={styles.deleteButton}>
            <VectorIcon type="Feather" name="trash-2" size={16} color={COLORS.GRAYSCALE.WHITE} />
          </Pressable>
        </View>
      )}
    </>
  );
}

const styles = StyleSheet.create({
  imageBox: {
    width: '100%',
    height: '100%',
  },
  image: { width: '100%', height: '100%' },
  deleteButton: {
    alignItems: 'center',
    justifyContent: 'center',
    position: 'absolute',
    right: 15,
    top: 25,
    width: 30,
    height: 30,
    backgroundColor: COLORS.TRANSPARENT.BLACK_20,
    borderRadius: 15,
  },
});

export default ProfilePhotoSelector;
