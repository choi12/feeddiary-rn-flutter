// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flowerpot_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 화분 상태. 본인 액션으로만 변하므로 keepAlive 로 유지한다(RN INDEPENDENT_QUERY_CONFIG).
/// 물주기/사랑주기는 서버가 exp·레벨·충전을 계산하므로 비낙관 — 성공 후 invalidateSelf 로 재조회한다.

@ProviderFor(FlowerpotController)
final flowerpotControllerProvider = FlowerpotControllerProvider._();

/// 화분 상태. 본인 액션으로만 변하므로 keepAlive 로 유지한다(RN INDEPENDENT_QUERY_CONFIG).
/// 물주기/사랑주기는 서버가 exp·레벨·충전을 계산하므로 비낙관 — 성공 후 invalidateSelf 로 재조회한다.
final class FlowerpotControllerProvider extends $AsyncNotifierProvider<FlowerpotController, Flowerpot> {
  /// 화분 상태. 본인 액션으로만 변하므로 keepAlive 로 유지한다(RN INDEPENDENT_QUERY_CONFIG).
  /// 물주기/사랑주기는 서버가 exp·레벨·충전을 계산하므로 비낙관 — 성공 후 invalidateSelf 로 재조회한다.
  FlowerpotControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flowerpotControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flowerpotControllerHash();

  @$internal
  @override
  FlowerpotController create() => FlowerpotController();
}

String _$flowerpotControllerHash() => r'0d82f7dd0a84124816184aa1ed697b34006a93bd';

/// 화분 상태. 본인 액션으로만 변하므로 keepAlive 로 유지한다(RN INDEPENDENT_QUERY_CONFIG).
/// 물주기/사랑주기는 서버가 exp·레벨·충전을 계산하므로 비낙관 — 성공 후 invalidateSelf 로 재조회한다.

abstract class _$FlowerpotController extends $AsyncNotifier<Flowerpot> {
  FutureOr<Flowerpot> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Flowerpot>, Flowerpot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Flowerpot>, Flowerpot>,
              AsyncValue<Flowerpot>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
