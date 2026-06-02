// 댓글 화면 — 특정 일기의 댓글 목록 + 작성 입력. RN screens/home/community/Comments 대응(별도 화면 push).
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_text_field.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
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
    final title = comments.maybeWhen(data: (list) => '댓글 (${list.length})', orElse: () => '댓글');
    return Scaffold(
      backgroundColor: FeedPalette.background,
      appBar: FeedHeader(title: title, hasCloseButton: true, backgroundColor: FeedPalette.background),
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
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTextChanged)
      ..dispose();
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
      if (mounted) showFeedToast(context, e.displayMessage);
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: FeedPalette.white,
        border: Border(top: BorderSide(color: FeedPalette.whiteGray)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: FeedTextField(
                controller: _controller,
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _submit(),
                hintText: '댓글을 입력해 주세요.',
              ),
            ),
            const SizedBox(width: 8),
            _SendButton(enabled: _hasText && !_sending, sending: _sending, onTap: _submit),
          ],
        ),
      ),
    );
  }
}

/// 댓글 등록 버튼 — MAIN 정사각 버튼·종이비행기. 빈 입력/전송 중에는 INPUT 회색. RN `CreateCommentButton` 대응.
class _SendButton extends StatelessWidget {
  const _SendButton({required this.enabled, required this.sending, required this.onTap});

  final bool enabled;
  final bool sending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Material(
        color: enabled ? FeedPalette.main : FeedPalette.input,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: sending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: FeedPalette.white),
                  )
                : const Icon(FeedIcons.send, size: 20, color: FeedPalette.white),
          ),
        ),
      ),
    );
  }
}
