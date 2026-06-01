import React from 'react';
import { Pressable, StyleSheet, View } from 'react-native';
import { Image as FastImage } from 'expo-image';

import { CommunityDiaryDTO } from '@/api/community/types';
import Container from '@/components/common/Container';
import ScrollContainer from '@/components/common/ScrollContainer';
import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import { formatDate } from '@/utils/common/formatDate';

import StickerImage from '../../CreateDiary/components/StickerImage';
import { STICKER_ICONS } from '../../CreateDiary/data';

interface DiaryContentProps {
  onToggleImageModal: () => void;
  diary: CommunityDiaryDTO;
}

function DiaryContent({ onToggleImageModal, diary }: DiaryContentProps) {
  const sticker = STICKER_ICONS.find((icon) => icon.name === diary.sticker);

  return (
    <ScrollContainer hasPadding>
      <Container>
        <View style={styles.diaryContentBox}>
          {sticker && <StickerImage name={sticker.name} size={50} />}
          <Text style={styles.dateText}>{formatDate(diary.createdAt, 'diary')}</Text>
          <Text style={styles.contentText}>{diary.text}</Text>
          {diary.image && (
            <Pressable onPress={onToggleImageModal}>
              <FastImage
                source={{ uri: diary.image }}
                style={styles.diaryImage}
                contentFit="cover"
              />
            </Pressable>
          )}
        </View>
      </Container>
    </ScrollContainer>
  );
}

const styles = StyleSheet.create({
  diaryContentBox: {
    alignItems: 'center',
    marginVertical: 20,
  },
  dateText: {
    fontSize: 15,
    color: COLORS.GRAYSCALE.GRAY,
    marginTop: 15,
  },
  contentText: {
    color: COLORS.GRAYSCALE.LIGHT_BLACK,
    fontSize: 15,
    lineHeight: 25,
    alignSelf: 'flex-start',
    marginTop: 35,
    paddingHorizontal: 10,
  },
  diaryImage: {
    width: '100%',
    aspectRatio: 1.5 / 1,
    borderRadius: 7,
    marginVertical: 20,
  },
});

export default DiaryContent;
