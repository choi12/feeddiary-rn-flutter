// 프로필 수정 화면 — 닉네임·프로필 이미지(공유 편집기)·저장·계정 탈퇴. RN screens/home/setting/UpdateProfile + components/profile/*.
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:feeddiary/ui/features/setting/update_profile_controller.dart';
import 'package:feeddiary/ui/features/setting/widgets/nickname_noti.dart';
import 'package:feeddiary/ui/features/setting/widgets/profile_image_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 프로필 수정 화면. 닉네임 검증 + 프로필 이미지(사진/캐릭터·공유 [ProfileImageEditor]) + 저장 + 계정 탈퇴.
/// RN `UpdateProfile`(+ ProfileProvider·NicknameSection·ProfileImageSection·DeleteAccountButton).
class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  late final TextEditingController _nicknameController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: ref.read(updateProfileControllerProvider).nickname);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  UpdateProfileController get _controller => ref.read(updateProfileControllerProvider.notifier);

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await _controller.submit();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SettingStrings.profileUpdated)));
      context.pop();
    } on AppException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.displayMessage)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(SettingStrings.deleteAccountConfirm),
        actions: [
          TextButton(onPressed: () => context.pop(false), child: const Text(SettingStrings.cancel)),
          TextButton(onPressed: () => context.pop(true), child: const Text(SettingStrings.deleteAccount)),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      // 성공 시 signOut → redirect 로 화면이 사라진다(별도 pop 불필요).
      await _controller.deleteAccount();
    } on AppException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.displayMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updateProfileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(SettingStrings.updateProfileTitle),
        actions: [
          TextButton(
            onPressed: _confirmDeleteAccount,
            child: const Text(SettingStrings.deleteAccount, style: TextStyle(color: FeedPalette.orange)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.padding),
        children: [
          ProfileImageEditor(
            imageType: state.imageType,
            character: state.character,
            background: state.background,
            imageBytes: state.imageBytes,
            onPhotoPicked: _controller.pickPhoto,
            onCharacterSelected: _controller.selectCharacter,
            onBackgroundSelected: _controller.setBackground,
          ),
          const SizedBox(height: 24),
          const Text(SettingStrings.nicknameLabel, style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _nicknameController,
            maxLength: 8,
            onChanged: _controller.setNickname,
            decoration: const InputDecoration(hintText: '닉네임을 입력해 주세요', counterText: ''),
          ),
          NicknameNoti(status: state.nicknameStatus),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppDimens.padding),
        child: SizedBox(
          height: AppDimens.buttonHeight,
          child: FilledButton(
            onPressed: state.canSubmit && !_saving ? _save : null,
            child: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text(SettingStrings.save),
          ),
        ),
      ),
    );
  }
}
