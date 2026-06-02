// 일기 신고 다이얼로그 — 사유 입력 후 작성자 차단 신고. RN screens/home/community/Report 화면을 경량 다이얼로그로 축약.
import 'package:feeddiary/data/repositories/community_repository.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_button.dart';
import 'package:feeddiary/ui/core/widgets/feed_text_field.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
import 'package:feeddiary/ui/features/community/community_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 신고 사유를 입력받아 [CommunityRepository.reportDiary]를 호출한다. 성공 시 작성자가 차단되므로
/// community 목록을 무효화하고 상세에서 빠져나온다(RN useReport: 신고 → 완료 토스트 → Community 이동).
Future<void> showReportDialog(BuildContext context, WidgetRef ref, {required int diaryIdx}) async {
  final myIdx = ref.read(authControllerProvider).user?.idx;
  if (myIdx == null) {
    return;
  }

  final reason = await showDialog<String>(
    context: context,
    barrierColor: FeedPalette.scrim,
    builder: (_) => const _ReportDialog(),
  );
  if (reason == null || reason.trim().isEmpty) {
    return;
  }

  try {
    await ref.read(communityRepositoryProvider).reportDiary(diaryIdx: diaryIdx, text: reason, blockIdx: myIdx);
    ref.invalidate(communityListProvider);
    if (context.mounted) {
      // 토스트는 루트 Overlay 라 pop 후에도 남는다(먼저 띄우고 상세에서 빠져나온다).
      showFeedToast(context, '신고가 접수되었어요. 작성자를 차단했어요.');
      context.pop();
    }
  } on AppException catch (e) {
    if (context.mounted) showFeedToast(context, e.displayMessage);
  }
}

/// 신고 사유 입력 다이얼로그 본문. RN `Report` 화면(입력 + 안내 + 신고 버튼)을 Feed 다이얼로그로 옮긴 것.
class _ReportDialog extends StatefulWidget {
  const _ReportDialog();

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: FeedPalette.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.borderRadius)),
      child: SizedBox(
        width: AppDimens.dialogWidth,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '신고/차단하기',
                      style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 17, color: FeedPalette.black),
                    ),
                  ),
                  InkResponse(
                    onTap: () => Navigator.of(context).pop(),
                    radius: 20,
                    child: const Icon(FeedIcons.close, size: 24, color: FeedPalette.black),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              FeedTextField(controller: _controller, minLines: 4, maxLines: 4, hintText: '신고 사유를 입력해 주세요.'),
              const SizedBox(height: 10),
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
              const SizedBox(height: 16),
              FeedButton(
                title: '신고하기',
                onPressed: () => Navigator.of(context).pop(_controller.text),
                disabled: !_hasText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
