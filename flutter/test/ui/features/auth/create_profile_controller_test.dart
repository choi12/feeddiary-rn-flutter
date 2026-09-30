// CreateProfileController — 닉네임 검증(정규식/성공/중복) + canSubmit. ProviderContainer + http_mock_adapter (Tier B).
import 'package:dio/dio.dart';
import 'package:feeddiary/data/services/demo_api_adapter.dart';
import 'package:feeddiary/data/services/dio_client.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:feeddiary/ui/features/auth/create_profile_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;

  ProviderContainer makeContainer() {
    final container = ProviderContainer(retry: (_, _) => null, overrides: [dioProvider.overrideWithValue(dio)]);
    addTearDown(container.dispose);
    // autoDispose provider 를 테스트 동안 유지(read 사이 폐기 방지).
    container.listen(createProfileControllerProvider, (_, _) {});
    return container;
  }

  setUp(() {
    dio = buildDio(TokenStorage(const FlutterSecureStorage()));
    adapter = DioAdapter(dio: dio);
  });

  test('정규식 불일치(1자) → regex', () async {
    final container = makeContainer();
    await container.read(createProfileControllerProvider.notifier).validateNickname('a');
    expect(container.read(createProfileControllerProvider).nicknameStatus, NicknameStatus.regex);
  });

  test('빈 값 → 상태 없음', () async {
    final container = makeContainer();
    await container.read(createProfileControllerProvider.notifier).validateNickname('   ');
    expect(container.read(createProfileControllerProvider).nicknameStatus, isNull);
  });

  test('정규식 통과 + 사용 가능 → success', () async {
    adapter.onPost('/auth/check-nickname', (server) => server.reply(200, {'status': 'success'}), data: Matchers.any);
    final container = makeContainer();
    await container.read(createProfileControllerProvider.notifier).validateNickname('새싹');
    expect(container.read(createProfileControllerProvider).nicknameStatus, NicknameStatus.success);
  });

  test('중복(409) → duplicate', () async {
    adapter.onPost('/auth/check-nickname', (server) => server.reply(409, {'message': '중복'}), data: Matchers.any);
    final container = makeContainer();
    await container.read(createProfileControllerProvider.notifier).validateNickname('admin');
    expect(container.read(createProfileControllerProvider).nicknameStatus, NicknameStatus.duplicate);
  });

  testWidgets('중복검사 응답 전에 입력이 바뀌면 옛 입력의 success 가 새 regex 를 덮지 않는다', (tester) async {
    // 데모 기본 지연은 0 이라 경합이 안 생긴다 — 응답이 두 번째 입력 뒤에 오도록 600ms 지연을 주입한다.
    dio.httpClientAdapter = DemoApiAdapter(latency: const Duration(milliseconds: 600));
    final container = makeContainer();
    final notifier = container.read(createProfileControllerProvider.notifier)..selectCharacter('Chick');

    notifier.setNickname('abc');
    await tester.pump(const Duration(milliseconds: 500)); // 디바운스 400ms → 'abc' 중복검사 요청(지연 600ms)
    notifier.setNickname('ab!');
    await tester.pump(const Duration(milliseconds: 400)); // 'ab!' 정규식 불일치 → regex
    await tester.pump(const Duration(milliseconds: 400)); // 'abc' 응답 도착
    final state = container.read(createProfileControllerProvider);
    expect(state.nickname, 'ab!');
    expect(state.nicknameStatus, NicknameStatus.regex);
    expect(state.canSubmit, isFalse);
  });

  test('canSubmit 는 닉네임 성공 + 캐릭터 선택 시 true', () async {
    adapter.onPost('/auth/check-nickname', (server) => server.reply(200, {'status': 'success'}), data: Matchers.any);
    final container = makeContainer();
    final controller = container.read(createProfileControllerProvider.notifier);
    await controller.validateNickname('새싹');
    expect(container.read(createProfileControllerProvider).canSubmit, isFalse);
    controller.selectCharacter('Chick');
    expect(container.read(createProfileControllerProvider).canSubmit, isTrue);
  });
}
