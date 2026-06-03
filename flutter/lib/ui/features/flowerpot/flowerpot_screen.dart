// 나의 화분 화면 — 풀 캔버스(하늘/땅 배경 + 식물 + 왼쪽 버튼 스택 + exp 바). RN MyFlowerpot(Background+FlowerCanvas) 대응.
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/domain/models/mission_type.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_state_views.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_controller.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_layout.dart';
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
      // 로딩 중엔 파란 Scaffold 대신 배경(하늘/책상)을 먼저 깔아 장면이 준비된 듯 보이게 하고, 데이터가 오면 식물·버튼·exp 가 얹힌다.
      body: async.when(
        skipLoadingOnReload: true,
        loading: () => const _CanvasBackground(),
        error: (e, _) => DiaryErrorView(onRetry: () => ref.invalidate(flowerpotControllerProvider)),
        data: (flowerpot) {
          final stats = FlowerpotStats.from(flowerpot);
          final topInset = MediaQuery.paddingOf(context).top;
          // 탭바가 화분 캔버스 높이를 줄이므로(전체 화면 높이가 아님) 실제 가용 높이(LayoutBuilder)로 verticalCenter 를
          // 계산해야 식물이 배경 책상선(하늘:땅 13:10 경계)에 정확히 얹힌다. RN 은 풀스크린 오버레이 탭바라 동치.
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              // 가용 높이가 이미 하단 영역을 제외하므로 bottomInset 은 0 으로 전사(RN calculateVerticalCenter).
              final verticalCenter = FlowerpotLayout.verticalCenter(constraints.maxHeight, 0);
              return Stack(
                fit: StackFit.expand,
                children: [
                  const _CanvasBackground(),
                  // 식물 — RN LemonyBox: top=verticalCenter, left=W/2, translate(-90,-180).
                  Positioned(
                    top: verticalCenter,
                    left: width / 2,
                    child: Transform.translate(
                      offset: const Offset(FlowerpotLayout.plantTranslateX, FlowerpotLayout.plantTranslateY),
                      child: PlantView(level: stats.level, actionTick: _actionTick, lastAction: _lastAction),
                    ),
                  ),
                  // 왼쪽 버튼 스택 — RN SidePanel: top=verticalCenter−260, left 0, padding 15, gap 10(미션/물/사랑).
                  Positioned(
                    top: verticalCenter - FlowerpotLayout.sidePanelOffset,
                    left: 0,
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
                  // 경험치 바 — RN ExpBox: top=45+safeTop, 가로 중앙 75%.
                  Positioned(
                    top: topInset + FlowerpotLayout.expTopOffset,
                    left: width * 0.125,
                    right: width * 0.125,
                    child: ExpProgress(stats: stats),
                  ),
                ],
              );
            },
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
              Image.asset(AppAssets.flowerpotBgTop, fit: BoxFit.fill),
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                height: 300,
                // RN birds: 마운트 후 FadeIn 500ms 로 opacity 0.8 까지 한 번 페이드.
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 0.8),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, opacity, child) => Opacity(opacity: opacity, child: child),
                  child: Lottie.asset(AppAssets.lottieBirds, fit: BoxFit.contain),
                ),
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
              Image.asset(AppAssets.flowerpotBgBottom, fit: BoxFit.fill),
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
