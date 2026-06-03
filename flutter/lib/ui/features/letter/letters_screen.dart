// 편지함 화면 — 나에게 쓴 편지 목록(2열·미세 흔들림) + 작성 진입 + 편집 모드 삭제 + 편지 펼침 모달. RN screens/home/letter/Letters 대응(셸 탭).
import 'dart:async';

import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/data/models/letter.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_alert_dialog.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
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
    final confirmed = await showFeedAlert<bool>(
      context: context,
      message: LetterStrings.deleteConfirm,
      actions: [
        FeedAlertAction(
          text: LetterStrings.closeButton,
          isCancel: true,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        FeedAlertAction(text: LetterStrings.deleteButton, onPressed: () => Navigator.of(context).pop(true)),
      ],
    );
    if (confirmed != true || !mounted) {
      return;
    }
    try {
      await ref.read(letterListProvider.notifier).delete(letter.idx);
      if (mounted) showFeedToast(context, LetterStrings.deletedToast);
    } on AppException catch (e) {
      if (mounted) showFeedToast(context, e.displayMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(letterListProvider);
    final notifier = ref.watch(letterListProvider.notifier);
    final hasLetter = notifier.hasLetter;
    final isTodayWritten = notifier.isTodayLetterWritten;
    final editMode = hasLetter && _editMode;

    // RN: LetterHeader=CustomHeader 는 배경 미지정(투명)이라 letterBoard 가 헤더 뒤로 비친다.
    // FeedHeader 를 appBar 가 아닌 body 의 letterBoard 위 첫 자식으로 두어 동일하게 비치게 한다.
    return Scaffold(
      backgroundColor: FeedPalette.background,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.letterBoard), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            FeedHeader(
              title: LetterStrings.headerTitle,
              titleWidget: const _LetterHeaderTitle(),
              backgroundColor: Colors.transparent,
              rightItem: hasLetter
                  ? TextButton(
                      onPressed: () => setState(() => _editMode = !_editMode),
                      child: Text(
                        editMode ? LetterStrings.editOff : LetterStrings.editOn,
                        style: TextStyle(
                          fontFamily: FeedFonts.dovemayo,
                          fontSize: 13,
                          color: editMode ? FeedPalette.orange : FeedPalette.main,
                          decoration: TextDecoration.underline,
                          // 밑줄 색을 글자색과 동일하게(미지정 시 폴백 검정으로 떠 RN 과 다름).
                          decorationColor: editMode ? FeedPalette.orange : FeedPalette.main,
                        ),
                      ),
                    )
                  : null,
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    // RN Container(paddingHorizontal 24·세로 패딩 없음) → 헤더↔버튼 0·버튼↔리스트는 리스트 paddingTop 30.
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding),
                      child: _WriteLetterButton(done: isTodayWritten, onTap: () => context.push(Routes.letterWrite)),
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
            ),
          ],
        ),
      ),
    );
  }
}

/// 편지함 헤더 제목 — "나에게 쓰는 편지" + 우측 편지 아이콘(letter.png 30×30 contain). RN LetterHeaderTitleBox.
class _LetterHeaderTitle extends StatelessWidget {
  const _LetterHeaderTitle();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          LetterStrings.headerTitle,
          style: TextStyle(
            fontFamily: FeedFonts.ownglyph,
            fontSize: 24,
            color: FeedPalette.lightBlack,
            letterSpacing: -0.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 3),
          child: Image(image: AssetImage(AppAssets.letterIcon), width: 30, height: 30, fit: BoxFit.contain),
        ),
      ],
    );
  }
}

/// "오늘의 나에게 편지 쓰기" 버튼 — 하늘색 알약·Ownglyph·오른쪽 캐럿. 작성 완료면 회색 비활성. RN `CreateLetterButton` 대응.
class _WriteLetterButton extends StatelessWidget {
  const _WriteLetterButton({required this.done, required this.onTap});

  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: done ? FeedPalette.lightGray : FeedPalette.skyblue,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        onTap: done ? null : onTap,
        borderRadius: BorderRadius.circular(25),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                done ? LetterStrings.writeDone : LetterStrings.writeCta,
                style: const TextStyle(
                  fontFamily: FeedFonts.ownglyph,
                  fontSize: 18,
                  color: FeedPalette.white,
                  letterSpacing: -0.2,
                ),
              ),
              if (!done)
                const Padding(
                  padding: EdgeInsets.only(left: 3),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Icon(FeedIcons.caretDown, size: 20, color: FeedPalette.white),
                  ),
                ),
            ],
          ),
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
    // RN numColumns 2 마소너리 — 각 행 높이가 우측 카드 marginTop 80 으로 늘어 양 칼럼 모두 카드 간 80px 갭이 생긴다.
    // 우측 칼럼은 추가로 80 아래에서 시작(oddColumnOffset). 좌/우 50% 셀에 카드를 중앙 배치(칼럼 사이 갭 없음).
    final left = <Widget>[];
    final right = <Widget>[];
    for (var i = 0; i < letters.length; i++) {
      final column = i.isEven ? left : right;
      if (column.isNotEmpty) {
        column.add(const SizedBox(height: 80));
      }
      column.add(
        LetterCard(
          key: ValueKey(letters[i].idx),
          letter: letters[i],
          index: i,
          editMode: editMode,
          onOpen: onOpen,
          onDelete: onDelete,
        ),
      );
    }
    return SingleChildScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      // RN LetterList: paddingTop 30 · paddingBottom 35(+탭바 75 는 셸 belowTabBar 처리).
      padding: const EdgeInsets.fromLTRB(AppDimens.padding, 30, AppDimens.padding, 35),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(children: left)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
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
