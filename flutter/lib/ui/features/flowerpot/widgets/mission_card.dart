// 미션 카드 — 베이지 원 아이콘 + 제목/진행도/설명 + 보상 받기/완료 버튼. RN Mission/MissionList/MissionBox 대응.
import 'package:feeddiary/data/models/mission.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_pressable.dart';
import 'package:feeddiary/ui/features/flowerpot/mission_presentation.dart';
import 'package:flutter/material.dart';

/// 미션 한 건 카드. 진행중 탭에서 달성(count==maxCount) 시 "보상 받기"가 활성화된다([onComplete]이 null 이면 완료 탭).
class MissionCard extends StatelessWidget {
  const MissionCard({required this.mission, this.onComplete, this.completing = false, super.key});

  final Mission mission;

  /// 진행중 탭에서 달성 미션의 보상 받기 콜백. 완료 탭이면 null("완료" 칩 표시).
  final VoidCallback? onComplete;
  final bool completing;

  @override
  Widget build(BuildContext context) {
    return Container(
      // RN MissionBox 는 공통 14가 아닌 16을 쓴다.
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(color: FeedPalette.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: FeedPalette.beige,
              shape: BoxShape.circle,
              border: Border.all(color: FeedPalette.lightBeige),
            ),
            child: Icon(mission.type.icon, color: FeedPalette.orange, size: mission.type.iconSize),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: mission.type.title,
                        style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 15, color: FeedPalette.black),
                      ),
                      TextSpan(
                        text: ' [${mission.count}/${mission.maxCount}]',
                        style: const TextStyle(
                          fontFamily: FeedFonts.dovemayo,
                          fontSize: 14,
                          color: FeedPalette.main,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mission.type.content,
                  style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 12, color: FeedPalette.gray),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _trailing(),
        ],
      ),
    );
  }

  Widget _trailing() {
    if (onComplete != null) {
      // 진행중 탭: 달성한 미션만 보상 받기 버튼(미달성은 RN 처럼 렌더 안 함).
      if (!mission.isAchieved) {
        return const SizedBox.shrink();
      }
      // RN: 완료 처리 중(isPending)엔 "보상 받기" 텍스트를 유지하고 탭만 막는다(스피너 없음).
      return _MissionChip(
        color: FeedPalette.main,
        onTap: completing ? null : onComplete,
        child: const Text(
          '보상 받기',
          style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.white),
        ),
      );
    }
    // 완료 탭: 정적 회색 "완료" 칩.
    return const _MissionChip(
      color: FeedPalette.whiteGray,
      child: Text(
        '완료',
        style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.gray),
      ),
    );
  }
}

/// 미션 우측 칩 — 75×38·radius 10. RN MissionButton(AnimatedPressable pressedScale 0.98·잔물결 없음).
class _MissionChip extends StatelessWidget {
  const _MissionChip({required this.color, required this.child, this.onTap});

  final Color color;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FeedPressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: Container(
        width: 75,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: child,
      ),
    );
  }
}
