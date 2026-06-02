// 미션 보상 모달 — 받은 보상(물/사랑 ×수) 표시 + 닫기/사용하러 가기. RN AlertModal+RewardImageBox 대응(결정⑤).
import 'package:feeddiary/data/models/mission.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/features/flowerpot/mission_presentation.dart';
import 'package:flutter/material.dart';

/// 미션 완료 보상 모달. 반환값 true = "사용하러 가기"(화분 복귀) 선택. RN useCompleteMission.openCompleteMissionSuccessModal.
Future<bool?> showRewardDialog(BuildContext context, RewardItem reward) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('미션 보상을 획득했어요!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(reward.item.icon, size: 48, color: dialogContext.colors.primary),
          const SizedBox(height: 8),
          Text('${reward.item.label} ×${reward.count}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('닫기')),
        FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('사용하러 가기')),
      ],
    ),
  );
}
