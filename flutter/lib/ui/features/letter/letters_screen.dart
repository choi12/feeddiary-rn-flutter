// 편지함 화면 — 나에게 쓴 편지 목록(2열·미세 흔들림) + 작성 진입 + 편집 모드 삭제 + 편지 펼침 모달. RN screens/home/letter/Letters 대응(셸 탭).
import 'dart:async';

import 'package:feeddiary/data/models/letter.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_state_views.dart';
import 'package:feeddiary/ui/features/letter/letter_list_controller.dart';
import 'package:feeddiary/ui/features/letter/letter_strings.dart';
import 'package:feeddiary/ui/features/letter/widgets/letter_card.dart';
import 'package:feeddiary/ui/features/letter/widgets/letter_detail_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 나의 편지 탭. 편지 목록은 무한스크롤 서버상태(letterListProvider)이고, 편집 모드는 순수 로컬 UI 상태(setState)다.
/// 카드 탭→누른 위치에서 편지가 펼쳐지는 모달, 편집 모드→카드 삭제(낙관). 작성은 별도 화면 push(하루 한 통 게이팅).
class LettersScreen extends ConsumerStatefulWidget {
  const LettersScreen({super.key});

  @override
  ConsumerState<LettersScreen> createState() => _LettersScreenState();
}

class _LettersScreenState extends ConsumerState<LettersScreen> {
  final ScrollController _controller = ScrollController();
  bool _editMode = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _controller.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      unawaited(ref.read(letterListProvider.notifier).loadMore());
    }
  }

  Future<void> _confirmDelete(Letter letter) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: const Text(LetterStrings.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(LetterStrings.closeButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(LetterStrings.deleteButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(letterListProvider.notifier).delete(letter.idx);
      messenger.showSnackBar(const SnackBar(content: Text(LetterStrings.deletedToast)));
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.displayMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(letterListProvider);
    final notifier = ref.watch(letterListProvider.notifier);
    final hasLetter = notifier.hasLetter;
    final isTodayWritten = notifier.isTodayLetterWritten;
    final editMode = hasLetter && _editMode;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text(LetterStrings.headerTitle),
        actions: [
          if (hasLetter)
            TextButton(
              onPressed: () => setState(() => _editMode = !_editMode),
              child: Text(editMode ? LetterStrings.editOff : LetterStrings.editOn),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.padding, 12, AppDimens.padding, 4),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: isTodayWritten ? null : () => context.push(Routes.letterWrite),
                  icon: Icon(isTodayWritten ? Icons.check_circle_outline : Icons.edit_outlined),
                  label: Text(isTodayWritten ? LetterStrings.writeDone : LetterStrings.writeCta),
                ),
              ),
            ),
            Expanded(
              child: state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => DiaryErrorView(onRetry: () => ref.invalidate(letterListProvider)),
                data: (paged) {
                  if (paged.isEmpty) {
                    return const DiaryEmptyView(message: LetterStrings.empty);
                  }
                  return RefreshIndicator(
                    onRefresh: () => ref.read(letterListProvider.notifier).refreshList(),
                    child: _LetterBoard(
                      controller: _controller,
                      letters: paged.items,
                      isEnd: paged.isEnd,
                      editMode: editMode,
                      onOpen: (letter, origin) => showLetterDetail(context, letter, origin),
                      onDelete: _confirmDelete,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 편지 보드 — 2열 스태거드(오른쪽 칼럼을 아래로 오프셋, RN numColumns 2 + 홀수 marginTop). 끝이 아니면 하단 로더.
class _LetterBoard extends StatelessWidget {
  const _LetterBoard({
    required this.controller,
    required this.letters,
    required this.isEnd,
    required this.editMode,
    required this.onOpen,
    required this.onDelete,
  });

  final ScrollController controller;
  final List<Letter> letters;
  final bool isEnd;
  final bool editMode;
  final void Function(Letter letter, Offset origin) onOpen;
  final void Function(Letter letter) onDelete;

  @override
  Widget build(BuildContext context) {
    final left = <Widget>[];
    final right = <Widget>[];
    for (var i = 0; i < letters.length; i++) {
      final card = LetterCard(letter: letters[i], index: i, editMode: editMode, onOpen: onOpen, onDelete: onDelete);
      (i.isEven ? left : right).add(card);
    }
    return SingleChildScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppDimens.padding, 16, AppDimens.padding, 32),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(children: left)),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 44),
                  child: Column(children: right),
                ),
              ),
            ],
          ),
          if (!isEnd)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
