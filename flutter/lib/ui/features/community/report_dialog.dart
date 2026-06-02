// 일기 신고 다이얼로그 — 사유 입력 후 작성자 차단 신고. RN screens/home/community/Report 화면을 경량 다이얼로그로 축약.
import 'package:feeddiary/data/repositories/community_repository.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/features/community/community_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 신고 사유를 입력받아 [CommunityRepository.reportDiary]를 호출한다. 성공 시 작성자가 차단되므로
/// community 목록을 무효화하고 상세에서 빠져나온다(RN useReport: 신고 → 완료 모달 → Community 이동).
Future<void> showReportDialog(BuildContext context, WidgetRef ref, {required int diaryIdx}) async {
  final myIdx = ref.read(authControllerProvider).user?.idx;
  if (myIdx == null) {
    return;
  }
  final controller = TextEditingController();
  final messenger = ScaffoldMessenger.of(context);

  final submitted = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (builderContext, setState) => AlertDialog(
        title: const Text('신고/차단하기'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              maxLines: 4,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(hintText: '신고 사유를 입력해 주세요.', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            Text(
              '신고가 접수되면 해당 글의 작성자는 차단돼요.',
              style: TextStyle(fontSize: 12, color: builderContext.colors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('닫기')),
          TextButton(
            onPressed: controller.text.trim().isEmpty ? null : () => Navigator.pop(dialogContext, true),
            child: const Text('신고하기'),
          ),
        ],
      ),
    ),
  );

  final reason = controller.text;
  controller.dispose();
  if (submitted != true) {
    return;
  }

  try {
    await ref.read(communityRepositoryProvider).reportDiary(diaryIdx: diaryIdx, text: reason, blockIdx: myIdx);
    ref.invalidate(communityListProvider);
    if (context.mounted) {
      context.pop();
    }
    messenger.showSnackBar(const SnackBar(content: Text('신고가 접수되었어요. 작성자를 차단했어요.')));
  } on AppException catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(e.displayMessage)));
  }
}
