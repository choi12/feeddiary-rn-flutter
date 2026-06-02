// 잠금 비밀번호 설정 화면 — 4자리 2단계(입력→확인). RN screens/home/setting/SettingLockPassword.
import 'package:feeddiary/data/services/lock_storage.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:feeddiary/ui/features/setting/widgets/digit_keypad.dart';
import 'package:feeddiary/ui/features/setting/widgets/password_dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 잠금 비밀번호를 새로 설정한다. 1단계 입력 → 2단계 확인, 일치하면 저장+활성화. RN `SettingLockPassword`/`useSettingLockPassword` 1:1.
class LockPasswordScreen extends ConsumerStatefulWidget {
  const LockPasswordScreen({super.key});

  @override
  ConsumerState<LockPasswordScreen> createState() => _LockPasswordScreenState();
}

class _LockPasswordScreenState extends ConsumerState<LockPasswordScreen> {
  static const int _length = 4;

  int _step = 1;
  String _first = '';
  String _confirm = '';

  String get _current => _step == 1 ? _first : _confirm;

  void _onDigit(String digit) {
    if (_current.length >= _length) return;
    setState(() {
      if (_step == 1) {
        _first += digit;
      } else {
        _confirm += digit;
      }
    });
    if (_step == 1 && _first.length == _length) {
      setState(() => _step = 2);
    } else if (_step == 2 && _confirm.length == _length) {
      _validate();
    }
  }

  void _onDelete() {
    if (_current.isEmpty) return;
    setState(() {
      if (_step == 1) {
        _first = _first.substring(0, _first.length - 1);
      } else {
        _confirm = _confirm.substring(0, _confirm.length - 1);
      }
    });
  }

  Future<void> _validate() async {
    if (_first != _confirm) {
      showFeedToast(context, SettingStrings.passwordMismatch);
      setState(() => _confirm = '');
      return;
    }
    final lock = ref.read(lockStorageProvider);
    await lock.setPassword(_first);
    await lock.enableLock();
    if (!mounted) return;
    showFeedToast(context, SettingStrings.passwordSet);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FeedPalette.white,
      appBar: const FeedHeader(title: SettingStrings.lockSetTitle, hasBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _step == 1 ? SettingStrings.passwordEnter : SettingStrings.passwordConfirm,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 28),
              PasswordDots(filled: _current.length),
              const SizedBox(height: 40),
              DigitKeypad(onDigit: _onDigit, onDelete: _onDelete),
            ],
          ),
        ),
      ),
    );
  }
}
