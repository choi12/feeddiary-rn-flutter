// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 미션 목록(진행중/완료). 본인 액션으로만 변하므로 keepAlive 로 유지한다(RN INDEPENDENT_QUERY_CONFIG).
/// 진행중/완료 탭 선택·자동 전환은 화면 로컬 setState 가 담당한다(RN useMissions 의 useState).

@ProviderFor(MissionsController)
final missionsControllerProvider = MissionsControllerProvider._();

/// 미션 목록(진행중/완료). 본인 액션으로만 변하므로 keepAlive 로 유지한다(RN INDEPENDENT_QUERY_CONFIG).
/// 진행중/완료 탭 선택·자동 전환은 화면 로컬 setState 가 담당한다(RN useMissions 의 useState).
final class MissionsControllerProvider extends $AsyncNotifierProvider<MissionsController, MissionsResult> {
  /// 미션 목록(진행중/완료). 본인 액션으로만 변하므로 keepAlive 로 유지한다(RN INDEPENDENT_QUERY_CONFIG).
  /// 진행중/완료 탭 선택·자동 전환은 화면 로컬 setState 가 담당한다(RN useMissions 의 useState).
  MissionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'missionsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$missionsControllerHash();

  @$internal
  @override
  MissionsController create() => MissionsController();
}

String _$missionsControllerHash() => r'c162c4cd99e6bc1d8fb43257c3310052cc2dba03';

/// 미션 목록(진행중/완료). 본인 액션으로만 변하므로 keepAlive 로 유지한다(RN INDEPENDENT_QUERY_CONFIG).
/// 진행중/완료 탭 선택·자동 전환은 화면 로컬 setState 가 담당한다(RN useMissions 의 useState).

abstract class _$MissionsController extends $AsyncNotifier<MissionsResult> {
  FutureOr<MissionsResult> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MissionsResult>, MissionsResult>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MissionsResult>, MissionsResult>,
              AsyncValue<MissionsResult>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
