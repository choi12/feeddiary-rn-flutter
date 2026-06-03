// 닉네임 검증 피드백 — success/duplicate/regex 이미지·색·문구. RN NicknameSection/NotiBox preset.
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/features/auth/create_profile_controller.dart' show NicknameStatus;
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:flutter/material.dart';

/// 닉네임 검증 상태별 안내. RN `NICKNAME_NOTI_PRESET`(success=초록·duplicate/regex=주황) — 아이콘은 PNG 이미지.
class NicknameNoti extends StatelessWidget {
  const NicknameNoti({required this.status, this.indent = 0, super.key});

  /// 현재 검증 상태. `null`이면 렌더하지 않는다(RN NotiBox: notiType 없으면 return null → 빈 공간 없음).
  final NicknameStatus? status;

  /// 입력칸 정렬용 좌측 들여쓰기(RN NotiBox marginLeft). 닉네임이 라벨 행(폭 55)일 때 55. 풀폭 입력이면 0.
  final double indent;

  @override
  Widget build(BuildContext context) {
    final status = this.status;
    if (status == null) {
      return const SizedBox.shrink();
    }
    final (String image, Color color, String text) = switch (status) {
      NicknameStatus.success => (AppAssets.profileSuccess, FeedPalette.main, SettingStrings.nicknameSuccess),
      NicknameStatus.duplicate => (AppAssets.profileError, FeedPalette.orange, SettingStrings.nicknameDuplicate),
      NicknameStatus.regex => (AppAssets.profileError, FeedPalette.orange, SettingStrings.nicknameRegex),
    };
    // RN NotiBox: marginTop 10 (+ 화면별 좌측 들여쓰기).
    return Padding(
      padding: EdgeInsets.only(top: 10, left: indent),
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
