// 잠금 비밀번호 설정 화면 — 4자리 2단계(입력→확인). RN screens/home/setting/SettingLockPassword.
import 'package:feeddiary/data/services/lock_storage.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
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
      showFeedToast(context, SettingStrings.passwordMismatch, offset: FeedToastOffset.inner);
      setState(() => _confirm = '');
      return;
    }
    final lock = ref.read(lockStorageProvider);
    await lock.setPassword(_first);
    await lock.enableLock();
    if (!mounted) return;
    showFeedToast(context, SettingStrings.passwordSet, offset: FeedToastOffset.inner);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    // RN: SafeAreaContainer(배경 #F3F3F3) → CustomHeader(닫기) → Container → PasswordBox(flex 중앙: 제목+점) + DigitKeypad(하단).
    return Scaffold(
      backgroundColor: FeedPalette.whiteGray,
      // 헤더 배경을 본문(회색)과 맞춘다 — RN CustomHeader 가 투명이라 SafeAreaContainer 의 BACKGROUND 가 비침.
      appBar: const FeedHeader(
        title: SettingStrings.lockSetTitle,
        hasCloseButton: true,
        backgroundColor: FeedPalette.whiteGray,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _step == 1 ? SettingStrings.passwordEnter : SettingStrings.passwordConfirm,
                      style: const TextStyle(
                        fontFamily: FeedFonts.dovemayo,
                        fontSize: 15,
                        color: FeedPalette.lightBlack,
                      ),
                    ),
                    const SizedBox(height: 30),
                    PasswordDots(filled: _current.length),
                  ],
                ),
              ),
            ),
            DigitKeypad(onDigit: _onDigit, onDelete: _onDelete),
          ],
        ),
      ),
    );
  }
}
