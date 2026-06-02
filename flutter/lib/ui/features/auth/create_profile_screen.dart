// 회원가입 프로필 작성 화면 — 닉네임 검증 + 캐릭터 선택 후 가입. RN screens/start/CreateProfile 대응.
import 'package:feeddiary/config/validation_rules.dart';
import 'package:feeddiary/domain/exceptions/app_exception.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/core/theme/build_context_x.dart';
import 'package:feeddiary/ui/core/theme/tokens/dimens.dart';
import 'package:feeddiary/ui/features/auth/create_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 프리셋 캐릭터(데모 — native image_picker 보류). 이름은 백엔드 `character` 필드로 전송.
const List<({String name, IconData icon})> _characters = [
  (name: 'Chick', icon: Icons.egg_alt),
  (name: 'Sprout', icon: Icons.eco),
  (name: 'Flower', icon: Icons.local_florist),
  (name: 'Star', icon: Icons.star),
];

/// 신규 사용자 프로필 작성 화면. [CreateProfileController]로 닉네임을 검증하고,
/// 캐릭터를 고른 뒤 [AuthController.signUp]으로 가입한다. 성공 시 redirect 가 home 으로 이동시킨다.
class CreateProfileScreen extends ConsumerStatefulWidget {
  const CreateProfileScreen({required this.info, super.key});

  final NewUserInfo info;

  @override
  ConsumerState<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends ConsumerState<CreateProfileScreen> {
  bool _submitting = false;

  Future<void> _submit() async {
    final form = ref.read(createProfileControllerProvider);
    setState(() => _submitting = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .signUp(info: widget.info, nickname: form.nickname.trim(), character: form.character!);
      // 성공 시 authenticated 전환 → redirect 가 home 으로 이동.
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.displayMessage)));
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(createProfileControllerProvider);
    final controller = ref.read(createProfileControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('프로필 만들기')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('새싹이의 이름을 지어주세요', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              TextField(
                maxLength: ValidationRules.nicknameMaxLength,
                onChanged: controller.setNickname,
                decoration: const InputDecoration(
                  labelText: '닉네임',
                  hintText: ValidationRules.nicknameHint,
                  border: OutlineInputBorder(),
                ),
              ),
              _NicknameFeedback(status: form.nicknameStatus),
              const SizedBox(height: 24),
              Text('캐릭터 선택', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: [
                  for (final c in _characters)
                    ChoiceChip(
                      avatar: Icon(c.icon),
                      label: Text(c.name),
                      selected: form.character == c.name,
                      onSelected: (_) => controller.setCharacter(c.name),
                    ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: AppDimens.buttonHeight,
                child: FilledButton(
                  onPressed: (form.canSubmit && !_submitting) ? _submit : null,
                  child: _submitting
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('새싹일기 시작하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 닉네임 검증 상태별 피드백 문구. RN NicknameSection 의 안내문 대응.
class _NicknameFeedback extends StatelessWidget {
  const _NicknameFeedback({required this.status});

  final NicknameStatus? status;

  @override
  Widget build(BuildContext context) {
    final (message, color) = switch (status) {
      NicknameStatus.success => ('사용 가능한 닉네임이에요.', context.colors.primary),
      NicknameStatus.duplicate => ('이미 사용 중인 닉네임이에요.', context.colors.error),
      NicknameStatus.regex => ('${ValidationRules.nicknameHint} 형식이어야 해요.', context.colors.error),
      null => ('', context.colors.textSecondary),
    };
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(message, style: TextStyle(color: color, fontSize: 13)),
      ),
    );
  }
}
