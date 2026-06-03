// 미션 보상 모달 — 받은 보상(물/사랑 ×수) 표시 + 닫기/사용하러 가기. RN AlertModal+RewardImageBox 대응(결정⑤).
import 'package:feeddiary/data/models/mission.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_alert_dialog.dart';
import 'package:feeddiary/ui/features/flowerpot/mission_presentation.dart';
import 'package:flutter/material.dart';

/// 미션 완료 보상 모달. 반환값 true = "사용하러 가기"(화분 복귀) 선택. RN useCompleteMission.openCompleteMissionSuccessModal.
Future<bool?> showRewardDialog(BuildContext context, RewardItem reward) {
  return showFeedAlert<bool>(
    context: context,
    image: _RewardBox(reward: reward),
    message: '미션 보상을 획득했어요!',
    actions: [
      FeedAlertAction(text: '닫기', isCancel: true, onPressed: () => Navigator.of(context).pop(false)),
      FeedAlertAction(text: '사용하러 가기', onPressed: () => Navigator.of(context).pop(true)),
    ],
  );
}

/// 보상 표시 박스 — 55×55 테두리 박스 안의 보상 아이콘·이름 + "×개수". RN `RewardImageBox` 대응.
class _RewardBox extends StatelessWidget {
  const _RewardBox({required this.reward});

  final RewardItem reward;

  @override
  Widget build(BuildContext context) {
    final imageSize = reward.item.rewardModalImageSize;
    final imageMargin = reward.item.rewardModalImageVerticalMargin;
    // RN modalImageBox: row·alignItems flex-end·marginBottom 13(보상박스 자체 하단 여백).
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // RN itemBox 55×55 안에 이미지 + 이름을 중앙 스택(이름이 박스 내부).
          Container(
            width: 55,
            height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: FeedPalette.whiteGray, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: imageMargin),
                  child: Image.asset(reward.item.asset, width: imageSize, height: imageSize, fit: BoxFit.contain),
                ),
                Text(
                  reward.item.label,
                  style: const TextStyle(
                    fontFamily: FeedFonts.dovemayo,
                    fontSize: 10,
                    color: FeedPalette.black,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          // RN amountText margin 3(4방향).
          Padding(
            padding: const EdgeInsets.all(3),
            child: Text(
              '×${reward.count}',
              style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 14, color: FeedPalette.main),
            ),
          ),
        ],
      ),
    );
  }
}
