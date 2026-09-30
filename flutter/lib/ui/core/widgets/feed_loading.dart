// 공통 로딩 인디케이터 — 가운데 연회색 스피너. RN components/common/stateView/LoadingView.
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:flutter/material.dart';

/// 화면·목록 로딩 상태. RN `LoadingView`(ActivityIndicator large · `GRAYSCALE.LIGHT_GRAY`) 1:1.
/// [compact] 는 무한목록 하단 추가 로드용 작은 크기.
class FeedLoading extends StatelessWidget {
  const FeedLoading({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 24.0 : 36.0;
    return Center(
      child: SizedBox.square(
        dimension: size,
        child: CircularProgressIndicator(strokeWidth: compact ? 2.5 : 3, color: FeedPalette.lightGray),
      ),
    );
  }
}
