// 화분 식물 뷰 — 레벨별 캐릭터 PNG(레모니 1~3) + 물주기/사랑주기 Lottie 피드백. RN LemonyBox/LottieBox 대응.
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/domain/models/mission_type.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// 레벨별 레모니 캐릭터([AppAssets.lemonyForLevel])를 [AnimatedSwitcher]로 부드럽게 전환하고,
/// 물/사랑 액션([actionTick] 증가) 시 캐릭터가 살짝 튀며 물(rain)/하트(heart) Lottie 가 1회 재생된다.
class PlantView extends StatefulWidget {
  const PlantView({required this.level, required this.actionTick, this.lastAction, super.key});

  final int level;

  /// 물/사랑 성공마다 증가 — 값이 바뀌면 바운스 + 피드백 Lottie 를 재생한다.
  final int actionTick;
  final PlantAction? lastAction;

  @override
  State<PlantView> createState() => _PlantViewState();
}

class _PlantViewState extends State<PlantView> with TickerProviderStateMixin {
  // 캐릭터 바운스(삼각파). 액션마다 0→1 forward.
  late final AnimationController _bounce = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  // 물/사랑 Lottie 재생 컨트롤러. 기본 2s, 컴포지션 로드 시 실제 길이로 교체한다(첫 forward null-duration 방지).
  late final AnimationController _feedback = AnimationController(vsync: this, duration: const Duration(seconds: 2));

  @override
  void didUpdateWidget(PlantView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.actionTick != oldWidget.actionTick) {
      _bounce.forward(from: 0);
      _feedback.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounce.dispose();
    _feedback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 레벨별 캐릭터 — 액션 시 살짝 커졌다 돌아오는 바운스(삼각파).
          AnimatedBuilder(
            animation: _bounce,
            builder: (context, child) {
              final t = _bounce.isAnimating ? _bounce.value : 0.0;
              final scale = 1 + 0.12 * (1 - (2 * t - 1).abs());
              return Transform.scale(scale: scale, child: child);
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Image.asset(
                AppAssets.lemonyForLevel(widget.level),
                key: ValueKey(widget.level),
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // 물/사랑 피드백 Lottie — 액션 시 1회 재생(재생 중에만 표시). RN usePlantInteraction 2.5s Lottie.
          if (widget.lastAction != null)
            AnimatedBuilder(
              animation: _feedback,
              builder: (context, child) => _feedback.isAnimating ? child! : const SizedBox.shrink(),
              child: IgnorePointer(
                child: Lottie.asset(
                  widget.lastAction == PlantAction.watering ? AppAssets.lottieRain : AppAssets.lottieHeart,
                  controller: _feedback,
                  onLoaded: (composition) => _feedback.duration = composition.duration,
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
