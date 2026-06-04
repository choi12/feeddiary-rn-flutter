// 앱 로거 — print 금지(avoid_print) 대응. dart:developer log 래퍼. RN reportError 대응.
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// 경량 로거. `print` 대신 dart:developer 의 log 을 쓴다.
/// 상세 로그(network/debug)는 [kDebugMode]에서만 출력. (Sentry 등 관측성은 데모에서 미연동 — DSN 자리만.)
abstract final class AppLogger {
  static const String _name = 'feedDiary';

  /// 네트워크 트레이스(요청/응답/에러). 디버그 빌드 전용.
  static void network(String message) {
    if (kDebugMode) {
      developer.log(message, name: '$_name.net');
    }
  }

  /// 일반 디버그 로그. 디버그 빌드 전용.
  static void debug(String message) {
    if (kDebugMode) {
      developer.log(message, name: _name);
    }
  }

  /// 에러 로그(릴리즈 포함).
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(message, name: '$_name.error', error: error, stackTrace: stackTrace);
  }
}
