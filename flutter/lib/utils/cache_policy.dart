// Riverpod 캐시 정책 — RN React Query 3프리셋(utils/config/query.ts) 매핑.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 캐시 보존 시간 프리셋. RN React Query 의 gcTime/staleTime 분류를 Riverpod 로 매핑.
///
/// - 기본: 마지막 listener 가 사라진 뒤 [standardGcTime] 동안 캐시 유지(= React Query gcTime 30분).
///   staleTime 은 Riverpod 이 invalidate 전까지 캐시를 서빙하므로 "명시 invalidate 로 refetch"로 매핑.
/// - 독립(본인 액션만 변경): `@Riverpod(keepAlive: true)`로 영구 유지(gcTime/staleTime Infinity).
/// - 실시간(타인 액션 반영): [realtimeGcTime](30초) + 화면 진입/새로고침 시 invalidate.
abstract final class CachePolicy {
  static const Duration standardGcTime = Duration(minutes: 30);
  static const Duration realtimeGcTime = Duration(seconds: 30);
}

/// 서버상태 provider 의 캐시 수명 제어 확장.
extension CacheForRef on Ref {
  /// 마지막 listener 가 사라진 뒤 [duration] 동안 결과를 캐시한다(React Query gcTime 대응).
  /// listener 가 다시 붙으면 폐기 타이머를 취소한다.
  void cacheFor(Duration duration) {
    final link = keepAlive();
    Timer? timer;
    onCancel(() => timer = Timer(duration, link.close));
    onResume(() => timer?.cancel());
    onDispose(() => timer?.cancel());
  }
}
