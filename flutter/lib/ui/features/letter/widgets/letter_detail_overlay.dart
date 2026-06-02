// 편지 펼침 모달 — 누른 위치에서 중앙으로 확대되며 등장하는 편지 상세. RN useAnimatedLetterModal(터치 위치→중앙 스프링) 대응(경량).
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/data/models/letter.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter/material.dart';

/// 편지 상세를 누른 지점([origin], 전역 좌표)에서 화면 중앙으로 확대하며 띄운다.
/// showGeneralDialog 의 transition 으로 translate(origin→중앙) + scale 0.5→1 + fade 를 구동한다(결정① 경량 등장 애니메이션).
Future<void> showLetterDetail(BuildContext context, Letter letter, Offset origin) {
  final size = MediaQuery.sizeOf(context);
  final fromCenter = origin - Offset(size.width / 2, size.height / 2);
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, _, _) => Center(child: _LetterDetailCard(letter: letter)),
    transitionBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack, reverseCurve: Curves.easeIn);
      return AnimatedBuilder(
        animation: curved,
        builder: (context, _) {
          final t = curved.value;
          return Opacity(
            opacity: animation.value.clamp(0.0, 1.0),
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

/// 펼쳐진 편지 본문 카드(날짜 + 본문). RN LetterModalContent.
class _LetterDetailCard extends StatelessWidget {
  const _LetterDetailCard({required this.letter});

  final Letter letter;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300,
        constraints: const BoxConstraints(maxHeight: 420),
        padding: const EdgeInsets.fromLTRB(34, 40, 34, 38),
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.letterPaper), fit: BoxFit.fill),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(0, 8))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatRelativeDate(letter.createdAt),
              style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  letter.text,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 19,
                    height: 1.6,
                    fontFamily: FeedFonts.ownglyph,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
