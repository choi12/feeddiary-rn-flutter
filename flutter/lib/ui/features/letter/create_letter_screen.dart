// 편지 작성 화면 — 본문을 입력해 나에게 편지를 보낸다(하루 한 통). RN screens/home/letter/CreateLetter 대응(별도 화면 push).
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_button.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
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
    // RN: 헤더 투명·letterBoard 가 전면 배경. FeedHeader 를 body 의 letterBoard 위 첫 자식으로 둔다.
    return Scaffold(
      backgroundColor: FeedPalette.background,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppAssets.letterBoard), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            const FeedHeader(
              title: LetterStrings.writeTitle,
              font: FeedHeaderFont.ownglyph,
              hasCloseButton: true,
              backgroundColor: Colors.transparent,
            ),
            Expanded(
              child: SafeArea(
                top: false,
                // RN Container hasPadding(24) + LetterInput marginTop -24 → 입력박스는 헤더에 붙는다(상단 0).
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppDimens.padding, 0, AppDimens.padding, AppDimens.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _LetterInputBox(controller: _controller),
                      const SizedBox(height: 15),
                      const _InfoText(),
                      const SizedBox(height: 10),
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
          ],
        ),
      ),
    );
  }
}

/// 편지 입력칸 — 고정 120·옅은 보더(#F3F3F3)·반투명 흰 배경·카운터 박스 내부 하단. RN CreateLetter/LetterInput.
class _LetterInputBox extends StatelessWidget {
  const _LetterInputBox({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: FeedPalette.white90,
        borderRadius: BorderRadius.circular(AppDimens.borderRadius),
        border: Border.all(color: FeedPalette.whiteGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              maxLines: null,
              expands: true,
              maxLength: LetterStrings.maxLength,
              textAlignVertical: TextAlignVertical.top,
              cursorColor: FeedPalette.main,
              style: const TextStyle(
                fontFamily: FeedFonts.ownglyph,
                fontSize: 17,
                height: 22 / 17,
                color: FeedPalette.lightBlack,
              ),
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                counterText: '',
                hintText: LetterStrings.placeholder,
                hintStyle: TextStyle(
                  fontFamily: FeedFonts.ownglyph,
                  fontSize: 17,
                  height: 22 / 17,
                  color: FeedPalette.lightGray,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                LetterStrings.counter(controller.text.characters.length),
                style: const TextStyle(fontFamily: FeedFonts.ownglyph, fontSize: 13, color: FeedPalette.gray),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 작성 안내문 — 하루 한 통 제한. RN InfoTextBox(Feather alert-circle 13 SKYBLUE + SKYBLUE 13).
class _InfoText extends StatelessWidget {
  const _InfoText();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(FeedIcons.alert, size: 13, color: FeedPalette.skyblue),
        SizedBox(width: 3),
        Expanded(
          child: Text(
            LetterStrings.info,
            style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.skyblue),
          ),
        ),
      ],
    );
  }
}
