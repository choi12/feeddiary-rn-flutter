// 앱 진입점 — 토큰·잠금 캐시 hydrate 후 Riverpod 컨테이너로 앱 실행.
import 'package:feeddiary/app.dart';
import 'package:feeddiary/data/services/lock_storage.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // retry: (_, _) => null 은 RN React Query 의 retry:false 대응(실패 provider 자동 재시도 비활성).
  final container = ProviderContainer(retry: (_, _) => null);

  // 토큰·잠금 캐시를 미리 채워(부팅 1회) 인터셉터의 sync 토큰 조회와 잠금 가드의 sync useLock 검사를 보장한다.
  // RN setupInitialAppConfig 의 loadAccessToken + 잠금 저장소(MMKV sync) 대응.
  await container.read(tokenStorageProvider).load();
  await container.read(lockStorageProvider).load();

  runApp(UncontrolledProviderScope(container: container, child: const FeedDiaryApp()));
}
