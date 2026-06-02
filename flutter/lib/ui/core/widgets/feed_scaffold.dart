// 공통 화면 골격 — 배경색·헤더·하단바 조립. RN SafeAreaContainer + Container 대응.
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:flutter/material.dart';

/// 화면 공통 스캐폴드. 배경(기본 #F3F3F3)과 FeedHeader 헤더·본문·하단바를 RN 컨테이너 규칙에 맞춰 묶는다.
/// `Scaffold` 를 얇게 감싸 배경 토큰을 강제하고, 헤더는 `appBar` 슬롯(PreferredSizeWidget)으로 받는다.
class FeedScaffold extends StatelessWidget {
  const FeedScaffold({
    required this.body,
    this.header,
    this.bottomBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget? header;
  final Widget? bottomBar;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? FeedPalette.background,
      appBar: header,
      body: body,
      bottomNavigationBar: bottomBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
