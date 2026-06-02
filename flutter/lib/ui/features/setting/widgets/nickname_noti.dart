// 닉네임 검증 피드백 — success/duplicate/regex 색·아이콘·문구. RN NicknameSection/NotiBox preset.
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/features/auth/create_profile_controller.dart' show NicknameStatus;
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:flutter/material.dart';

/// 닉네임 검증 상태별 안내. RN `NICKNAME_NOTI_PRESET`(success=초록·duplicate/regex=주황) 대응.
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
    final (IconData icon, Color color, String text) = switch (status) {
      NicknameStatus.success => (Icons.check_circle, context.colors.primary, SettingStrings.nicknameSuccess),
      NicknameStatus.duplicate => (Icons.error, FeedPalette.orange, SettingStrings.nicknameDuplicate),
      NicknameStatus.regex => (Icons.error, FeedPalette.orange, SettingStrings.nicknameRegex),
    };
    return SizedBox(
      height: 22,
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 12, color: color)),
          ),
        ],
      ),
    );
  }
}
