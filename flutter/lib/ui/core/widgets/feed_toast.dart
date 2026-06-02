// 토스트 — 90%·#EFEFEF·radius10·alert-circle+텍스트, 하단 슬라이드업·자동 소멸. RN ToastBox + showFeedToast.
import 'dart:async';

import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:flutter/material.dart';

/// 전역 토스트를 띄운다. RN `ToastBox`(하단 90%·옅은 회색·alert-circle) 디자인을 Overlay 로 재현한다.
/// 메시지가 비면 아무것도 하지 않는다(RN 동일).
void showFeedToast(BuildContext context, String message) {
  if (message.isEmpty) return;
  final overlay = Overlay.of(context, rootOverlay: true);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _FeedToast(message: message, onDismiss: entry.remove),
  );
  overlay.insert(entry);
}

class _FeedToast extends StatefulWidget {
  const _FeedToast({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  State<_FeedToast> createState() => _FeedToastState();
}

class _FeedToastState extends State<_FeedToast> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  Timer? _hideTimer;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _hideTimer = Timer(const Duration(milliseconds: 2200), _hide);
  }

  void _hide() {
    if (_dismissed) return;
    _dismissed = true;
    _controller.reverse().whenComplete(widget.onDismiss);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    return Positioned(
      left: 0,
      right: 0,
      bottom: bottomInset + 40,
      child: IgnorePointer(
        child: FadeTransition(
          opacity: _controller,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.4),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
            child: Align(
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: FeedPalette.paleGray,
                    borderRadius: BorderRadius.circular(AppDimens.toastRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        const Icon(FeedIcons.alert, size: 15, color: FeedPalette.main),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            widget.message,
                            style: const TextStyle(
                              fontFamily: FeedFonts.dovemayo,
                              fontSize: 13,
                              color: FeedPalette.lightBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
