// 오늘의 미션 화면 — 진행중/완료 탭 + 미션 목록 + 완료(보상 모달·완료 시 화분 무효화). RN Mission 대응(결정②).
import 'package:feeddiary/data/models/mission.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_state_views.dart';
import 'package:feeddiary/ui/features/flowerpot/flowerpot_controller.dart';
import 'package:feeddiary/ui/features/flowerpot/mission_controller.dart';
import 'package:feeddiary/ui/features/flowerpot/widgets/mission_card.dart';
import 'package:feeddiary/ui/features/flowerpot/widgets/reward_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _MissionTab { inProgress, completed }

/// 오늘의 미션. 진행중/완료 탭은 로컬 setState(RN useMissions 의 useState). 미션 완료 시 화분을 무효화해
/// 받은 충전이 화분에 반영되게 한다(RN 은 Mission unmount cleanup 에서 FLOWERPOT 무효화 — 충전이 바뀌는 완료 시점이 더 정확).
class MissionScreen extends ConsumerStatefulWidget {
  const MissionScreen({super.key});

  @override
  ConsumerState<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends ConsumerState<MissionScreen> {
  _MissionTab _tab = _MissionTab.inProgress;
  int? _completingIdx;

  Future<void> _complete(Mission mission) async {
    setState(() => _completingIdx = mission.idx);
    try {
      final reward = await ref
          .read(missionsControllerProvider.notifier)
          .complete(missionIdx: mission.idx, type: mission.type);
      // 보상 충전이 화분에 반영되도록 화분을 무효화한다(셸에 상존하는 화분 화면이 배경에서 재조회).
      // RN 은 미션 화면 unmount cleanup 에서 FLOWERPOT 을 무효화하지만, 충전이 바뀌는 완료 시점이 더 정확하다.
      ref.invalidate(flowerpotControllerProvider);
      if (!mounted) {
        return;
      }
      final useNow = await showRewardDialog(context, reward);
      if (useNow == true && mounted) {
        context.pop(); // 화분으로 복귀(RN navigateToHome).
      }
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.displayMessage)));
      }
    } finally {
      if (mounted) {
        setState(() => _completingIdx = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final missions = ref.watch(missionsControllerProvider);
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: const Text('오늘의 미션')),
      body: missions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => DiaryErrorView(onRetry: () => ref.invalidate(missionsControllerProvider)),
        data: (result) {
          // 진행중이 비면 완료 탭으로 자동 전환(RN useMissions effect).
          final tab = result.inProgress.isEmpty ? _MissionTab.completed : _tab;
          final list = tab == _MissionTab.inProgress ? result.inProgress : result.completed;
          return Column(
            children: [
              _TabBar(
                tab: tab,
                inProgressCount: result.inProgress.length,
                completedCount: result.completed.length,
                onSelect: (next) => setState(() => _tab = next),
              ),
              Expanded(
                child: list.isEmpty
                    ? DiaryEmptyView(message: tab == _MissionTab.inProgress ? '진행 중인 미션이 없어요.' : '완료한 미션이 없어요.')
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppDimens.padding),
                        itemCount: list.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final mission = list[index];
                          return MissionCard(
                            mission: mission,
                            completing: _completingIdx == mission.idx,
                            onComplete: tab == _MissionTab.inProgress ? () => _complete(mission) : null,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.tab,
    required this.inProgressCount,
    required this.completedCount,
    required this.onSelect,
  });

  final _MissionTab tab;
  final int inProgressCount;
  final int completedCount;
  final ValueChanged<_MissionTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding, vertical: 12),
      child: SegmentedButton<_MissionTab>(
        segments: [
          ButtonSegment(value: _MissionTab.inProgress, label: Text('진행 중 ($inProgressCount)')),
          ButtonSegment(value: _MissionTab.completed, label: Text('완료 ($completedCount)')),
        ],
        selected: {tab},
        onSelectionChanged: (selection) => onSelect(selection.first),
      ),
    );
  }
}
