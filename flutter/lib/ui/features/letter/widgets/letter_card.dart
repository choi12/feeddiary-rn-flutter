// 편지 카드 — 핀에 매달린 듯 미세하게 흔들리는 편지(탭→펼침·편집 모드→삭제). RN LetterCard + useLetterSwingAnimation 대응.
import 'dart:math' show pi;

import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/data/models/letter.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/features/letter/letter_strings.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter/material.dart';

/// 편지 한 장(100×100). 짝/홀 인덱스로 흔들림 방향·주기를 달리해 핀(상단)에 매달린 느낌을 준다(상단 회전축).
/// 탭하면 누른 위치를 [onOpen]에 넘겨 펼침 모달을 띄우고, 편집 모드면 삭제(−) 버튼을 노출한다.
class LetterCard extends StatefulWidget {
  const LetterCard({
    required this.letter,
    required this.index,
    required this.editMode,
    required this.onOpen,
    required this.onDelete,
    super.key,
  });

  final Letter letter;
  final int index;
  final bool editMode;
  final void Function(Letter letter, Offset origin) onOpen;
  final void Function(Letter letter) onDelete;

  @override
  State<LetterCard> createState() => _LetterCardState();
}

class _LetterCardState extends State<LetterCard> with SingleTickerProviderStateMixin {
  late final AnimationController _swing;
  late final Animation<double> _angle;

  @override
  void initState() {
    super.initState();
    final isEven = widget.index.isEven;
    _swing = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: isEven ? 2000 : 2500),
    )..repeat(reverse: true);
    // RN useLetterSwingAnimation: 짝=0→+5°, 홀=0→−5° (5° = 5π/180 rad).
    // RN easing = Easing.ease = cubic-bezier(0.42,0,1,1) = ease-in. yoyo(reverse) 의 복귀 구간은 ease-out 으로
    // 미러링되므로(reanimated 가 같은 easing 으로 0↔target 재생) curve=easeIn·reverseCurve=easeOut 가 1:1.
    final direction = isEven ? 1.0 : -1.0;
    _angle = Tween<double>(
      begin: 0,
      end: direction * 5 * pi / 180,
    ).animate(CurvedAnimation(parent: _swing, curve: Curves.easeIn, reverseCurve: Curves.easeOut));
  }

  @override
  void dispose() {
    _swing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // RN: 카드는 entering={FadeIn} 으로 등장한다(편지 탭 진입·새 카드 추가 시 페이드 인).
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, opacity, child) => Opacity(opacity: opacity, child: child),
      child: AnimatedBuilder(
        animation: _angle,
        // 핀(상단)을 회전축으로 매달린 듯 흔들린다. RN translateY(-50)·rotate·translateY(50) = 상단 회전축.
        builder: (context, child) =>
            Transform.rotate(angle: _angle.value, alignment: Alignment.topCenter, child: child),
        child: _content(context),
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        GestureDetector(
          onTapUp: widget.editMode ? null : (details) => widget.onOpen(widget.letter, details.globalPosition),
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage(AppAssets.letterPaper), fit: BoxFit.contain),
            ),
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.8,
                // RN letterTextBox paddingRight 5(우측 비대칭) + 손글씨가 카드보다 길면 폭에 맞춰 축소한다.
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              formatRelativeDate(widget.letter.createdAt),
                              style: const TextStyle(
                                fontFamily: FeedFonts.ownglyph,
                                fontSize: 14,
                                color: FeedPalette.gray,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 1),
                              child: Text(
                                '의',
                                style: TextStyle(
                                  fontFamily: FeedFonts.ownglyph,
                                  fontSize: 13,
                                  color: FeedPalette.darkGray,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          LetterStrings.to,
                          style: TextStyle(fontFamily: FeedFonts.ownglyph, fontSize: 15, color: FeedPalette.darkGray),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // 상단 핀(흔들림 회전축) — RN pin.png 25×25·40° 기울임.
        Positioned(
          top: -3,
          child: Transform.rotate(angle: 40 * pi / 180, child: Image.asset(AppAssets.letterPin, width: 25, height: 25)),
        ),
        if (widget.editMode)
          Positioned(top: -8, left: -2, child: _DeleteBadge(onTap: () => widget.onDelete(widget.letter))),
      ],
    );
  }
}

/// 편집 모드 삭제(−) 배지 — 25 회색 원 + 검정 마이너스. RN DeleteButton(Entypo minus).
class _DeleteBadge extends StatelessWidget {
  const _DeleteBadge({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '편지 삭제',
      child: Material(
        color: FeedPalette.lightGray,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: const SizedBox(
            width: 25,
            height: 25,
            child: Icon(FeedIcons.minus, size: 17, color: FeedPalette.black),
          ),
        ),
      ),
    );
  }
}
