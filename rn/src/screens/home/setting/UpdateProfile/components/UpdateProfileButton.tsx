import React from 'react';
import { StyleSheet, View } from 'react-native';

import CustomButton from '@/components/common/CustomButton';
import { COLORS } from '@/constants';

import useUpdateProfile from '../hooks/useUpdateProfile';

function UpdateProfileButton() {
  const { handleSubmitProfile, isPending, isUpdateProfileDisabled } = useUpdateProfile();

  return (
    <View style={styles.buttonWrapper}>
      <CustomButton
        onPress={handleSubmitProfile}
        disabled={isUpdateProfileDisabled}
        title="수정하기"
        isAnimated
        isLoading={isPending}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  buttonWrapper: {
    backgroundColor: COLORS.GRAYSCALE.WHITE,
  },
});

export default UpdateProfileButton;
