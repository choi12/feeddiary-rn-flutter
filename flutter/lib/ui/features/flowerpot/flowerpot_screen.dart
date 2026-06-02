// 나의 화분 화면 — 레벨/경험치 + 식물 + 물주기/사랑주기 버튼 + 미션 진입. RN MyFlowerpot(FlowerCanvas) 대응.
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/domain/models/mission_type.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_state_views.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_controller.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_stats.dart';
import 'package:feeddiary/ui/features/flowerpot/mission_presentation.dart';
import 'package:feeddiary/ui/features/flowerpot/widgets/exp_progress.dart';
import 'package:feeddiary/ui/features/flowerpot/widgets/plant_action_button.dart';
import 'package:feeddiary/ui/features/flowerpot/widgets/plant_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 나의 화분 탭. 화분 서버상태를 watch 해 [FlowerpotStats]를 파생하고, 물/사랑 액션 성공 시 식물 피드백
/// 애니메이션을 재생한다. 물/사랑은 비낙관(서버가 exp/레벨/충전 계산) — 재조회 중에도 직전 화면을 유지한다.
class FlowerpotScreen extends ConsumerStatefulWidget {
  const FlowerpotScreen({super.key});

  @override
  ConsumerState<FlowerpotScreen> createState() => _FlowerpotScreenState();
}

class _FlowerpotScreenState extends ConsumerState<FlowerpotScreen> {
  // 물/사랑 성공마다 증가시켜 PlantView 의 피드백 애니메이션을 트리거한다.
  int _actionTick = 0;
  PlantAction? _lastAction;

  Future<void> _act(PlantAction action) async {
    final notifier = ref.read(flowerpotControllerProvider.notifier);
    try {
      await (action == PlantAction.watering ? notifier.water() : notifier.love());
      if (mounted) {
        setState(() {
          _lastAction = action;
          _actionTick++;
        });
      }
    } on AppException catch (e) {
      if (mounted) {
        showFeedToast(context, e.displayMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(flowerpotControllerProvider);
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: FeedHeader(
        title: '나의 화분',
        // 받을 보상이 있으면 배지(미션→화분 단서). RN SidePanel MissionButton showBadge.
        rightItem: InkResponse(
          onTap: () => context.push(Routes.mission),
          radius: 24,
          child: Badge(
            isLabelVisible: async.value?.showBadge ?? false,
            child: const Icon(Icons.assignment_outlined, color: FeedPalette.black),
          ),
        ),
      ),
      body: async.when(
        skipLoadingOnReload: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => DiaryErrorView(onRetry: () => ref.invalidate(flowerpotControllerProvider)),
        data: (flowerpot) {
          final stats = FlowerpotStats.from(flowerpot);
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.padding),
              child: Column(
                children: [
                  ExpProgress(stats: stats),
                  Expanded(
                    child: Center(
                      child: PlantView(level: stats.level, actionTick: _actionTick, lastAction: _lastAction),
                    ),
                  ),
                  Text(
                    stats.isMaxLevel ? '화분이 다 자랐어요! 🌷' : '물과 사랑을 주면 화분이 자라요.',
                    style: TextStyle(color: context.colors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PlantActionButton(
                        icon: PlantAction.watering.icon,
                        label: PlantAction.watering.label,
                        count: stats.wateringCount,
                        enabled: stats.canWater,
                        onPressed: () => _act(PlantAction.watering),
                      ),
                      PlantActionButton(
                        icon: PlantAction.love.icon,
                        label: PlantAction.love.label,
                        count: stats.loveCount,
                        enabled: stats.canLove,
                        onPressed: () => _act(PlantAction.love),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
