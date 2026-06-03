// 회원가입 프로필 작성 화면 — 닉네임 검증 + 프로필 이미지(사진/캐릭터·공유 편집기) 후 가입. RN screens/start/CreateProfile 대응.
import 'package:feeddiary/config/validation_rules.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:feeddiary/ui/core/theme/tokens/color_primitives.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/core/theme/tokens/font_family.dart';
import 'package:feeddiary/ui/core/widgets/feed_button.dart';
import 'package:feeddiary/ui/core/widgets/feed_text_field.dart';
import 'package:feeddiary/ui/core/widgets/feed_toast.dart';
import 'package:feeddiary/ui/features/auth/create_profile_controller.dart';
import 'package:feeddiary/ui/features/setting/setting_strings.dart';
import 'package:feeddiary/ui/features/setting/widgets/nickname_noti.dart';
import 'package:feeddiary/ui/features/setting/widgets/profile_image_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 신규 사용자 프로필 작성 화면. [CreateProfileController]로 닉네임을 검증하고, 프로필 이미지(사진/캐릭터)를
/// 고른 뒤 가입한다(RN UpdateProfile 과 동일한 [ProfileImageEditor] 공유). 성공 시 redirect 가 home 으로 이동시킨다.
class CreateProfileScreen extends ConsumerStatefulWidget {
  const CreateProfileScreen({required this.info, super.key});

  final NewUserInfo info;

  @override
  ConsumerState<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends ConsumerState<CreateProfileScreen> {
  bool _submitting = false;

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await ref.read(createProfileControllerProvider.notifier).submit(widget.info);
      // 성공 시 authenticated 전환 → redirect 가 home 으로 이동.
    } on AppException catch (e) {
      if (mounted) {
        showFeedToast(context, e.displayMessage);
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(createProfileControllerProvider);
    final controller = ref.read(createProfileControllerProvider.notifier);

    return Scaffold(
      backgroundColor: FeedPalette.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppDimens.padding),
          children: [
            _TitleBox(onClose: () => Navigator.of(context).maybePop()),
            const SizedBox(height: 40),
            const Text(
              SettingStrings.nicknameLabel,
              style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FeedTextField(
              maxLength: ValidationRules.nicknameMaxLength,
              onChanged: controller.setNickname,
              hintText: '닉네임을 입력해 주세요',
            ),
            NicknameNoti(status: form.nicknameStatus),
            const _DividerLine(),
            ProfileImageEditor(
              imageType: form.imageType,
              character: form.character ?? '',
              background: form.background,
              imageBytes: form.imageBytes,
              onPhotoPicked: controller.pickPhoto,
              onCharacterSelected: controller.selectCharacter,
              onCharacterMode: controller.useCharacterMode,
              onBackgroundSelected: controller.setBackground,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppDimens.padding),
        child: FeedButton(title: '새싹일기 시작하기', onPressed: _submit, disabled: !form.canSubmit, isLoading: _submitting),
      ),
    );
  }
}

/// 제목 박스 — 큰 제목 + 안내 부제 + 우상단 닫기. RN CreateProfile `TitleBox` 대응.
class _TitleBox extends StatelessWidget {
  const _TitleBox({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '프로필 설정하기',
                style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 22, color: FeedPalette.black),
              ),
              SizedBox(height: 7),
              Text(
                '프로필 설정을 하면 회원 가입이 완료돼요.',
                style: TextStyle(fontFamily: FeedFonts.dovemayo, fontSize: 15, color: FeedPalette.darkGray),
              ),
            ],
          ),
        ),
        InkResponse(
          onTap: onClose,
          radius: 24,
          child: const Icon(FeedIcons.close, size: 28, color: FeedPalette.black),
        ),
      ],
    );
  }
}

/// 닉네임 영역과 프로필 이미지 영역을 가르는 구분선. RN `Line margin={40}` 대응.
class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Divider(height: 1, thickness: 1, color: FeedPalette.whiteGray),
    );
  }
}
