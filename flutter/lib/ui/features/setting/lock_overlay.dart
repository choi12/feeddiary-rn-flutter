// 잠금 해제 화면 — 비밀번호 입력→검증→해제. RN screens/home/LockScreen. 라우터 위 Stack 오버레이(라우트 아님).
import 'package:feeddiary/data/services/lock_storage.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:feeddiary/ui/features/setting/widgets/digit_keypad.dart';
import 'package:feeddiary/ui/features/setting/widgets/password_dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 앱 잠금 해제 오버레이. 4자리 비밀번호가 채워지면 검증하고, 일치하면 [onUnlocked]를 호출한다.
/// `PopScope(canPop:false)`로 뒤로가기를 막는다(RN Android `BackHandler` 차단 대응).
class LockOverlay extends ConsumerStatefulWidget {
  const LockOverlay({required this.onUnlocked, super.key});

  /// 비밀번호 일치 시 호출(가드가 오버레이를 내린다).
  final VoidCallback onUnlocked;

  @override
  ConsumerState<LockOverlay> createState() => _LockOverlayState();
}

class _LockOverlayState extends ConsumerState<LockOverlay> {
  static const int _length = 4;

  String _input = '';
  bool _error = false;

  void _onDigit(String digit) {
    if (_input.length >= _length) return;
    setState(() {
      _input += digit;
      _error = false;
    });
    if (_input.length == _length) {
      _verify();
    }
  }

  void _onDelete() {
    if (_input.isEmpty) return;
    setState(() {
      _input = _input.substring(0, _input.length - 1);
      _error = false;
    });
  }

  void _verify() {
    if (ref.read(lockStorageProvider).verify(_input)) {
      widget.onUnlocked();
    } else {
      setState(() {
        _input = '';
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Material(
        color: context.colors.background,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FeedIcons.settingLock, size: 48, color: context.colors.primary),
                const SizedBox(height: 24),
                const Text(SettingStrings.unlockTitle, style: TextStyle(fontSize: 18)),
                const SizedBox(height: 28),
                PasswordDots(filled: _input.length),
                const SizedBox(height: 12),
                SizedBox(
                  height: 18,
                  child: _error
                      ? const Text(
                          SettingStrings.passwordMismatch,
                          style: TextStyle(fontSize: 12, color: FeedPalette.orange),
                        )
                      : null,
                ),
                const SizedBox(height: 28),
                DigitKeypad(onDigit: _onDigit, onDelete: _onDelete),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
