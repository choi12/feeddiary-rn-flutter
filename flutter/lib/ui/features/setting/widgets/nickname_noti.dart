// 닉네임 검증 피드백 — success/duplicate/regex 이미지·색·문구. RN NicknameSection/NotiBox preset.
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/features/auth/create_profile_controller.dart' show NicknameStatus;
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:flutter/material.dart';

/// 닉네임 검증 상태별 안내. RN `NICKNAME_NOTI_PRESET`(success=초록·duplicate/regex=주황) — 아이콘은 PNG 이미지.
class NicknameNoti extends StatelessWidget {
  const NicknameNoti({required this.status, super.key});

  /// 현재 검증 상태. `null`이면 빈 공간만 차지(레이아웃 흔들림 방지).
  final NicknameStatus? status;

  @override
  Widget build(BuildContext context) {
    final status = this.status;
    if (status == null) {
      return const SizedBox(height: 22);
    }
    final (String image, Color color, String text) = switch (status) {
      NicknameStatus.success => (AppAssets.profileSuccess, FeedPalette.main, SettingStrings.nicknameSuccess),
      NicknameStatus.duplicate => (AppAssets.profileError, FeedPalette.orange, SettingStrings.nicknameDuplicate),
      NicknameStatus.regex => (AppAssets.profileError, FeedPalette.orange, SettingStrings.nicknameRegex),
    };
    return SizedBox(
      height: 22,
      child: Row(
        children: [
          Image.asset(image, width: 13, height: 13, fit: BoxFit.contain),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 12, color: color),
            ),
          ),
        ],
      ),
    );
  }
}
