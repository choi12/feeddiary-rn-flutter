// 일기 신고/차단 화면 — 사유 입력 후 작성자 차단 신고. 성공 시 완료 알림 후 공유 목록으로. RN community Report 화면 1:1.
import 'package:feeddiary/data/repositories/community_repository.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_alert_dialog.dart';
import 'package:feeddiary/ui/core/widgets/feed_button.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
import 'package:feeddiary/ui/features/community/community_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 신고 사유를 입력받아 [CommunityRepository.reportDiary]를 호출한다. 성공 시 작성자가 차단되므로
/// 공유 목록을 무효화하고 완료 알림 후 신고·상세를 닫아 공유 목록으로 돌아간다(RN useReport: 신고 → 완료 모달 → Community 이동).
class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({required this.diaryIdx, super.key});

  final int diaryIdx;

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  Future<void> _report() async {
    final myIdx = ref.read(authControllerProvider).user?.idx;
    if (myIdx == null) {
      return;
    }
    setState(() => _submitting = true);
    final router = GoRouter.of(context);
    try {
      await ref
          .read(communityRepositoryProvider)
          .reportDiary(diaryIdx: widget.diaryIdx, text: _controller.text.trim(), blockIdx: myIdx);
      ref.invalidate(communityListProvider);
      if (!mounted) {
        return;
      }
      await showFeedAlert<void>(
        context: context,
        message: '신고 접수 완료!\n해당 유저가 차단되었어요.',
        actions: [FeedAlertAction(text: '확인', onPressed: () => Navigator.of(context).pop())],
      );
      if (!mounted) {
        return;
      }
      // 신고 화면과 상세를 닫아 공유 목록(차단 반영)으로 돌아간다. 신고는 타인 일기 상세에서만 진입한다.
      router
        ..pop()
        ..pop();
    } on AppException catch (e) {
      if (mounted) {
        showFeedToast(context, e.displayMessage);
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // RN SafeAreaContainer 배경 = BACKGROUND(회색). 헤더는 투명이라 회색이 비친다(B2 Fix12와 동일).
      backgroundColor: FeedPalette.whiteGray,
      appBar: const FeedHeader(title: '신고/차단하기', hasCloseButton: true, backgroundColor: FeedPalette.whiteGray),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppDimens.padding, 24, AppDimens.padding, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // RN textInput: height 200 · border 1px WHITE_GRAY · radius 14 · paddingHorizontal 15 · 15/23 Dovemayo.
              Container(
                height: 200,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color: FeedPalette.white,
                  borderRadius: BorderRadius.circular(AppDimens.borderRadius),
                  border: Border.all(color: FeedPalette.whiteGray),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  autofocus: true,
                  textAlignVertical: TextAlignVertical.top,
                  cursorColor: FeedPalette.main,
                  style: const TextStyle(
                    fontFamily: FeedFonts.dovemayo,
                    fontSize: 15,
                    height: 23 / 15,
                    color: FeedPalette.lightBlack,
                  ),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: '신고 사유를 입력해 주세요.',
                    hintStyle: TextStyle(
                      fontFamily: FeedFonts.dovemayo,
                      fontSize: 15,
                      height: 23 / 15,
                      color: FeedPalette.lightGray,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // RN infoTextBox: row · marginBottom 10 · alert-circle 14 MAIN + Text(MAIN 13 marginLeft 3).
              const Row(
                children: [
                  Icon(FeedIcons.alert, size: 14, color: FeedPalette.main),
                  SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      '신고가 접수되면, 해당 글의 작성자는 차단돼요.',
                      style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.main),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FeedButton(title: '신고하기', onPressed: _report, disabled: !_hasText, isLoading: _submitting),
            ],
          ),
        ),
      ),
    );
  }
}
