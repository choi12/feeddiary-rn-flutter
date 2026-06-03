// 화분 사이드 버튼 — 물주기/사랑주기(충전 수 배지) + 미션 진입(펄스 배지). RN SidePanel ActionButton/MissionButton 대응.
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/domain/models/mission_type.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/features/flowerpot/mission_presentation.dart';
import 'package:flutter/material.dart';

/// 물/사랑 액션 버튼 — 65 반투명 셸 + RN 이미지 + 충전 수 배지. [enabled]=false 면 흐리게(canWater/canLove). RN ActionButton.
class PlantActionButton extends StatelessWidget {
  const PlantActionButton({
    required this.action,
    required this.count,
    required this.enabled,
    required this.onPressed,
    super.key,
  });

  final PlantAction action;
  final int count;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _SideButtonShell(
      label: action.label,
      enabled: enabled,
      onTap: enabled ? onPressed : null,
      image: Image.asset(action.asset, width: action.buttonImageSize, height: action.buttonImageSize),
      badge: count > 0 ? Positioned(right: -8, top: -8, child: _CountBadge(count: count)) : null,
    );
  }
}

/// 미션 진입 버튼 — 65 반투명 셸 + 미션 이미지 + 펄스 점 배지(받을 보상이 있을 때). RN MissionButton.
class MissionEntryButton extends StatefulWidget {
  const MissionEntryButton({required this.showBadge, required this.onTap, super.key});

  final bool showBadge;
  final VoidCallback onTap;

  @override
  State<MissionEntryButton> createState() => _MissionEntryButtonState();
}

class _MissionEntryButtonState extends State<MissionEntryButton> with SingleTickerProviderStateMixin {
  // initState 에서 즉시 생성한다(showBadge=false 면 build 에서 미참조 → late 지연 초기화가 dispose 중 발동하는 버그 회피).
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SideButtonShell(
      label: '미션',
      onTap: widget.onTap,
      image: Image.asset(AppAssets.missionIcon, width: 25, height: 25),
      badge: widget.showBadge
          ? Positioned(
              right: 7,
              top: 6,
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.2, end: 0.6).animate(_pulse),
                child: const SizedBox(
                  width: 9,
                  height: 9,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: FeedPalette.red, shape: BoxShape.circle),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

/// 공통 셸 — 65×65 반투명 흰 라운드 사각(border white@0.7·bg white@0.3) + 이미지 + 라벨 + 배지 슬롯. RN ActionButton 셸.
class _SideButtonShell extends StatelessWidget {
  const _SideButtonShell({
    required this.label,
    required this.image,
    required this.onTap,
    this.enabled = true,
    this.badge,
  });

  final String label;
  final Widget image;
  final VoidCallback? onTap;
  final bool enabled;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    // RN ActionButton/MissionButton: 이미지 + 라벨이 65×65 버튼 안에 세로로 들어간다(중앙 정렬). 배지는 버튼 모서리 절대 배치.
    return Opacity(
      opacity: enabled ? 1 : 0.7,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: FeedPalette.white.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: FeedPalette.white.withValues(alpha: 0.7), width: 2),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 65,
                height: 65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    image,
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: FeedFonts.dovemayo,
                        fontSize: 11,
                        color: FeedPalette.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ?badge,
        ],
      ),
    );
  }
}

/// 충전 수 배지 — 19 빨강 원 + 흰 숫자. RN ActionButton countBox.
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 19,
      height: 19,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: FeedPalette.red, shape: BoxShape.circle),
      child: Text(
        '$count',
        style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 12, color: FeedPalette.white),
      ),
    );
  }
}
