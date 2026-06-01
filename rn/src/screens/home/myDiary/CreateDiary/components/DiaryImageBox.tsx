import React from 'react';
import { Pressable, StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import AnimatedPressable from '@/components/common/AnimatedPressable';
import VectorIcon from '@/components/common/VectorIcon';
import { COLORS, LAYOUT } from '@/constants';
import { SelectedImage } from '@/types/profile';

interface DiaryImageBoxProps {
  diaryImage?: string;
  selectedImage?: SelectedImage;
  isDeleted: boolean;
  onOpenImagePicker: () => void;
  onClearImage: () => void;
}

function DiaryImageBox({ diaryImage, selectedImage, isDeleted, onOpenImagePicker, onClearImage }: DiaryImageBoxProps) {
  const hasDiaryImage = !!(diaryImage && !isDeleted);
  const imageUrl: string | undefined = selectedImage ? selectedImage.uri : hasDiaryImage ? diaryImage : undefined;

  return (
    <View style={styles.imageSection}>
      <View style={styles.imageBox}>
        <AnimatedPressable onPress={onOpenImagePicker} style={styles.imageButton}>
          {imageUrl ? (
            <FastImage source={{ uri: imageUrl }} style={styles.image} contentFit="cover" />
          ) : (
            <VectorIcon type="MaterialIcons" name="add-photo-alternate" size={25} color={COLORS.GRAYSCALE.LIGHT_GRAY} />
          )}
        </AnimatedPressable>
        {imageUrl && (
          <Pressable onPress={onClearImage} style={styles.deleteButton}>
            <VectorIcon type="Feather" name="trash-2" size={19} color={COLORS.GRAYSCALE.WHITE} />
          </Pressable>
        )}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  imageSection: { width: '100%', height: 180, marginVertical: 15, paddingHorizontal: LAYOUT.PADDING },
  imageBox: {
    width: '100%',
    height: '100%',
  },
  imageButton: {
    width: '100%',
    height: '100%',
    borderRadius: LAYOUT.BORDER_RADIUS,
    overflow: 'hidden',
    borderWidth: 1,
    borderColor: COLORS.CORE.INPUT,
    alignItems: 'center',
    justifyContent: 'center',
  },
  image: { width: '100%', height: '100%' },
  deleteButton: {
    alignItems: 'center',
    justifyContent: 'center',
    padding: 10,
    position: 'absolute',
    right: 5,
    top: 5,
    backgroundColor: COLORS.TRANSPARENT.BLACK_30,
    width: 40,
    height: 40,
    borderRadius: 20,
  },
});

export default DiaryImageBox;
