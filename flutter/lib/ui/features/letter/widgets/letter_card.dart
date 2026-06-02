// 편지 카드 — 핀에 매달린 듯 미세하게 흔들리는 편지(탭→펼침·편집 모드→삭제). RN LetterCard + useLetterSwingAnimation 대응.
import 'package:feeddiary/data/models/letter.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/features/letter/letter_strings.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter/material.dart';

/// 편지 한 장. 짝/홀 인덱스로 흔들림 방향·주기를 달리해 핀(상단)에 매달린 느낌을 준다(경량 AnimationController·상단 회전축).
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
    final direction = isEven ? 1.0 : -1.0;
    _angle = Tween<double>(
      begin: 0,
      end: direction * 0.05,
    ).animate(CurvedAnimation(parent: _swing, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _swing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _angle,
      builder: (context, child) => Transform.rotate(angle: _angle.value, alignment: Alignment.topCenter, child: child),
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          GestureDetector(
            onTapUp: widget.editMode ? null : (details) => widget.onOpen(widget.letter, details.globalPosition),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(AppDimens.borderRadius),
                border: Border.all(color: context.colors.outline),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.mail_outline, size: 28, color: context.colors.primary),
                  const SizedBox(height: 10),
                  Text(
                    '${formatRelativeDate(widget.letter.createdAt)}의',
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
                  ),
                  Text(LetterStrings.to, style: TextStyle(color: context.colors.textPrimary, fontSize: 15)),
                ],
              ),
            ),
          ),
          // 상단 핀(흔들림 회전축).
          Positioned(
            top: -6,
            child: Transform.rotate(angle: 0.5, child: Icon(Icons.push_pin, size: 20, color: context.colors.primary)),
          ),
          if (widget.editMode)
            Positioned(top: -10, left: -6, child: _DeleteBadge(onTap: () => widget.onDelete(widget.letter))),
        ],
      ),
    );
  }
}

/// 편집 모드 삭제(−) 배지. RN DeleteButton(minus).
class _DeleteBadge extends StatelessWidget {
  const _DeleteBadge({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '편지 삭제',
      child: Material(
        color: context.colors.error,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: const Padding(
            padding: EdgeInsets.all(3),
            child: Icon(Icons.remove, size: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
