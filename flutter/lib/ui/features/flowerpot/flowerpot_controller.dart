// 화분 컨트롤러 — 화분 서버상태(keepAlive) + 물주기/사랑주기(비낙관·중복가드). RN useFlowerpotQuery+usePlantInteraction 대응.
import 'package:feeddiary/data/models/flowerpot.dart';
import 'package:feeddiary/data/repositories/flowerpot_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flowerpot_controller.g.dart';

/// 화분 상태. 본인 액션으로만 변하므로 keepAlive 로 유지한다(RN INDEPENDENT_QUERY_CONFIG).
/// 물주기/사랑주기는 서버가 exp·레벨·충전을 계산하므로 비낙관 — 성공 후 invalidateSelf 로 재조회한다.
@Riverpod(keepAlive: true)
class FlowerpotController extends _$FlowerpotController {
  // 진행 중 액션 중복 실행을 막는 가드(RN useThrottle 대응). 화면 버튼 비활성과 별개의 안전망.
  bool _busy = false;

  @override
  Future<Flowerpot> build() {
    return ref.watch(flowerpotRepositoryProvider).getFlowerpot();
  }

  /// 물 주기. 성공 시 화분을 재조회한다. 실패는 호출부로 전파한다. RN usePlantInteraction.wateringPlant.
  Future<void> water() => _runAction(() => ref.read(flowerpotRepositoryProvider).wateringPlant());

  /// 사랑 주기. 거동은 [water]와 동일. RN usePlantInteraction.lovePlant.
  Future<void> love() => _runAction(() => ref.read(flowerpotRepositoryProvider).lovePlant());

  Future<void> _runAction(Future<void> Function() action) async {
    if (_busy) {
      return;
    }
    _busy = true;
    try {
      await action();
      ref.invalidateSelf();
    } finally {
      _busy = false;
    }
  }
}
