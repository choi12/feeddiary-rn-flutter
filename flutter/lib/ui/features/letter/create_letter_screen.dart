// 편지 작성 화면 — 본문을 입력해 나에게 편지를 보낸다(하루 한 통). RN screens/home/letter/CreateLetter 대응(별도 화면 push).
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/features/letter/letter_list_controller.dart';
import 'package:feeddiary/ui/features/letter/letter_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 편지 작성. 입력값은 순수 로컬 UI 상태(TextEditingController)이고, 전송 중에는 버튼을 비활성화해 중복 전송을 막는다.
/// 성공하면 편지함으로 돌아가(pop) 완료 SnackBar 를 띄운다(셸에 상존하는 편지함이 새 편지를 반영). RN useCreateLetter.
class CreateLetterScreen extends ConsumerStatefulWidget {
  const CreateLetterScreen({super.key});

  @override
  ConsumerState<CreateLetterScreen> createState() => _CreateLetterScreenState();
}

class _CreateLetterScreenState extends ConsumerState<CreateLetterScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) {
      return;
    }
    setState(() => _sending = true);
    // pop 이후엔 이 화면 context 가 비활성이라, 편지함 위에 SnackBar 를 띄우려 messenger 를 미리 잡아둔다.
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(letterListProvider.notifier).create(text);
      if (!mounted) {
        return;
      }
      context.pop();
      messenger.showSnackBar(const SnackBar(content: Text(LetterStrings.sentToast)));
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.displayMessage)));
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSend = _controller.text.trim().isNotEmpty;
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: const Text(LetterStrings.writeTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                autofocus: true,
                minLines: 3,
                maxLines: 6,
                maxLength: LetterStrings.maxLength,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: LetterStrings.placeholder,
                  filled: true,
                  fillColor: context.colors.inputBackground,
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  counterText: LetterStrings.counter(_controller.text.characters.length),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 14, color: context.colors.primary),
                  const SizedBox(width: 4),
                  Text(LetterStrings.info, style: TextStyle(color: context.colors.primary, fontSize: 13)),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: AppDimens.buttonHeight,
                child: FilledButton(
                  onPressed: (canSend && !_sending) ? _submit : null,
                  child: _sending
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(LetterStrings.sendButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
