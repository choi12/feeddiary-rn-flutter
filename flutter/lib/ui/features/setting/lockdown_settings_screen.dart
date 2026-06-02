// 잠금 설정 화면 — 비밀번호 잠금 토글 + 비밀번호 재설정. RN screens/home/setting/LockdownSettings.
import 'package:feeddiary/data/services/lock_storage.dart';
import 'package:feeddiary/routing/routes.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
      appBar: AppBar(title: const Text(SettingStrings.lockTitle)),
      body: ListView(
        children: [
          SwitchListTile(title: const Text(SettingStrings.lockUseSwitch), value: _useLock, onChanged: _toggle),
          ListTile(
            title: const Text(SettingStrings.lockResetPassword),
            trailing: const Icon(Icons.chevron_right),
            enabled: _hasPassword,
            onTap: _resetPassword,
          ),
        ],
      ),
    );
  }
}
