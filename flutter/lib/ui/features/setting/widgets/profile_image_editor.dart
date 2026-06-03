// 프로필 이미지 편집기(공유) — 사진(갤러리 직행)/캐릭터 토글·배경 ColorPicker 모달·캐릭터 토글 그리드. RN components/profile/ProfileImageSection + ProfileAvatarEditor 1:1, 가입/수정 공용.
import 'dart:typed_data';

import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/features/setting/character_catalog.dart';
import 'package:feeddiary/ui/features/setting/color_picker_palette.dart';
import 'package:feeddiary/ui/features/setting/profile_image_type.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// 프로필 이미지 입력 영역. 사진(갤러리 업로드)과 캐릭터(36 프리셋 + 배경색)를 타입 모달로 전환한다.
/// 상태는 부모(컨트롤러)가 들고, 캐릭터 펼침 토글만 로컬 상태다. RN `ProfileImageSection`(가입/수정 공유) 대응.
class ProfileImageEditor extends StatefulWidget {
  const ProfileImageEditor({
    required this.imageType,
    required this.character,
    required this.background,
    required this.imageBytes,
    required this.onPhotoPicked,
    required this.onCharacterSelected,
    required this.onCharacterMode,
    required this.onBackgroundSelected,
    super.key,
  });

  final ProfileImageType? imageType;
  final String character;
  final String background;
  final Uint8List? imageBytes;
  final ValueChanged<Uint8List> onPhotoPicked;
  final ValueChanged<String> onCharacterSelected;

  /// "캐릭터 만들기" 선택 — 캐릭터를 고르지 않고 캐릭터 모드로만 전환한다(RN onClearProfileImage). 기존 캐릭터는 유지.
  final VoidCallback onCharacterMode;
  final ValueChanged<String> onBackgroundSelected;

  static Color hexColor(String hex) {
    final value = int.parse('FF${hex.replaceFirst('#', '')}', radix: 16);
    return Color(value);
  }

  @override
  State<ProfileImageEditor> createState() => _ProfileImageEditorState();
}

class _ProfileImageEditorState extends State<ProfileImageEditor> {
  /// 캐릭터 그리드 펼침 여부. RN `useVisibility().toggle`(인라인 펼침). 캐릭터 선택 시 자동으로 접힌다.
  bool _characterExpanded = false;

  bool get _usePhoto => widget.imageType == ProfileImageType.photo;

  /// RN ProfileImageSection: "사진 선택하기"는 소스 시트 없이 갤러리로 직행한다.
  Future<void> _pickPhoto() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    widget.onPhotoPicked(bytes);
  }

  /// 아바타 탭 → 타입 선택 모달(사진/캐릭터). RN ProfileImageSection 의 Pressable→ProfileImageTypeModal.
  void _openTypeModal() {
    showDialog<void>(
      context: context,
      barrierColor: FeedPalette.scrim,
      builder: (dialogContext) => _ProfileTypeModal(
        onPhoto: () {
          Navigator.of(dialogContext).pop();
          _pickPhoto();
        },
        onCharacter: () {
          Navigator.of(dialogContext).pop();
          // RN: 캐릭터 모드로만 전환(자동 선택 없음) → 캐릭터 행에서 직접 고른다.
          widget.onCharacterMode();
        },
      ),
    );
  }

  /// 배경 행 탭 → 110색 ColorPicker 모달. 색 선택 시 모달을 닫고 콜백을 전달한다. RN ProfileAvatarEditor 의 BaseModal.
  void _openColorPicker() {
    showDialog<void>(
      context: context,
      barrierColor: FeedPalette.scrim,
      builder: (dialogContext) => _ColorPickerModal(
        onSelected: (hex) {
          Navigator.of(dialogContext).pop();
          widget.onBackgroundSelected(hex);
        },
      ),
    );
  }

  void _onCharacterSelected(String name) {
    widget.onCharacterSelected(name);
    setState(() => _characterExpanded = false);
  }

  void _toggleCharacterExpanded() {
    final willExpand = !_characterExpanded;
    setState(() => _characterExpanded = willExpand);
    if (!willExpand) return;
    // RN CharacterSelector: 펼친 뒤 하단으로 스크롤해 그리드가 보이게 한다(delay→scrollToEnd).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final position = Scrollable.maybeOf(context)?.position;
      if (position == null) return;
      position.animateTo(position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCharacter = widget.imageType == ProfileImageType.character;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 프로필 이미지 섹션(좌측 정렬 타이틀 + 중앙 아바타). RN ProfileImageSection container(gap10·mb25).
        Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  SettingStrings.profileImageLabel,
                  style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 15, color: FeedPalette.black),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _openTypeModal,
                child: _Avatar(
                  usePhoto: _usePhoto,
                  character: widget.character,
                  background: widget.background,
                  imageBytes: widget.imageBytes,
                ),
              ),
            ],
          ),
        ),
        // 캐릭터 모드: 배경 행(→모달) + 캐릭터 행(→인라인 토글) + (펼침 시) 캐릭터 그리드. RN ProfileAvatarEditor.
        if (isCharacter) ...[
          _BackgroundSelector(background: widget.background, onTap: _openColorPicker),
          _CharacterSelector(
            character: widget.character,
            expanded: _characterExpanded,
            onToggle: _toggleCharacterExpanded,
          ),
          if (_characterExpanded) _CharacterBox(selected: widget.character, onSelect: _onCharacterSelected),
        ],
      ],
    );
  }
}

/// 프로필 이미지 타입 선택 모달 — [사진 선택하기 | 캐릭터 만들기] 2분할. RN ProfileImageTypeModal(300·60h).
class _ProfileTypeModal extends StatelessWidget {
  const _ProfileTypeModal({required this.onPhoto, required this.onCharacter});

  final VoidCallback onPhoto;
  final VoidCallback onCharacter;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: FeedPalette.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.borderRadius)),
      child: SizedBox(
        width: AppDimens.dialogWidth,
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _TypeCell(
                icon: FeedIcons.addPhoto,
                iconSize: 18,
                color: FeedPalette.lightBlack,
                label: SettingStrings.pickPhoto,
                onTap: onPhoto,
              ),
            ),
            const ColoredBox(color: FeedPalette.lightGray, child: SizedBox(width: 1)),
            Expanded(
              child: _TypeCell(
                icon: FeedIcons.profileUser,
                iconSize: 15,
                color: FeedPalette.main,
                label: SettingStrings.pickCharacter,
                onTap: onCharacter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeCell extends StatelessWidget {
  const _TypeCell({
    required this.icon,
    required this.iconSize,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final double iconSize;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 14, color: color),
          ),
        ],
      ),
    );
  }
}

/// 아바타 미리보기 — 사진 바이트 > 캐릭터+배경 > 물음표. RN ProfileImageBox 우선순위.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.usePhoto, required this.character, required this.background, required this.imageBytes});

  final bool usePhoto;
  final String character;
  final String background;
  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    const double size = 160;
    final bytes = imageBytes;
    final bg = background.isNotEmpty ? ProfileImageEditor.hexColor(background) : FeedPalette.whiteGray;
    final Widget content;
    if (usePhoto && bytes != null) {
      content = Image.memory(bytes, width: size, height: size, fit: BoxFit.cover);
    } else if (character.isNotEmpty) {
      content = Padding(padding: const EdgeInsets.all(24), child: Image.asset(CharacterCatalog.assetFor(character)));
    } else {
      content = const Icon(FeedIcons.question, size: 40, color: FeedPalette.white);
    }
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: FeedPalette.whiteGray),
      ),
      child: Center(child: content),
    );
  }
}

/// 배경 선택 행 — 좌측 라벨 + 우측 색 버튼(탭 시 ColorPicker 모달). RN BackgroundSelector(rowBox·height57).
class _BackgroundSelector extends StatelessWidget {
  const _BackgroundSelector({required this.background, required this.onTap});

  final String background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasColor = background.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const _SelectorTitle(icon: FeedIcons.backgroundFill, iconSize: 15, label: SettingStrings.backgroundLabel),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: AppDimens.inputHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: hasColor ? ProfileImageEditor.hexColor(background) : FeedPalette.white,
                  borderRadius: BorderRadius.circular(AppDimens.borderRadius),
                  border: Border.all(color: FeedPalette.input),
                ),
                child: hasColor ? null : const Icon(FeedIcons.colorize, size: 15, color: FeedPalette.lightBlack),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 캐릭터 선택 행 — 좌측 라벨 + 우측 토글 버튼(선택 요약 + 펼침 chevron). RN CharacterSelector(rowBox·height57·paddingH25).
class _CharacterSelector extends StatelessWidget {
  const _CharacterSelector({required this.character, required this.expanded, required this.onToggle});

  final String character;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final hasCharacter = character.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const _SelectorTitle(icon: FeedIcons.profileUser, iconSize: 12, label: SettingStrings.characterLabel),
          Expanded(
            child: GestureDetector(
              onTap: onToggle,
              child: Container(
                height: AppDimens.inputHeight,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.borderRadius),
                  border: Border.all(color: FeedPalette.input),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (hasCharacter)
                      Flexible(
                        child: Row(
                          children: [
                            Image.asset(CharacterCatalog.assetFor(character), width: 35, height: 35),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                'Lovely $character',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: FeedFonts.dovemayo,
                                  fontSize: 13,
                                  color: FeedPalette.lightBlack,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      const Text(
                        SettingStrings.characterPlaceholder,
                        style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.lightBlack),
                      ),
                    Icon(expanded ? FeedIcons.expandUp : FeedIcons.expandDown, size: 18, color: FeedPalette.darkGray),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 선택 행 좌측 라벨(아이콘 + 텍스트, 폭 65 고정). RN BackgroundSelector/CharacterSelector titleBox(width65·ml5).
class _SelectorTitle extends StatelessWidget {
  const _SelectorTitle({required this.icon, required this.iconSize, required this.label});

  final IconData icon;
  final double iconSize;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      child: Row(
        children: [
          Icon(icon, size: iconSize, color: FeedPalette.lightBlack),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.lightBlack),
          ),
        ],
      ),
    );
  }
}

/// 캐릭터 그리드(인라인 펼침·6×6 사각 셀). 선택 셀만 테두리 강조. RN CharacterBox(셀 사각 r10·padding5·border2).
class _CharacterBox extends StatelessWidget {
  const _CharacterBox({required this.selected, required this.onSelect});

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: FeedPalette.white,
        borderRadius: BorderRadius.circular(AppDimens.borderRadius),
        border: Border.all(color: FeedPalette.whiteGray),
      ),
      child: GridView.count(
        crossAxisCount: 6,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        children: [
          for (final name in CharacterCatalog.names)
            GestureDetector(
              onTap: () => onSelect(name),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: name == selected ? FeedPalette.whiteGray : Colors.transparent),
                ),
                child: Image.asset(CharacterCatalog.assetFor(name)),
              ),
            ),
        ],
      ),
    );
  }
}

/// 배경색 선택 모달 — 11×10 머티리얼 110색 그리드(가운데·90%w·radius5). RN ColorPicker(BaseModal).
class _ColorPickerModal extends StatelessWidget {
  const _ColorPickerModal({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    // 화면 가운데 90% 폭 박스. 바깥 영역은 showDialog 의 barrier(barrierDismissible 기본 true)라 탭하면 닫힌다.
    final width = MediaQuery.sizeOf(context).width * 0.9;
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: width,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: FeedPalette.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: FeedPalette.whiteGray),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 7),
                child: Row(
                  children: [
                    Icon(FeedIcons.colorize, size: 15, color: FeedPalette.lightBlack),
                    SizedBox(width: 3),
                    Text(
                      SettingStrings.colorPickerTitle,
                      style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.lightBlack),
                    ),
                  ],
                ),
              ),
              for (final row in ColorPickerPalette.rows)
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      for (var i = 0; i < row.length; i++) ...[
                        if (i > 0) const SizedBox(width: 5),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => onSelected(row[i]),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ColoredBox(color: ProfileImageEditor.hexColor(row[i])),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
