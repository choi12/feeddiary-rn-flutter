// 토스트 — 90%·#EFEFEF·radius10·alert-circle+텍스트, 하단 슬라이드업·자동 소멸. RN ToastBox + showFeedToast.
import 'dart:async';

import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:flutter/material.dart';

/// 토스트 하단 오프셋 — 화면 하단 UI(탭바·버튼·입력바) 위에 뜨도록 화면별로 다르다. RN `TOAST_BOTTOM_OFFSET`.
/// 값은 안전영역 inset 위에 더해진다(RN `bottomOffset + safeAreaBottom`). 안드 분기는 폰 프레임 웹에선 0.
enum FeedToastOffset {
  /// 메인 탭 화면(탭바 75 위). RN HOME_SCREEN.
  home(75),

  /// 하단 고정 버튼 화면(버튼 54 + 패딩 24 + 20). RN BUTTON_SCREEN.
  button(98),

  /// 하단 UI 가 없는 내부 화면. RN INNER_SCREEN.
  inner(20),

  /// 일기 상세(하단 카운트 바 위). RN DIARY_DETAILS.
  diaryDetails(65),

  /// 댓글 화면(하단 입력바 위). RN COMMENT.
  comment(80);

  const FeedToastOffset(this.value);

  final double value;
}

/// 전역 토스트를 띄운다. RN `ToastBox`(하단 90%·옅은 회색·alert-circle) 디자인을 Overlay 로 재현한다.
/// [offset] 으로 화면별 하단 위치를 지정한다(RN `showToast(message, TOAST_BOTTOM_OFFSET.*)`). 메시지가 비면 무동작(RN 동일).
void showFeedToast(BuildContext context, String message, {FeedToastOffset offset = FeedToastOffset.inner}) {
  if (message.isEmpty) return;
  final overlay = Overlay.of(context, rootOverlay: true);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _FeedToast(message: message, bottomOffset: offset.value, onDismiss: entry.remove),
  );
  overlay.insert(entry);
}

class _FeedToast extends StatefulWidget {
  const _FeedToast({required this.message, required this.bottomOffset, required this.onDismiss});

  final String message;
  final double bottomOffset;
  final VoidCallback onDismiss;

  @override
  State<_FeedToast> createState() => _FeedToastState();
}

class _FeedToastState extends State<_FeedToast> with SingleTickerProviderStateMixin {
  // RN: 등장 ~300ms(reanimated 기본)·노출 2000ms·퇴장 500ms.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 500),
  );
  Timer? _hideTimer;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _hideTimer = Timer(const Duration(milliseconds: 2000), _hide);
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
      // RN: bottomOffset + safeAreaBottom — 화면별 오프셋을 안전영역 위에 더한다.
      bottom: bottomInset + widget.bottomOffset,
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
                            // Overlay 엔트리는 Material 밖이라 DefaultTextStyle 폴백(노란 밑줄)을 상속한다 → none 으로 명시 차단.
                            style: const TextStyle(
                              fontFamily: FeedFonts.dovemayo,
                              fontSize: 13,
                              color: FeedPalette.lightBlack,
                              decoration: TextDecoration.none,
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
