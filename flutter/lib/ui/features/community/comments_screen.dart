// 댓글 화면 — 특정 일기의 댓글 목록 + 작성 입력. RN screens/home/community/Comments 대응(별도 화면 push).
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/features/community/comments_controller.dart';
import 'package:feeddiary/ui/features/community/widgets/comment_card.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_state_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 댓글 화면. [author]는 일기 작성자 닉네임으로 댓글 카드의 인증 배지에 쓰인다(라우트 extra 로 전달).
class CommentsScreen extends ConsumerWidget {
  const CommentsScreen({required this.diaryIdx, this.author, super.key});

  final int diaryIdx;
  final String? author;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comments = ref.watch(commentsControllerProvider(diaryIdx));
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: const Text('댓글')),
      body: Column(
        children: [
          Expanded(
            child: comments.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => DiaryErrorView(onRetry: () => ref.invalidate(commentsControllerProvider(diaryIdx))),
              data: (list) {
                if (list.isEmpty) {
                  return const DiaryEmptyView(message: '첫 댓글을 남겨보세요.');
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      CommentCard(comment: list[index], diaryIdx: diaryIdx, author: author),
                );
              },
            ),
          ),
          _CommentInput(diaryIdx: diaryIdx),
        ],
      ),
    );
  }
}

/// 하단 댓글 입력. 전송 중에는 버튼을 비활성화해 중복 전송을 막는다(RN throttle 대응). 입력값은 순수 로컬 UI 상태.
class _CommentInput extends ConsumerStatefulWidget {
  const _CommentInput({required this.diaryIdx});

  final int diaryIdx;

  @override
  ConsumerState<_CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<_CommentInput> {
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) {
      return;
    }
    setState(() => _sending = true);
    try {
      await ref.read(commentsControllerProvider(widget.diaryIdx).notifier).create(text);
      _controller.clear();
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.displayMessage)));
      }
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.outline, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  hintText: '댓글을 입력해 주세요.',
                  filled: true,
                  fillColor: context.colors.inputBackground,
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
            ),
            IconButton(
              onPressed: _sending ? null : _submit,
              icon: Icon(Icons.send, color: context.colors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
