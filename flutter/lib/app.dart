// feedDiary 앱 루트 — MaterialApp.router 로 GoRouter + 디자인 토큰 테마를 조립. builder 로 잠금 가드(LockGate)를 라우터 위에 얹는다.
import 'package:feeddiary/routing/app_router.dart';
import 'package:feeddiary/ui/core/theme/app_theme.dart';
import 'package:feeddiary/ui/features/setting/widgets/lock_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 앱 루트 위젯. [appRouterProvider]의 GoRouter 설정과 [buildAppTheme] 테마를
/// MaterialApp.router 에 연결하고, [LockGate]로 Navigator 위에 잠금 오버레이를 얹는다(A-6).
class FeedDiaryApp extends ConsumerWidget {
  const FeedDiaryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: '새싹일기',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: router,
      builder: (context, child) => LockGate(child: child ?? const SizedBox.shrink()),
    );
  }
}
