// 화분 식물 뷰 — 레벨별 캐릭터(1=화분+씨앗·2=새싹·3=열매+하트) + 물/사랑 Lottie 피드백. RN LemonyBox/LottieBox 대응.
import 'dart:math' as math;

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
  // 물/사랑 Lottie 재생 컨트롤러. 기본 2s, 컴포지션 로드 시 실제 길이로 교체한다(첫 forward null-duration 방지).
  // RN 식물은 액션 시 scale 바운스를 하지 않는다 — 피드백 Lottie(비/하트)만 재생한다.
  late final AnimationController _feedback;

  // 1레벨 씨앗 흔들림(상시 2트랙). RN useLemonySeedAnimation: 회전 ±2°(500ms ease) + 좌우 ±30px(5s linear), 둘 다 무한 reverse.
  late final AnimationController _seedRot;
  late final AnimationController _seedX;

  @override
  void initState() {
    super.initState();
    // 모두 initState 에서 즉시 생성한다(레벨/액션에 따라 build 에서 미참조될 수 있어 late 지연 초기화가 dispose 중 발동하는 버그 회피).
    _feedback = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _seedRot = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat(reverse: true);
    _seedX = AnimationController(vsync: this, duration: const Duration(milliseconds: 5000))..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(PlantView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.actionTick != oldWidget.actionTick) {
      _feedback.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _feedback.dispose();
    _seedRot.dispose();
    _seedX.dispose();
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
          // 레벨별 캐릭터 — 레벨 변경 시에만 전환(액션 바운스 없음, RN 파리티).
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: KeyedSubtree(key: ValueKey(widget.level), child: _levelArt(widget.level)),
          ),
          // 물/사랑 피드백 Lottie — 액션 시 1회 재생(재생 중에만 표시). RN LottieBox: 컨테이너 top0+가로중앙(=상단 중앙) + translate(5,10).
          if (widget.lastAction != null)
            Align(
              alignment: Alignment.topCenter,
              child: AnimatedBuilder(
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
            animation: Listenable.merge([_seedRot, _seedX]),
            builder: (context, child) {
              // 회전 2°↔−2°(ease) + 좌우 30px↔−30px(linear). 컨트롤러 value 는 reverse 로 0↔1 진동.
              final angle = (2 - 4 * Curves.ease.transform(_seedRot.value)) * math.pi / 180;
              final dx = 30 - 60 * _seedX.value;
              return Transform.translate(
                offset: Offset(dx, 0),
                child: Transform.rotate(angle: angle, child: child),
              );
            },
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
