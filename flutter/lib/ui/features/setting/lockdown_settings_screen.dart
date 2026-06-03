// 잠금 설정 화면 — 비밀번호 잠금 토글 + 비밀번호 재설정. RN screens/home/setting/LockdownSettings.
import 'package:feeddiary/data/services/lock_storage.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 앱 잠금 사용 여부를 켜고 끄고, 비밀번호를 재설정한다. RN `LockdownSettings`/`useLockdownSettings` 1:1.
class LockdownSettingsScreen extends ConsumerStatefulWidget {
  const LockdownSettingsScreen({super.key});

  @override
  ConsumerState<LockdownSettingsScreen> createState() => _LockdownSettingsScreenState();
}

class _LockdownSettingsScreenState extends ConsumerState<LockdownSettingsScreen> {
  bool _useLock = false;
  bool _hasPassword = false;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  void _sync() {
    final lock = ref.read(lockStorageProvider);
    setState(() {
      _useLock = lock.useLock;
      _hasPassword = lock.hasPassword;
    });
  }

  void _toast(String message) {
    // 잠금 설정 토스트는 모두 내부 화면 오프셋. RN useLockdownSettings TOAST_BOTTOM_OFFSET.INNER_SCREEN.
    showFeedToast(context, message, offset: FeedToastOffset.inner);
  }

  Future<void> _toggle(bool value) async {
    final lock = ref.read(lockStorageProvider);
    if (value) {
      // 켜기 — 비밀번호가 없으면 설정 화면으로 유도, 있으면 바로 활성화.
      if (!lock.hasPassword) {
        _toast(SettingStrings.setPasswordFirst);
        await context.push<void>(Routes.settingLockPassword);
        _sync();
      } else {
        await lock.enableLock();
        _sync();
        _toast(SettingStrings.appLockEnabled);
      }
    } else {
      await lock.disableLock();
      _sync();
    }
  }

  Future<void> _resetPassword() async {
    await context.push<void>(Routes.settingLockPassword);
    _sync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FeedPalette.white,
      appBar: const FeedHeader(title: SettingStrings.lockTitle, hasBackButton: true),
      body: Column(
        children: [
          _LockRow(
            label: SettingStrings.lockUseSwitch,
            // RN: 행 전체(Pressable) 탭으로도 토글된다(handleLockToggle).
            onTap: () => _toggle(!_useLock),
            // RN Switch transform scale 0.6(iOS) — 기본 CupertinoSwitch 가 커서 축소.
            trailing: Transform.scale(
              scale: 0.6,
              alignment: Alignment.centerRight,
              child: CupertinoSwitch(value: _useLock, onChanged: _toggle, activeTrackColor: FeedPalette.main),
            ),
          ),
          _LockRow(
            label: SettingStrings.lockResetPassword,
            enabled: _hasPassword,
            onTap: _hasPassword ? _resetPassword : null,
          ),
        ],
      ),
    );
  }
}

/// 잠금 설정 한 줄 — RN box(70px·가로패딩24·하단 1px 보더·텍스트15 lightBlack·비활성 lightGray). RN LockdownSettings.box.
class _LockRow extends StatelessWidget {
  const _LockRow({required this.label, this.trailing, this.onTap, this.enabled = true});

  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: FeedPalette.whiteGray)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: FeedFonts.dovemayo,
                fontSize: 15,
                color: enabled ? FeedPalette.lightBlack : FeedPalette.lightGray,
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
