// 화분 식물 뷰 — 레벨별 식물 표현 + 물주기/사랑주기 피드백 애니메이션(경량). RN LemonyBox/LottieBox 의 암묵 애니메이션 대체.
import 'package:feeddiary/domain/models/mission_type.dart';
import 'package:flutter/material.dart';

/// 레벨별 식물 이모지를 [AnimatedSwitcher]로 부드럽게 전환하고, 물/사랑 액션 시 식물이 살짝 튀며
/// 물방울/하트가 떠오르는 피드백을 보여준다. Lottie/캐릭터 PNG 는 polish PR⑧ 보류(경량 결정①).
class PlantView extends StatefulWidget {
  const PlantView({required this.level, required this.actionTick, this.lastAction, super.key});

  final int level;

  /// 물/사랑 성공마다 증가 — 값이 바뀌면 피드백 애니메이션을 재생한다.
  final int actionTick;
  final PlantAction? lastAction;

  @override
  State<PlantView> createState() => _PlantViewState();
}

class _PlantViewState extends State<PlantView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void didUpdateWidget(PlantView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.actionTick != oldWidget.actionTick) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _emoji(int level) => switch (level) {
    1 => '🌱',
    2 => '🌿',
    _ => '🌷',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // 식물: 액션 시 살짝 커졌다 돌아오는 바운스(삼각파).
          final bounce = 1 + 0.12 * (1 - (2 * _controller.value - 1).abs());
          // 피드백 아이콘: 위로 떠오르며 사라짐.
          final feedbackOpacity = (1 - _controller.value).clamp(0.0, 1.0);
          final feedbackOffset = -60.0 * _controller.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: bounce,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: Text(_emoji(widget.level), key: ValueKey(widget.level), style: const TextStyle(fontSize: 96)),
                ),
              ),
              if (widget.lastAction != null && _controller.isAnimating)
                Transform.translate(
                  offset: Offset(0, feedbackOffset),
                  child: Opacity(
                    opacity: feedbackOpacity,
                    child: Text(
                      widget.lastAction == PlantAction.watering ? '💧' : '❤️',
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
