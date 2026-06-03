// 프로필 수정 화면 — 닉네임·프로필 이미지(공유 편집기)·저장·계정 탈퇴. RN screens/home/setting/UpdateProfile + components/profile/*.
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_alert_dialog.dart';
import 'package:feeddiary/ui/core/widgets/feed_button.dart';
import 'package:feeddiary/ui/core/widgets/feed_header.dart';
import 'package:feeddiary/ui/core/widgets/feed_text_field.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
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
      showFeedToast(context, SettingStrings.profileUpdated);
      context.pop();
    } on AppException catch (e) {
      if (!mounted) return;
      showFeedToast(context, e.displayMessage);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final confirmed = await showFeedAlert<bool>(
      context: context,
      message: SettingStrings.deleteAccountConfirm,
      actions: [
        FeedAlertAction(text: SettingStrings.cancel, isCancel: true, onPressed: () => Navigator.of(context).pop(false)),
        FeedAlertAction(text: SettingStrings.deleteAccount, onPressed: () => Navigator.of(context).pop(true)),
      ],
    );
    if (confirmed != true) return;
    try {
      // 성공 시 signOut → redirect 로 화면이 사라진다(별도 pop 불필요).
      await _controller.deleteAccount();
    } on AppException catch (e) {
      if (!mounted) return;
      showFeedToast(context, e.displayMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updateProfileControllerProvider);
    return Scaffold(
      backgroundColor: FeedPalette.white,
      appBar: FeedHeader(
        title: SettingStrings.updateProfileTitle,
        hasBackButton: true,
        rightItem: GestureDetector(
          onTap: _confirmDeleteAccount,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              SettingStrings.deleteAccount,
              style: TextStyle(
                fontFamily: FeedFonts.dovemayo,
                fontSize: 14,
                color: FeedPalette.orange,
                decoration: TextDecoration.underline,
                decorationColor: FeedPalette.orange,
              ),
            ),
          ),
        ),
      ),
      // 화면 순서 = 닉네임 → Line(30) → 프로필 이미지. RN UpdateProfile/index.tsx.
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.padding),
        children: [
          // 닉네임 가로 배치(라벨 폭 55 + 입력 flex). RN NicknameSection.
          Row(
            children: [
              const SizedBox(
                width: 55,
                child: Text(
                  SettingStrings.nicknameLabel,
                  style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 15, color: FeedPalette.black),
                ),
              ),
              Expanded(
                child: FeedTextField(
                  controller: _nicknameController,
                  maxLength: 8,
                  onChanged: _controller.setNickname,
                  hintText: SettingStrings.nicknamePlaceholder,
                ),
              ),
            ],
          ),
          // 검증 안내는 라벨 폭(55)에 맞춰 들여쓴다. RN NotiBox(marginTop10·marginLeft55).
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 55),
            child: NicknameNoti(status: state.nicknameStatus),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Divider(height: 1, thickness: 1, color: FeedPalette.whiteGray),
          ),
          ProfileImageEditor(
            imageType: state.imageType,
            character: state.character,
            background: state.background,
            imageBytes: state.imageBytes,
            onPhotoPicked: _controller.pickPhoto,
            onCharacterSelected: _controller.selectCharacter,
            onCharacterMode: _controller.useCharacterMode,
            onBackgroundSelected: _controller.setBackground,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppDimens.padding),
        child: FeedButton(
          title: SettingStrings.updateSubmit,
          onPressed: _save,
          disabled: !state.canSubmit,
          isLoading: _saving,
        ),
      ),
    );
  }
}
