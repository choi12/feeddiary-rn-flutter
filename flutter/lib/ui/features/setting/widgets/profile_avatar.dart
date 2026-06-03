// 작성자 프로필 아바타 — 사진(URL) > 캐릭터(70%) > 물음표. RN ProfileImageBox(공유 일기·댓글 카드 공용).
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/features/setting/character_catalog.dart';
import 'package:flutter/material.dart';

/// 원형 프로필 아바타. 우선순위 = 업로드 사진(userImage URL) > 캐릭터(70%) > 물음표. RN `ProfileImageBox`.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    required this.size,
    required this.userImage,
    required this.character,
    required this.background,
    super.key,
  });

  final double size;
  final String userImage;
  final String character;
  final String background;

  static Color _hexColor(String hex) => Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));

  @override
  Widget build(BuildContext context) {
    final bg = background.isNotEmpty ? _hexColor(background) : FeedPalette.whiteGray;
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: FeedPalette.whiteGray),
      ),
      child: userImage.isNotEmpty
          ? Image.network(userImage, fit: BoxFit.cover, errorBuilder: (_, _, _) => _fallback())
          : _fallback(),
    );
  }

  Widget _fallback() {
    if (character.isNotEmpty) {
      return Padding(padding: EdgeInsets.all(size * 0.15), child: Image.asset(CharacterCatalog.assetFor(character)));
    }
    return Icon(FeedIcons.question, size: size * 0.5, color: FeedPalette.white);
  }
}
