// 오늘의 미션 화면 — 진행중/완료 탭 + 미션 목록 + 완료(보상 모달·완료 시 화분 무효화). RN Mission 대응(결정②).
import 'package:feeddiary/data/models/mission.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
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
        showFeedToast(context, e.displayMessage, offset: FeedToastOffset.inner);
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
      backgroundColor: FeedPalette.background,
      appBar: const FeedHeader(title: '오늘의 미션', hasCloseButton: true, backgroundColor: FeedPalette.background),
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
                    // RN MissionList: ListHeaderComponent(초기화 안내) + contentContainer marginTop 20·gap 10.
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(AppDimens.padding, 20, AppDimens.padding, AppDimens.padding),
                        itemCount: list.length + 1,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return const _MissionResetNote();
                          }
                          final mission = list[index - 1];
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

/// 진행 중/완료 탭 — 2분할 토글. RN `TabButtonBox`(비활성 SILVER_GRAY/활성 SLATE_GRAY) 대응.
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
      // RN: Container paddingTop 10·탭 아래 여백은 MissionList marginTop 20 이 담당(탭 자체 하단 여백 0).
      padding: const EdgeInsets.fromLTRB(AppDimens.padding, 10, AppDimens.padding, 0),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: '진행 중',
              count: inProgressCount,
              active: tab == _MissionTab.inProgress,
              onTap: () => onSelect(_MissionTab.inProgress),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _TabButton(
              label: '완료',
              count: completedCount,
              active: tab == _MissionTab.completed,
              onTap: () => onSelect(_MissionTab.completed),
            ),
          ),
        ],
      ),
    );
  }
}

/// 탭 버튼 한 개 — "라벨 N"(개수는 MAIN, 0이면 비활성·회색). RN `TabButton` 1:1.
class _TabButton extends StatelessWidget {
  const _TabButton({required this.label, required this.count, required this.active, required this.onTap});

  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = count < 1;
    // RN TabButton 은 Pressable(누름 피드백·잔물결 없음) → GestureDetector 로 잉크 리플 제거.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: disabled ? null : onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: active ? FeedPalette.slateGray : FeedPalette.silverGray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label ',
                  style: TextStyle(
                    fontFamily: FeedFonts.dovemayo,
                    fontSize: 15,
                    color: active ? FeedPalette.white : FeedPalette.mediumGray,
                  ),
                ),
                TextSpan(
                  text: '$count',
                  style: TextStyle(
                    fontFamily: FeedFonts.dovemayo,
                    fontSize: 16,
                    color: disabled ? FeedPalette.lightGray : FeedPalette.main,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 미션 리스트 상단 안내 — "* 매일 오전 5시(노란 밑줄)에 미션이 초기화돼요." RN `MissionListHeaderText`(gray 13·marginBottom 3).
class _MissionResetNote extends StatelessWidget {
  const _MissionResetNote();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 3),
      child: Text.rich(
        TextSpan(
          style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.gray),
          children: [
            TextSpan(text: '* 매일 '),
            TextSpan(
              text: '오전 5시',
              style: TextStyle(
                color: FeedPalette.yellow,
                decoration: TextDecoration.underline,
                decorationColor: FeedPalette.yellow,
              ),
            ),
            TextSpan(text: '에 미션이 초기화돼요.'),
          ],
        ),
      ),
    );
  }
}
