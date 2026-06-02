// 편지 작성 화면 — 본문을 입력해 나에게 편지를 보낸다(하루 한 통). RN screens/home/letter/CreateLetter 대응(별도 화면 push).
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_button.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_text_field.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
import 'package:feeddiary/ui/features/letter/letter_list_controller.dart';
import 'package:feeddiary/ui/features/letter/letter_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 편지 작성. 입력값은 순수 로컬 UI 상태(TextEditingController)이고, 전송 중에는 버튼을 비활성화해 중복 전송을 막는다.
/// 성공하면 편지함으로 돌아가(pop) 완료 토스트를 띄운다(셸에 상존하는 편지함이 새 편지를 반영). RN useCreateLetter.
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
    try {
      await ref.read(letterListProvider.notifier).create(text);
      if (!mounted) {
        return;
      }
      // 토스트는 루트 Overlay 라 pop 후에도 남는다(먼저 띄우고 편지함으로 돌아간다).
      showFeedToast(context, LetterStrings.sentToast);
      context.pop();
    } on AppException catch (e) {
      if (mounted) {
        showFeedToast(context, e.displayMessage);
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSend = _controller.text.trim().isNotEmpty;
    return Scaffold(
      backgroundColor: FeedPalette.background,
      appBar: const FeedHeader(title: LetterStrings.writeTitle, font: FeedHeaderFont.ownglyph, hasCloseButton: true),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.letterBoard), fit: BoxFit.cover),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FeedTextField(
                  controller: _controller,
                  autofocus: true,
                  minLines: 3,
                  maxLines: 6,
                  maxLength: LetterStrings.maxLength,
                  font: FeedFieldFont.ownglyph,
                  fontSize: 17,
                  hintText: LetterStrings.placeholder,
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    LetterStrings.counter(_controller.text.characters.length),
                    style: const TextStyle(fontFamily: FeedFonts.ownglyph, fontSize: 13, color: FeedPalette.gray),
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(FeedIcons.alert, size: 14, color: FeedPalette.main),
                    SizedBox(width: 4),
                    Text(
                      LetterStrings.info,
                      style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.main),
                    ),
                  ],
                ),
                const Spacer(),
                FeedButton(
                  title: LetterStrings.sendButton,
                  onPressed: _submit,
                  disabled: !canSend,
                  isLoading: _sending,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
