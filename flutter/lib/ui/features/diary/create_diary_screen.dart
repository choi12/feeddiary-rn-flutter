// 일기 작성/수정 화면 — 스티커 가로 스크롤 + 본문 + 사진 + 날짜 선택 후 등록/수정. RN CreateDiary 대응.
import 'dart:typed_data';

import 'package:feeddiary/data/models/diary.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_button.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
import 'package:feeddiary/ui/features/diary/create_diary_controller.dart';
import 'package:feeddiary/ui/features/diary/sticker_catalog.dart';
import 'package:feeddiary/ui/features/diary/widgets/diary_date_picker.dart';
import 'package:feeddiary/utils/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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

  // 사진 첨부 로컬 상태 — 갤러리 선택분(bytes)·삭제 여부. 데모 백엔드는 이미지 호스팅이 없어 제출에 포함하지 않는다(RN 데모와 동일).
  Uint8List? _imageBytes;
  bool _imageDeleted = false;

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
        showFeedToast(context, e.displayMessage, offset: FeedToastOffset.button);
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _pickDate(DateTime current) async {
    final picked = await showDiaryDatePicker(context: context, initial: current);
    if (picked != null) {
      ref.read(_provider.notifier).setDate(picked);
    }
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }
    final bytes = await file.readAsBytes();
    if (mounted) {
      setState(() {
        _imageBytes = bytes;
        _imageDeleted = false;
      });
    }
  }

  void _clearImage() => setState(() {
    _imageBytes = null;
    _imageDeleted = true;
  });

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StickerPicker(
                      selected: form.sticker,
                      onSelect: (name) => ref.read(_provider.notifier).setSticker(name),
                    ),
                    const SizedBox(height: 12),
                    _DiaryTextArea(
                      controller: _textController,
                      length: form.text.length,
                      onChanged: (value) => ref.read(_provider.notifier).setText(value),
                    ),
                    _DiaryImageBox(
                      imageBytes: _imageBytes,
                      networkImage: _imageDeleted ? null : widget.initial?.image,
                      onPick: _pickImage,
                      onClear: _clearImage,
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

/// 헤더 우측 날짜 선택 버튼 — 캘린더 아이콘 + 선택 날짜(MAIN). RN `CalendarButton` 대응.
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
          const Icon(FeedIcons.calendar, size: 14, color: FeedPalette.main),
          const SizedBox(width: 4),
          Text(
            formatDiaryDate(date),
            style: const TextStyle(
              fontFamily: FeedFonts.dovemayo,
              fontSize: 13,
              color: FeedPalette.main,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// 스티커 선택 — 가로 스크롤 1줄(셀 60·이미지 47·선택 scale 0.9·체크 우하단). RN StickerBox/Sticker.
class _StickerPicker extends StatefulWidget {
  const _StickerPicker({required this.selected, required this.onSelect});

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  State<_StickerPicker> createState() => _StickerPickerState();
}

class _StickerPickerState extends State<_StickerPicker> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void didUpdateWidget(covariant _StickerPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      _scrollToSelected();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 선택 스티커를 가시영역 중앙으로. RN scrollPosition = (idx+3-5)*60 + idx*7.
  void _scrollToSelected() {
    if (!_controller.hasClients) {
      return;
    }
    final index = StickerCatalog.names.indexOf(widget.selected);
    if (index < 0) {
      return;
    }
    final target = ((index - 2) * 60 + index * 7).toDouble().clamp(0.0, _controller.position.maxScrollExtent);
    _controller.animateTo(target, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // RN sectionTitleText: 14 · LIGHT_BLACK · margin 24 · marginBottom 10.
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 10),
          child: Text(
            '오늘 하루 어땠나요? :D',
            style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 14, color: FeedPalette.lightBlack),
          ),
        ),
        SizedBox(
          height: 60,
          child: ListView.separated(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding),
            itemCount: StickerCatalog.names.length,
            separatorBuilder: (_, _) => const SizedBox(width: 7),
            itemBuilder: (context, index) {
              final name = StickerCatalog.names[index];
              final selected = name == widget.selected;
              return GestureDetector(
                onTap: () => widget.onSelect(name),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Transform.scale(
                    scale: selected ? 0.9 : 1.0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(StickerCatalog.assetFor(name), width: 47, height: 47, fit: BoxFit.contain),
                        // RN checkIcon: Octicons check-circle-fill 20 MAIN · 우하단 모서리 안쪽.
                        if (selected)
                          const Positioned(
                            right: 0,
                            bottom: 0,
                            child: Icon(FeedIcons.stickerCheck, size: 20, color: FeedPalette.main),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 본문 입력 — 고정 높이 300·Dovemayo 14/22·글자수 카운트. RN TextArea.
class _DiaryTextArea extends StatelessWidget {
  const _DiaryTextArea({required this.controller, required this.length, required this.onChanged});

  final TextEditingController controller;
  final int length;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.padding),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: FeedPalette.white,
        borderRadius: BorderRadius.circular(AppDimens.borderRadius),
        border: Border.all(color: FeedPalette.input),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              cursorColor: FeedPalette.main,
              style: const TextStyle(
                fontFamily: FeedFonts.dovemayo,
                fontSize: 14,
                height: 22 / 14,
                color: FeedPalette.lightBlack,
              ),
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: '나의 하루를 기록하고, \n다른 사람들과 공유해 보세요.',
                hintStyle: TextStyle(
                  fontFamily: FeedFonts.dovemayo,
                  fontSize: 14,
                  height: 22 / 14,
                  color: FeedPalette.lightGray,
                ),
              ),
            ),
          ),
          // RN countText: '{n} 글자 작성했어요.' · 12 · LIGHT_GRAY · alignSelf flex-end · marginBottom 5.
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              '$length 글자 작성했어요.',
              style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 12, color: FeedPalette.lightGray),
            ),
          ),
        ],
      ),
    );
  }
}

/// 사진 첨부 — 180 박스(빈: add-photo · 채움: 미리보기 + 삭제 버튼). RN DiaryImageBox.
class _DiaryImageBox extends StatelessWidget {
  const _DiaryImageBox({
    required this.imageBytes,
    required this.networkImage,
    required this.onPick,
    required this.onClear,
  });

  final Uint8List? imageBytes;
  final String? networkImage;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageBytes != null || (networkImage != null && networkImage!.isNotEmpty);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding, vertical: 15),
      child: SizedBox(
        height: 180,
        child: Stack(
          children: [
            GestureDetector(
              onTap: onPick,
              child: Container(
                width: double.infinity,
                height: 180,
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.borderRadius),
                  border: Border.all(color: FeedPalette.input),
                ),
                child: imageBytes != null
                    ? Image.memory(imageBytes!, width: double.infinity, height: 180, fit: BoxFit.cover)
                    : (hasImage
                          ? Image.network(
                              networkImage!,
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const SizedBox.shrink(),
                            )
                          : const Icon(FeedIcons.addPhoto, size: 25, color: FeedPalette.lightGray)),
              ),
            ),
            if (hasImage)
              Positioned(
                right: 5,
                top: 5,
                child: GestureDetector(
                  onTap: onClear,
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: FeedPalette.scrim, shape: BoxShape.circle),
                    child: const Icon(FeedIcons.trash, size: 19, color: FeedPalette.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
