// 일기 작성/수정 화면 — 스티커 그리드 + 본문 + 날짜 선택 후 등록/수정. RN CreateDiary 대응(사진 첨부는 후속).
import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.displayMessage)));
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
      appBar: AppBar(
        title: Text(isEdit ? '일기 수정' : '일기 쓰기'),
        actions: [
          TextButton.icon(
            onPressed: () => _pickDate(form.date),
            icon: const Icon(Icons.calendar_today_outlined, size: 16),
            label: Text(formatYmd(form.date)),
          ),
        ],
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
                    TextField(
                      controller: _textController,
                      onChanged: (value) => ref.read(_provider.notifier).setText(value),
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: '오늘 하루를 기록해보세요.',
                        filled: true,
                        fillColor: context.colors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimens.borderRadius),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.padding),
              child: SizedBox(
                width: double.infinity,
                height: AppDimens.buttonHeight,
                child: FilledButton(
                  onPressed: (form.canSubmit && !_submitting) ? _submit : null,
                  child: _submitting
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(isEdit ? '수정하기' : '일기 등록하기'),
                ),
              ),
            ),
          ],
        ),
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
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: name == selected ? context.colors.primary.withValues(alpha: 0.18) : context.colors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: name == selected ? context.colors.primary : context.colors.outline),
              ),
              child: Text(StickerCatalog.emojiFor(name), style: const TextStyle(fontSize: 24)),
            ),
          ),
      ],
    );
  }
}
