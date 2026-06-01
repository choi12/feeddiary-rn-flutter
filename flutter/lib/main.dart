// 앱 진입점 — 토큰 캐시 hydrate 후 Riverpod 컨테이너로 앱 실행.
import 'package:feeddiary/app.dart';
import 'package:feeddiary/data/services/token_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // retry: (_, _) => null 은 RN React Query 의 retry:false 대응(실패 provider 자동 재시도 비활성).
  final container = ProviderContainer(retry: (_, _) => null);

  // 토큰 캐시를 미리 채워(부팅 1회) 인터셉터의 sync 조회를 보장한다. RN setupInitialAppConfig 의 loadAccessToken 대응.
  await container.read(tokenStorageProvider).load();

  runApp(UncontrolledProviderScope(container: container, child: const FeedDiaryApp()));
}
