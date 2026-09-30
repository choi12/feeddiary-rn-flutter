// UpdateProfileController — 초기화·닉네임 검증 재사용·변경 감지(canSubmit)·submit→AuthController 갱신 (ProviderContainer + http_mock).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/models/user.dart';
import 'package:feeddiary/data/services/demo_api_adapter.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/domain/models/sign_in_type.dart';
import 'package:feeddiary/routing/auth_state.dart';
import 'package:feeddiary/ui/features/auth/create_profile_controller.dart' show NicknameStatus;
import 'package:feeddiary/ui/features/setting/profile_image_type.dart';
import 'package:feeddiary/ui/features/setting/update_profile_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;

  final testUser = User(
    idx: 1,
    account: 'demo@example.com',
    userId: 'mock_user_id',
    nickname: '새싹이',
    image: '',
    background: '',
    character: 'Chick',
    type: SignInType.google,
    createdAt: DateTime.utc(2026),
    token: 'tok',
    fcmToken: '',
  );

  Map<String, dynamic> userJson({required String nickname, required String character}) => {
    'idx': 1,
    'account': 'demo@example.com',
    'user_id': 'mock_user_id',
    'nickname': nickname,
    'image': '',
    'background': '',
    'character': character,
    'type': 'google',
    'created_time': '2026-01-01T00:00:00.000Z',
    'token': 'tok',
    'fcm_token': '',
  };

  ProviderContainer makeContainer() {
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    container.read(authControllerProvider.notifier).setUser(testUser);
    container.listen(updateProfileControllerProvider, (_, _) {});
    return container;
  }

  setUp(() {
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('build 는 현재 사용자로 초기화하고 변경 전엔 저장 불가', () {
    final container = makeContainer();
    final state = container.read(updateProfileControllerProvider);
    expect(state.nickname, '새싹이');
    expect(state.character, 'Chick');
    expect(state.imageType, ProfileImageType.character);
    expect(state.canSubmit, isFalse);
  });

  test('캐릭터를 바꾸면 dirty → 저장 가능', () {
    final container = makeContainer();
    container.read(updateProfileControllerProvider.notifier).selectCharacter('Bat');
    final state = container.read(updateProfileControllerProvider);
    expect(state.character, 'Bat');
    expect(state.canSubmit, isTrue);
  });

  test('닉네임 정규식 불일치 → regex, 저장 불가', () async {
    final container = makeContainer();
    await container.read(updateProfileControllerProvider.notifier).validateNickname('a');
    final state = container.read(updateProfileControllerProvider);
    expect(state.nicknameStatus, NicknameStatus.regex);
    expect(state.canSubmit, isFalse);
  });

  test('새 닉네임 사용 가능 → success + 저장 가능', () async {
    adapter.onPost('/auth/check-nickname', (server) => server.reply(200, {'status': 'success'}), data: Matchers.any);
    final container = makeContainer();
    final notifier = container.read(updateProfileControllerProvider.notifier);
    notifier.setNickname('바뀐닉'); // 값 갱신(변경 감지) + 디바운스 예약
    await notifier.validateNickname('바뀐닉'); // 즉시 검증
    final state = container.read(updateProfileControllerProvider);
    expect(state.nicknameStatus, NicknameStatus.success);
    expect(state.canSubmit, isTrue);
  });

  testWidgets('중복검사 응답 전에 입력이 바뀌면 옛 입력의 success 가 새 regex 를 덮지 않는다', (tester) async {
    // 데모 기본 지연은 0 이라 경합이 안 생긴다 — 응답이 두 번째 입력 뒤에 오도록 600ms 지연을 주입한다.
    dio.httpClientAdapter = DemoApiAdapter(latency: const Duration(milliseconds: 600));
    final container = makeContainer();
    final notifier = container.read(updateProfileControllerProvider.notifier);

    notifier.setNickname('abc');
    await tester.pump(const Duration(milliseconds: 500)); // 디바운스 400ms → 'abc' 중복검사 요청(지연 600ms)
    notifier.setNickname('ab!');
    await tester.pump(const Duration(milliseconds: 400)); // 'ab!' 정규식 불일치 → regex
    await tester.pump(const Duration(milliseconds: 400)); // 'abc' 응답 도착
    final state = container.read(updateProfileControllerProvider);
    expect(state.nickname, 'ab!');
    expect(state.nicknameStatus, NicknameStatus.regex);
    expect(state.canSubmit, isFalse);
  });

  test('현재 닉네임과 동일하면 검증 없이 무변경(저장 불가)', () async {
    final container = makeContainer();
    await container.read(updateProfileControllerProvider.notifier).validateNickname('새싹이');
    final state = container.read(updateProfileControllerProvider);
    expect(state.nicknameStatus, isNull);
    expect(state.canSubmit, isFalse);
  });

  test('submit 은 PUT /user 후 AuthController 사용자를 갱신한다', () async {
    adapter.onPut(
      '/user',
      (server) => server.reply(200, {'status': 'success', 'resData': userJson(nickname: '수정됨', character: 'Bat')}),
      data: Matchers.any,
    );
    final container = makeContainer();
    container.read(updateProfileControllerProvider.notifier).selectCharacter('Bat');
    await container.read(updateProfileControllerProvider.notifier).submit();
    expect(container.read(authControllerProvider).user?.nickname, '수정됨');
    expect(container.read(authControllerProvider).user?.character, 'Bat');
  });
}
