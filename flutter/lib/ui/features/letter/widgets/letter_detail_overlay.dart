// 편지 펼침 모달 — 누른 위치에서 중앙으로 확대되며 등장하는 편지 상세(260² 정사각). RN LetterModal + useAnimatedLetterModal 대응.
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/data/models/letter.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter/material.dart';

/// 편지 상세를 누른 지점([origin], 전역 좌표)에서 화면 중앙으로 확대하며 띄운다.
/// RN: translate/scale 은 spring(damping 100·stiffness 300 = 무바운스 오버댐프트) ≈ easeOut, opacity 는 withTiming 300ms ease-in.
Future<void> showLetterDetail(BuildContext context, Letter letter, Offset origin) {
  // 누른 좌표(전역)를 모달이 렌더되는 오버레이의 로컬 좌표로 변환한다. 웹 폰 프레임(390 센터)에서는 전역 좌표와
  // 프레임 좌표가 어긋나 누른 자리가 아닌 엉뚱한 곳에서 펼쳐졌다 → 오버레이 박스 기준으로 환산해 정확히 그 자리에서 펼친다.
  final overlayBox = Overlay.of(context).context.findRenderObject() as RenderBox?;
  final size = overlayBox?.size ?? MediaQuery.sizeOf(context);
  final localOrigin = overlayBox?.globalToLocal(origin) ?? origin;
  final fromCenter = localOrigin - Offset(size.width / 2, size.height / 2);
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: FeedPalette.scrim, // RN BaseModal dim = TRANSPARENT.BLACK_30.
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, _, _) => Center(child: _LetterDetailCard(letter: letter)),
    transitionBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut, reverseCurve: Curves.easeIn);
      return AnimatedBuilder(
        animation: curved,
        builder: (context, _) {
          final t = curved.value;
          return Opacity(
            opacity: Curves.easeIn.transform(animation.value.clamp(0.0, 1.0)),
            child: Transform.translate(
              offset: Offset.lerp(fromCenter, Offset.zero, t)!,
              child: Transform.scale(scale: 0.5 + 0.5 * t, child: child),
            ),
          );
        },
      );
    },
  );
}

/// 펼쳐진 편지(260² 정사각·편지지 fill). 본문은 가운데 정렬·개행 제거(removeLineBreaks). RN LetterModal/LetterModalContent.
class _LetterDetailCard extends StatelessWidget {
  const _LetterDetailCard({required this.letter});

  final Letter letter;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 260,
        height: 260,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.letterPaper), fit: BoxFit.fill),
        ),
        // RN modalContentBox: width 80% · padding 30 · paddingRight 40 · alignItems center.
        child: SizedBox(
          width: 260 * 0.8,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 40, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatRelativeDate(letter.createdAt),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: FeedFonts.ownglyph, fontSize: 14, color: FeedPalette.gray),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      letter.text.replaceAll('\n', ' '),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: FeedFonts.ownglyph,
                        fontSize: 18,
                        color: FeedPalette.lightBlack,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
