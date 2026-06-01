import React, { useEffect } from 'react';
import { StyleSheet, View } from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import Animated, { useAnimatedStyle, useSharedValue, withTiming } from 'react-native-reanimated';

import Text from '@/components/common/Text';
import { COLORS } from '@/constants';
import useFlowerpotStats from '@/screens/home/myFlowerpot/MyFlowerpot/hooks/useFlowerpotStats';

const TEXT_POSITION_THRESHOLD = 25;

function ProgressBar() {
  const { exp, maxExp, isMaxLevel } = useFlowerpotStats();

  const progress = useSharedValue(maxExp > 0 ? exp / maxExp : 0);

  const animatedProgressBarStyle = useAnimatedStyle(() => ({ flex: progress.value }));

  useEffect(() => {
    progress.value = withTiming(maxExp > 0 ? exp / maxExp : 0, { duration: 1000 });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [exp, maxExp]);

  const percent = maxExp > 0 ? Number(((exp / maxExp) * 100).toFixed(1)) : 0;
  const showInnerLabel = percent > TEXT_POSITION_THRESHOLD;

  return (
    <LinearGradient style={styles.track} colors={[COLORS.TRANSPARENT.WHITE_90, COLORS.TRANSPARENT.WHITE_20]}>
      {!isMaxLevel && (
        <>
          <Animated.View style={[styles.progressBar, animatedProgressBarStyle]}>
            <LinearGradient style={styles.gradientBox} colors={[COLORS.ACCENT.LIME, COLORS.CORE.MAIN]}>
              {showInnerLabel && (
                <View style={styles.innerExpTextWrap}>
                  <Text style={styles.innerExpText}>{percent}%</Text>
                </View>
              )}
            </LinearGradient>
          </Animated.View>
          {!showInnerLabel && (
            <View style={styles.expTextWrap}>
              <Text style={styles.expText}>{percent}%</Text>
            </View>
          )}
        </>
      )}
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  track: {
    flexDirection: 'row',
    alignItems: 'center',
    width: '100%',
    height: 22,
    borderRadius: 100,
    borderWidth: 1,
    borderColor: COLORS.TRANSPARENT.WHITE_70,
    paddingRight: 38,
    overflow: 'hidden',
  },
  progressBar: {
    height: 18,
    borderRadius: 100,
    backgroundColor: COLORS.ACCENT.OLIVE,
  },
  gradientBox: { flex: 1, borderRadius: 100 },
  expTextWrap: {
    height: 18,
    marginLeft: 5,
    justifyContent: 'center',
  },
  expText: {
    color: COLORS.CORE.MAIN,
    fontSize: 14,
  },
  innerExpTextWrap: {
    height: 18,
    position: 'absolute',
    right: 6,
    top: 0,
    justifyContent: 'center',
  },
  innerExpText: {
    color: COLORS.GRAYSCALE.WHITE,
    fontSize: 13,
  },
});

export default ProgressBar;
