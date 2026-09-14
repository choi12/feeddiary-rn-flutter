// 라이선스 화면 — 라이브러리·에셋의 이름/라이선스/설명 3줄 리스트. RN screens/home/setting/License + LicenseItem 1:1.
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/features/setting/license_data.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:flutter/material.dart';

/// 사용 라이브러리의 라이선스를 나열한다. RN `License`(커스텀 3줄 리스트) 대응 — Material `showLicensePage`가 아니다.
class LicenseScreen extends StatelessWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FeedPalette.white,
      appBar: const FeedHeader(title: SettingStrings.menuLicense, hasBackButton: true),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.padding),
        children: [for (final entry in openSourceLicenses) _LicenseItem(entry: entry)],
      ),
    );
  }
}

/// 라이선스 한 줄 — 이름(13 BLACK)·라이선스(13 MAIN)·설명(11 DARK_GRAY). RN `LicenseBox`(padding10·mb20·gap5).
class _LicenseItem extends StatelessWidget {
  const _LicenseItem({required this.entry});

  final LicenseEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.name,
              style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.black),
            ),
            const SizedBox(height: 5),
            Text(
              entry.license,
              style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 13, color: FeedPalette.main),
            ),
            const SizedBox(height: 5),
            Text(
              entry.description,
              style: const TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 11, color: FeedPalette.darkGray),
            ),
          ],
        ),
      ),
    );
  }
}
