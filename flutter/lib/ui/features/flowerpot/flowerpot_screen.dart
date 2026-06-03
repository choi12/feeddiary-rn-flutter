// 나의 화분 화면 — 풀 캔버스(하늘/땅 배경 + 식물 + 왼쪽 버튼 스택 + exp 바). RN MyFlowerpot(Background+FlowerCanvas) 대응.
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/domain/models/mission_type.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_state_views.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_controller.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_stats.dart';
import 'package:feeddiary/ui/features/flowerpot/widgets/exp_progress.dart';
import 'package:feeddiary/ui/features/flowerpot/widgets/plant_action_button.dart';
import 'package:feeddiary/ui/features/flowerpot/widgets/plant_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

/// 나의 화분 탭. 하늘/땅 배경 위에 식물(중앙)·물/사랑/미션 버튼(왼쪽)·경험치 바(상단)를 절대 배치한 풀 캔버스.
/// 물/사랑은 비낙관(서버가 exp/레벨/충전 계산) — 성공 시 식물 피드백 애니메이션을 재생한다. RN MyFlowerpot.
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
      backgroundColor: FeedPalette.skyblue,
      body: async.when(
        skipLoadingOnReload: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => DiaryErrorView(onRetry: () => ref.invalidate(flowerpotControllerProvider)),
        data: (flowerpot) {
          final stats = FlowerpotStats.from(flowerpot);
          final width = MediaQuery.sizeOf(context).width;
          final topInset = MediaQuery.paddingOf(context).top;
          return Stack(
            fit: StackFit.expand,
            children: [
              const _CanvasBackground(),
              // 식물 — 중앙에서 살짝 위(RN LemonyBox translateY).
              Align(
                alignment: const Alignment(0, -0.2),
                child: PlantView(level: stats.level, actionTick: _actionTick, lastAction: _lastAction),
              ),
              // 왼쪽 버튼 스택 — 미션 / 물주기 / 사랑주기(RN SidePanel).
              Align(
                alignment: const Alignment(-1, -0.35),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MissionEntryButton(showBadge: stats.showBadge, onTap: () => context.push(Routes.mission)),
                      const SizedBox(height: 10),
                      PlantActionButton(
                        action: PlantAction.watering,
                        count: stats.wateringCount,
                        enabled: stats.canWater,
                        onPressed: () => _act(PlantAction.watering),
                      ),
                      const SizedBox(height: 10),
                      PlantActionButton(
                        action: PlantAction.love,
                        count: stats.loveCount,
                        enabled: stats.canLove,
                        onPressed: () => _act(PlantAction.love),
                      ),
                    ],
                  ),
                ),
              ),
              // 경험치 바 — 상단 중앙 75%(RN ExpBox top=45+safeTop).
              Positioned(
                top: topInset + 45,
                left: width * 0.125,
                right: width * 0.125,
                child: ExpProgress(stats: stats),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 배경 — 하늘(flex 13)·땅(flex 10) 풀블리드 + 앰비언트 새/풍선 Lottie. RN Background.
class _CanvasBackground extends StatelessWidget {
  const _CanvasBackground();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 13,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(AppAssets.flowerpotBgTop, fit: BoxFit.cover),
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                height: 300,
                child: Opacity(opacity: 0.8, child: Lottie.asset(AppAssets.lottieBirds, fit: BoxFit.contain)),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 10,
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              Image.asset(AppAssets.flowerpotBgBottom, fit: BoxFit.cover),
              Positioned(
                top: -75,
                right: 50,
                child: Opacity(
                  opacity: 0.9,
                  child: SizedBox(
                    width: 80,
                    height: 110,
                    child: Lottie.asset(AppAssets.lottieBaloon, fit: BoxFit.contain),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
