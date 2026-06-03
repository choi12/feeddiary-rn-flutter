// 화분 식물 뷰 — 레벨별 캐릭터(1=화분+씨앗·2=새싹·3=열매+하트) + 물/사랑 Lottie 피드백. RN LemonyBox/LottieBox 대응.
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/domain/models/mission_type.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// 레벨별 레모니 아트를 [AnimatedSwitcher]로 부드럽게 전환하고, 물/사랑 액션([actionTick] 증가) 시
/// 캐릭터가 살짝 튀며 물(rain)/하트(heart) Lottie 가 1회 재생된다. RN FirstLemony/SecondLemony/ThirdLemony.
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
  late final AnimationController _bounce;

  // 물/사랑 Lottie 재생 컨트롤러. 기본 2s, 컴포지션 로드 시 실제 길이로 교체한다(첫 forward null-duration 방지).
  late final AnimationController _feedback;

  // 1레벨 씨앗 미세 바운스(상시). RN useLemonySeedAnimation.
  late final AnimationController _seedBob;

  @override
  void initState() {
    super.initState();
    // 모두 initState 에서 즉시 생성한다(레벨/액션에 따라 build 에서 미참조될 수 있어 late 지연 초기화가 dispose 중 발동하는 버그 회피).
    _bounce = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _feedback = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _seedBob = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
  }

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
    _seedBob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
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
              child: KeyedSubtree(key: ValueKey(widget.level), child: _levelArt(widget.level)),
            ),
          ),
          // 물/사랑 피드백 Lottie — 액션 시 1회 재생(재생 중에만 표시). RN LottieBox.
          if (widget.lastAction != null)
            AnimatedBuilder(
              animation: _feedback,
              builder: (context, child) => _feedback.isAnimating ? child! : const SizedBox.shrink(),
              child: Transform.translate(
                offset: const Offset(5, 10),
                child: IgnorePointer(
                  child: Lottie.asset(
                    widget.lastAction == PlantAction.watering ? AppAssets.lottieRain : AppAssets.lottieHeart,
                    controller: _feedback,
                    onLoaded: (composition) => _feedback.duration = composition.duration,
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _levelArt(int level) {
    return switch (level) {
      1 => Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(AppAssets.lemony1Flowerpot, width: 180, height: 220, fit: BoxFit.contain),
          AnimatedBuilder(
            animation: _seedBob,
            builder: (context, child) => Transform.translate(offset: Offset(0, -4 * _seedBob.value), child: child),
            child: Image.asset(AppAssets.lemonySeed, width: 30, height: 43, fit: BoxFit.contain),
          ),
        ],
      ),
      3 => Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: -50,
            child: Opacity(
              opacity: 0.9,
              child: Lottie.asset(AppAssets.lottieHeart, width: 90, height: 210, fit: BoxFit.contain),
            ),
          ),
          Image.asset(AppAssets.lemony3New, width: 40, height: 70, fit: BoxFit.contain),
        ],
      ),
      _ => Image.asset(AppAssets.lemonyForLevel(level), width: 180, height: 220, fit: BoxFit.contain),
    };
  }
}
