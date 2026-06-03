// 공통 press 피드백 — 누르면 scale·opacity 가 살짝 줄었다 떼면 복귀. RN components/common/AnimatedPressable.
import 'package:flutter/material.dart';

/// 누름 시 [pressedScale]·[pressedOpacity] 로 150ms 동안 줄었다 떼면 복귀하는 공통 래퍼.
/// RN `AnimatedPressable`(scale 0.99·opacity 0.9·150ms `Easing.ease`, 잔물결 없음) 1:1 — InkWell ripple 대신 쓴다.
/// [onTap] 이 null 이면 비활성(피드백·탭 없음).
class FeedPressable extends StatefulWidget {
  const FeedPressable({
    required this.onTap,
    required this.child,
    this.pressedScale = 0.99,
    this.pressedOpacity = 0.9,
    this.behavior = HitTestBehavior.opaque,
    super.key,
  });

  final VoidCallback? onTap;
  final Widget child;
  final double pressedScale;
  final double pressedOpacity;
  final HitTestBehavior behavior;

  @override
  State<FeedPressable> createState() => _FeedPressableState();
}

class _FeedPressableState extends State<FeedPressable> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null || _pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final pressed = enabled && _pressed;
    // RN Easing.ease = cubic-bezier(0.42,0,1,1) = Curves.easeIn(편지 swing 매핑과 동일).
    const duration = Duration(milliseconds: 150);
    return GestureDetector(
      behavior: widget.behavior,
      onTap: widget.onTap,
      onTapDown: enabled ? (_) => _setPressed(true) : null,
      onTapUp: enabled ? (_) => _setPressed(false) : null,
      onTapCancel: enabled ? () => _setPressed(false) : null,
      child: AnimatedScale(
        scale: pressed ? widget.pressedScale : 1,
        duration: duration,
        curve: Curves.easeIn,
        child: AnimatedOpacity(
          opacity: pressed ? widget.pressedOpacity : 1,
          duration: duration,
          curve: Curves.easeIn,
          child: widget.child,
        ),
      ),
    );
  }
}
