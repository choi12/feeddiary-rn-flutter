// 프로필 이미지 편집기(공유) — 사진/캐릭터 토글·캐릭터 그리드·배경 스와치·image_picker. RN components/profile/ProfileImageSection 1:1, 가입/수정 공용.
import 'dart:typed_data';

import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/widgets/feed_bottom_sheet.dart';
import 'package:feeddiary/ui/features/setting/character_catalog.dart';
import 'package:feeddiary/ui/features/setting/profile_image_type.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// 프로필 이미지 입력 영역. 사진(갤러리/카메라 업로드)과 캐릭터(36 프리셋 + 배경색)를 토글로 전환한다.
/// 상태는 부모(컨트롤러)가 들고, 이 위젯은 표시 + 선택 콜백만 담당한다. RN `ProfileImageSection`(가입/수정 공유) 대응.
class ProfileImageEditor extends StatelessWidget {
  const ProfileImageEditor({
    required this.imageType,
    required this.character,
    required this.background,
    required this.imageBytes,
    required this.onPhotoPicked,
    required this.onCharacterSelected,
    required this.onBackgroundSelected,
    super.key,
  });

  final ProfileImageType? imageType;
  final String character;
  final String background;
  final Uint8List? imageBytes;
  final ValueChanged<Uint8List> onPhotoPicked;
  final ValueChanged<String> onCharacterSelected;
  final ValueChanged<String> onBackgroundSelected;

  /// 배경색 프리셋(스와치). RN `PICKER_COLORS`의 축약본.
  static const List<String> _backgroundSwatches = [
    '#F8BBD0',
    '#F48FB1',
    '#CE93D8',
    '#B39DDB',
    '#9FA8DA',
    '#90CAF9',
    '#81D4FA',
    '#80DEEA',
    '#A5D6A7',
    '#C5E1A5',
    '#FFE082',
    '#FFCC80',
    '#FFAB91',
    '#BCAAA4',
    '#B0BEC5',
    '#E0E0E0',
  ];

  bool get _usePhoto => imageType == ProfileImageType.photo;

  static Color hexColor(String hex) {
    final value = int.parse('FF${hex.replaceFirst('#', '')}', radix: 16);
    return Color(value);
  }

  void _pickPhoto(BuildContext context) {
    showFeedSheet(
      context: context,
      items: [
        FeedSheetItem(title: '갤러리에서 선택', onPressed: () => _pickFrom(ImageSource.gallery)),
        FeedSheetItem(title: '카메라로 촬영', onPressed: () => _pickFrom(ImageSource.camera)),
      ],
    );
  }

  Future<void> _pickFrom(ImageSource source) async {
    final file = await ImagePicker().pickImage(source: source, imageQuality: 70);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    onPhotoPicked(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: _Avatar(usePhoto: _usePhoto, character: character, background: background, imageBytes: imageBytes),
        ),
        const SizedBox(height: 24),
        SegmentedButton<ProfileImageType>(
          segments: const [
            ButtonSegment(value: ProfileImageType.photo, label: Text(SettingStrings.pickPhoto)),
            ButtonSegment(value: ProfileImageType.character, label: Text(SettingStrings.pickCharacter)),
          ],
          selected: {imageType ?? ProfileImageType.character},
          onSelectionChanged: (selection) {
            if (selection.first == ProfileImageType.photo) {
              _pickPhoto(context);
            } else {
              onCharacterSelected(character.isEmpty ? CharacterCatalog.defaultName : character);
            }
          },
        ),
        const SizedBox(height: 16),
        if (_usePhoto)
          OutlinedButton.icon(
            onPressed: () => _pickPhoto(context),
            icon: const Icon(FeedIcons.addPhoto),
            label: const Text(SettingStrings.pickPhoto),
          )
        else ...[
          _CharacterGrid(selected: character, onSelect: onCharacterSelected),
          const SizedBox(height: 20),
          const Text(SettingStrings.backgroundLabel, style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _BackgroundSwatches(swatches: _backgroundSwatches, selected: background, onSelect: onBackgroundSelected),
        ],
      ],
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
    const double size = 96;
    final bytes = imageBytes;
    if (usePhoto && bytes != null) {
      return ClipOval(
        child: Image.memory(bytes, width: size, height: size, fit: BoxFit.cover),
      );
    }
    final bg = background.isNotEmpty ? ProfileImageEditor.hexColor(background) : context.colors.background;
    if (character.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        padding: const EdgeInsets.all(12),
        child: Image.asset(CharacterCatalog.assetFor(character)),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(FeedIcons.question, color: context.colors.textSecondary),
    );
  }
}

/// 캐릭터 그리드(36 프리셋). 선택된 캐릭터는 테두리로 강조. RN CharacterSelector/CharacterBox.
class _CharacterGrid extends StatelessWidget {
  const _CharacterGrid({required this.selected, required this.onSelect});

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        for (final name in CharacterCatalog.names)
          GestureDetector(
            onTap: () => onSelect(name),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: name == selected ? context.colors.primary : context.colors.outline,
                  width: name == selected ? 2 : 1,
                ),
              ),
              padding: const EdgeInsets.all(4),
              child: Image.asset(CharacterCatalog.assetFor(name)),
            ),
          ),
      ],
    );
  }
}

/// 배경색 스와치. 선택된 색은 테두리로 강조. RN BackgroundSelector/ColorPicker.
class _BackgroundSwatches extends StatelessWidget {
  const _BackgroundSwatches({required this.swatches, required this.selected, required this.onSelect});

  final List<String> swatches;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final hex in swatches)
          GestureDetector(
            onTap: () => onSelect(hex),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: ProfileImageEditor.hexColor(hex),
                shape: BoxShape.circle,
                border: Border.all(
                  color: hex == selected ? context.colors.primary : context.colors.outline,
                  width: hex == selected ? 3 : 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
