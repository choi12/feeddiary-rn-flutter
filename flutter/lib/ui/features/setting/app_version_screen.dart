// 앱 버전 정보 화면 — 현재/최신 버전 비교·안내. RN screens/home/setting/AppVersion + useAppVersion.
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/config/app_info.dart';
import 'package:feeddiary/data/repositories/app_version_repository.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 현재 앱 버전([AppInfo.version])과 서버 최신 버전([latestAppVersionProvider])을 비교해 최신 여부를 안내한다.
/// RN `AppVersion`/`useAppVersion`(INDEPENDENT_QUERY) 대응.
class AppVersionScreen extends ConsumerWidget {
  const AppVersionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = ref.watch(latestAppVersionProvider);
    return Scaffold(
      backgroundColor: FeedPalette.white,
      appBar: const FeedHeader(title: SettingStrings.appVersionTitle, hasBackButton: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.logo, height: 56),
              const SizedBox(height: 32),
              latest.when(
                data: (version) => _VersionNoti(latestVersion: version),
                loading: () =>
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: CircularProgressIndicator()),
                error: (_, _) => Text(
                  SettingStrings.currentVersion(AppInfo.version),
                  style: TextStyle(color: context.colors.textSecondary),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                SettingStrings.currentVersion(AppInfo.version),
                style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 최신 여부 안내 박스. RN `AppVersionNotiBox`(isLatest 색/문구 분기).
class _VersionNoti extends StatelessWidget {
  const _VersionNoti({required this.latestVersion});

  final String latestVersion;

  @override
  Widget build(BuildContext context) {
    final isLatest = latestVersion == AppInfo.version;
    final color = isLatest ? context.colors.primary : FeedPalette.orange;
    final text = isLatest ? SettingStrings.latestVersion : SettingStrings.updateRequired(latestVersion);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(FeedIcons.alert, size: 16, color: color),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}
