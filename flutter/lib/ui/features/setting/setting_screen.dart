// 설정 메인 화면 — 프로필 박스 + 메뉴(잠금/문의/라이선스/버전) + 로그아웃. RN screens/home/setting/Setting + UserProfileBox + MenuButtonBox.
import 'dart:typed_data';

import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/config/app_config.dart';
import 'package:feeddiary/config/app_info.dart';
import 'package:feeddiary/data/models/user.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_alert_dialog.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_menu_row.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
import 'package:feeddiary/ui/features/setting/character_catalog.dart';
import 'package:feeddiary/ui/features/setting/local_avatar.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// 설정 탭 메인. 프로필 요약(탭→프로필 수정)·설정 메뉴 4종·로그아웃을 제공한다. RN `Setting` 1:1.
class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showFeedAlert<bool>(
      context: context,
      message: SettingStrings.signOutConfirm,
      actions: [
        FeedAlertAction(text: SettingStrings.cancel, isCancel: true, onPressed: () => Navigator.of(context).pop(false)),
        FeedAlertAction(text: SettingStrings.signOut, onPressed: () => Navigator.of(context).pop(true)),
      ],
    );
    if (confirmed != true) return;
    try {
      await ref.read(authControllerProvider.notifier).signOut();
    } on AppException catch (e) {
      if (context.mounted) showFeedToast(context, e.displayMessage);
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
      showFeedToast(context, SettingStrings.supportUnavailable);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    // RN Setting: 프로필 박스(흰) → 8px 회색 띠 → 메뉴 영역(회색 배경, flex:1)에 흰 메뉴행 + 로그아웃.
    return Scaffold(
      backgroundColor: FeedPalette.white,
      appBar: const FeedHeader(title: SettingStrings.title),
      body: Column(
        children: [
          _ProfileBox(user: user, onTap: () => context.push(Routes.settingProfile)),
          Container(height: 8, color: FeedPalette.whiteGray),
          Expanded(
            child: ColoredBox(
              color: FeedPalette.whiteGray,
              child: Column(
                children: [
                  FeedMenuRow(
                    icon: FeedIcons.settingLock,
                    iconSize: 19,
                    label: SettingStrings.menuLock,
                    onTap: () => context.push(Routes.settingLockdown),
                  ),
                  FeedMenuRow(
                    icon: FeedIcons.settingSupport,
                    iconSize: 17,
                    label: SettingStrings.menuSupport,
                    onTap: () => _sendSupportEmail(context, user),
                  ),
                  FeedMenuRow(label: SettingStrings.menuLicense, onTap: () => context.push(Routes.settingLicense)),
                  FeedMenuRow(
                    label: SettingStrings.menuAppVersion,
                    onTap: () => context.push(Routes.settingAppVersion),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () => _signOut(context, ref),
                      child: const Text(
                        SettingStrings.signOut,
                        style: TextStyle(
                          color: FeedPalette.orange,
                          decoration: TextDecoration.underline,
                          decorationColor: FeedPalette.orange,
                        ),
                      ),
                    ),
                  ),
                ],
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
    final isApple = user?.type.name == 'apple';
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding, vertical: 30),
        child: Row(
          children: [
            _Avatar(user: user, localBytes: avatar),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 닉네임 + 연두 "내 정보 수정"(같은 baseline). RN NicknameBox.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: Text(
                          user?.nickname ?? '',
                          style: const TextStyle(
                            fontFamily: FeedFonts.dovemayo,
                            fontSize: 17,
                            color: FeedPalette.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        SettingStrings.editProfile,
                        style: TextStyle(
                          fontFamily: FeedFonts.dovemayo,
                          fontSize: 12,
                          color: FeedPalette.main,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  // 소셜 로고(apple 은 검정 tint) + 계정 이메일. RN AccountBox.
                  Row(
                    children: [
                      Image.asset(
                        isApple ? AppAssets.appleIcon : AppAssets.googleIcon,
                        width: 14,
                        height: 14,
                        color: isApple ? FeedPalette.black : null,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          user?.account ?? '',
                          style: const TextStyle(
                            fontFamily: FeedFonts.dovemayo,
                            fontSize: 12,
                            color: FeedPalette.darkGray,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(FeedIcons.menuChevron, size: 25, color: FeedPalette.lightGray),
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
      child: const Icon(FeedIcons.question, size: 40, color: FeedPalette.white),
    );
  }
}
