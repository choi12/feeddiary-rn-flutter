// 설정 메인 화면 — 프로필 박스 + 메뉴(잠금/문의/라이선스/버전) + 로그아웃. RN screens/home/setting/Setting + UserProfileBox + MenuButtonBox.
import 'dart:typed_data';

import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/config/app_config.dart';
import 'package:feeddiary/config/app_info.dart';
import 'package:feeddiary/data/models/user.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/features/setting/character_catalog.dart';
import 'package:feeddiary/ui/features/setting/local_avatar.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:feeddiary/ui/features/setting/widgets/setting_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// 설정 탭 메인. 프로필 요약(탭→프로필 수정)·설정 메뉴 4종·로그아웃을 제공한다. RN `Setting` 1:1.
class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(SettingStrings.signOutConfirm),
        actions: [
          TextButton(onPressed: () => context.pop(false), child: const Text(SettingStrings.cancel)),
          TextButton(onPressed: () => context.pop(true), child: const Text(SettingStrings.signOut)),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(authControllerProvider.notifier).signOut();
    } on AppException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.displayMessage)));
      }
    }
  }

  Future<void> _sendSupportEmail(BuildContext context, User? user) async {
    final body =
        '\n\n------\n'
        '앱 버전: ${AppInfo.version}\n'
        '계정: ${user?.account ?? ''}\n'
        '닉네임: ${user?.nickname ?? ''}';
    final uri = Uri(
      scheme: 'mailto',
      path: AppConfig.emailAddress,
      queryParameters: {'subject': SettingStrings.supportSubject, 'body': body},
    );
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SettingStrings.supportUnavailable)));
    }
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: '새싹일기',
      applicationVersion: AppInfo.version,
      applicationIcon: Padding(padding: const EdgeInsets.all(8), child: Image.asset(AppAssets.logo, height: 40)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    return Scaffold(
      appBar: AppBar(title: const Text(SettingStrings.title)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding),
        children: [
          const SizedBox(height: 8),
          _ProfileBox(user: user, onTap: () => context.push(Routes.settingProfile)),
          const Divider(height: 32),
          SettingMenuItem(
            icon: Icons.lock_outline,
            label: SettingStrings.menuLock,
            onTap: () => context.push(Routes.settingLockdown),
          ),
          SettingMenuItem(
            icon: Icons.mail_outline,
            label: SettingStrings.menuSupport,
            onTap: () => _sendSupportEmail(context, user),
          ),
          SettingMenuItem(
            icon: Icons.description_outlined,
            label: SettingStrings.menuLicense,
            onTap: () => _showLicenses(context),
          ),
          SettingMenuItem(
            icon: Icons.info_outline,
            label: SettingStrings.menuAppVersion,
            onTap: () => context.push(Routes.settingAppVersion),
          ),
          const Divider(height: 32),
          Center(
            child: TextButton(
              onPressed: () => _signOut(context, ref),
              child: const Text(
                SettingStrings.signOut,
                style: TextStyle(color: FeedPalette.orange, decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 프로필 박스 — 아바타 + 닉네임/"내 정보 수정" + 계정(소셜 로고+이메일). 탭하면 프로필 수정으로. RN UserProfileBox.
class _ProfileBox extends ConsumerWidget {
  const _ProfileBox({required this.user, required this.onTap});

  final User? user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(localAvatarProvider);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            _Avatar(user: user, localBytes: avatar),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          user?.nickname ?? '',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        SettingStrings.editProfile,
                        style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Image.asset(
                        user?.type.name == 'apple' ? AppAssets.appleIcon : AppAssets.googleIcon,
                        width: 14,
                        height: 14,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          user?.account ?? '',
                          style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.colors.outline),
          ],
        ),
      ),
    );
  }
}

/// 프로필 아바타 — 세션 사진 > 서버 image(URL) > 캐릭터 > 물음표. RN ProfileImageBox 우선순위.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.user, required this.localBytes});

  final User? user;
  final Uint8List? localBytes;

  @override
  Widget build(BuildContext context) {
    const double size = 60;
    final bytes = localBytes;
    if (bytes != null) {
      return ClipOval(
        child: Image.memory(bytes, width: size, height: size, fit: BoxFit.cover),
      );
    }
    final image = user?.image ?? '';
    if (image.isNotEmpty) {
      return ClipOval(
        child: Image.network(image, width: size, height: size, fit: BoxFit.cover),
      );
    }
    final character = user?.character ?? '';
    if (character.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: context.colors.background, shape: BoxShape.circle),
        padding: const EdgeInsets.all(8),
        child: Image.asset(CharacterCatalog.assetFor(character)),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: context.colors.background, shape: BoxShape.circle),
      child: Icon(Icons.question_mark, color: context.colors.textSecondary),
    );
  }
}
