// 미션 카드 — 아이콘 + 제목/설명/진행도 + 완료(보상 받기) 버튼. RN Mission/MissionList/MissionBox 대응.
import 'package:feeddiary/data/models/mission.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/features/flowerpot/mission_presentation.dart';
import 'package:flutter/material.dart';

/// 미션 한 건 카드. 진행중 탭에서 달성(count==maxCount) 시 "보상 받기"가 활성화된다([onComplete]이 null 이면 완료 탭).
class MissionCard extends StatelessWidget {
  const MissionCard({required this.mission, this.onComplete, this.completing = false, super.key});

  final Mission mission;

  /// 진행중 탭에서 달성 미션의 보상 받기 콜백. 완료 탭이면 null(체크 아이콘 표시).
  final VoidCallback? onComplete;
  final bool completing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppDimens.borderRadius),
      ),
      child: Row(
        children: [
          Icon(mission.type.icon, color: context.colors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mission.type.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(mission.type.content, style: TextStyle(fontSize: 12, color: context.colors.textSecondary)),
                const SizedBox(height: 6),
                Text(
                  '${mission.count} / ${mission.maxCount}',
                  style: TextStyle(fontSize: 12, color: context.colors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (onComplete != null)
            FilledButton(
              onPressed: mission.isAchieved && !completing ? onComplete : null,
              child: completing
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('보상 받기'),
            )
          else
            Icon(Icons.check_circle, color: context.colors.primary),
        ],
      ),
    );
  }
}
