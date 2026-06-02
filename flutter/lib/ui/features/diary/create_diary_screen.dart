// 일기 작성/수정 화면 — 스티커 그리드 + 본문 + 날짜 선택 후 등록/수정. RN CreateDiary 대응(사진 첨부는 후속).
import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_button.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_text_field.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
import 'package:feeddiary/ui/features/diary/create_diary_controller.dart';
import 'package:feeddiary/ui/features/diary/sticker_catalog.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// [initial]이 있으면 수정, 없으면 새 작성. RN CreateDiary(params.diary optional).
class CreateDiaryScreen extends ConsumerStatefulWidget {
  const CreateDiaryScreen({this.initial, super.key});

  final MyDiary? initial;

  @override
  ConsumerState<CreateDiaryScreen> createState() => _CreateDiaryScreenState();
}

class _CreateDiaryScreenState extends ConsumerState<CreateDiaryScreen> {
  late final TextEditingController _textController = TextEditingController(text: widget.initial?.text ?? '');
  late final _provider = createDiaryControllerProvider(widget.initial);
  bool _submitting = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final idx = await ref.read(_provider.notifier).submit();
      if (mounted) {
        context.pushReplacement(Routes.diaryDetailPath(idx));
      }
    } on AppException catch (e) {
      if (mounted) {
        showFeedToast(context, e.displayMessage);
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _pickDate(DateTime current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      ref.read(_provider.notifier).setDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    final form = ref.watch(_provider);

    return Scaffold(
      backgroundColor: FeedPalette.white,
      appBar: FeedHeader(
        title: isEdit ? '일기 수정' : '일기 쓰기',
        hasBackButton: true,
        rightItem: _CalendarButton(date: form.date, onTap: () => _pickDate(form.date)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('오늘의 스티커', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 12),
                    _StickerPicker(
                      selected: form.sticker,
                      onSelect: (name) => ref.read(_provider.notifier).setSticker(name),
                    ),
                    const SizedBox(height: 24),
                    FeedTextField(
                      controller: _textController,
                      onChanged: (value) => ref.read(_provider.notifier).setText(value),
                      maxLines: 6,
                      minLines: 6,
                      font: FeedFieldFont.ownglyph,
                      fontSize: 17,
                      hintText: '오늘 하루를 기록해보세요.',
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.padding),
              child: FeedButton(
                title: isEdit ? '수정하기' : '일기 등록하기',
                onPressed: _submit,
                disabled: !form.canSubmit,
                isLoading: _submitting,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 헤더 우측 날짜 선택 버튼 — 캘린더 아이콘 + 선택 날짜. RN `CalendarButton` 대응.
class _CalendarButton extends StatelessWidget {
  const _CalendarButton({required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(FeedIcons.calendar, size: 14, color: FeedPalette.lightBlack),
          const SizedBox(width: 4),
          Text(
            formatYmd(date),
            style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.lightBlack),
          ),
        ],
      ),
    );
  }
}

class _StickerPicker extends StatelessWidget {
  const _StickerPicker({required this.selected, required this.onSelect});

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final name in StickerCatalog.names)
          GestureDetector(
            onTap: () => onSelect(name),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: FeedPalette.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: name == selected ? FeedPalette.main : FeedPalette.whiteGray,
                      width: name == selected ? 2 : 1,
                    ),
                  ),
                  child: Image.asset(StickerCatalog.assetFor(name), width: 36, height: 36, fit: BoxFit.contain),
                ),
                if (name == selected)
                  const Positioned(
                    top: -6,
                    right: -6,
                    child: Icon(FeedIcons.stickerCheck, size: 20, color: FeedPalette.main),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
