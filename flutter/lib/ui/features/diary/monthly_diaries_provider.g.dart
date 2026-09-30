// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_diaries_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 특정 월(`YYYY-MM`)의 일기 목록. 본인 액션으로만 변경되므로 cacheFor(standard)로 캐시하고
/// 생성/수정/삭제 시 invalidate 한다. RN INDEPENDENT_QUERY_CONFIG.
/// 삭제·공개 전환은 재조회 응답 전에 로드된 목록을 먼저 고친다(RN MONTHLY_DIARIES setQueryData).

@ProviderFor(MonthlyDiaries)
final monthlyDiariesProvider = MonthlyDiariesFamily._();

/// 특정 월(`YYYY-MM`)의 일기 목록. 본인 액션으로만 변경되므로 cacheFor(standard)로 캐시하고
/// 생성/수정/삭제 시 invalidate 한다. RN INDEPENDENT_QUERY_CONFIG.
/// 삭제·공개 전환은 재조회 응답 전에 로드된 목록을 먼저 고친다(RN MONTHLY_DIARIES setQueryData).
final class MonthlyDiariesProvider extends $AsyncNotifierProvider<MonthlyDiaries, List<DailyDiary>> {
  /// 특정 월(`YYYY-MM`)의 일기 목록. 본인 액션으로만 변경되므로 cacheFor(standard)로 캐시하고
  /// 생성/수정/삭제 시 invalidate 한다. RN INDEPENDENT_QUERY_CONFIG.
  /// 삭제·공개 전환은 재조회 응답 전에 로드된 목록을 먼저 고친다(RN MONTHLY_DIARIES setQueryData).
  MonthlyDiariesProvider._({required MonthlyDiariesFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'monthlyDiariesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monthlyDiariesHash();

  @override
  String toString() {
    return r'monthlyDiariesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MonthlyDiaries create() => MonthlyDiaries();

  @override
  bool operator ==(Object other) {
    return other is MonthlyDiariesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthlyDiariesHash() => r'6c9930293f322997a3ba8dc4b663b4ae83ded244';

/// 특정 월(`YYYY-MM`)의 일기 목록. 본인 액션으로만 변경되므로 cacheFor(standard)로 캐시하고
/// 생성/수정/삭제 시 invalidate 한다. RN INDEPENDENT_QUERY_CONFIG.
/// 삭제·공개 전환은 재조회 응답 전에 로드된 목록을 먼저 고친다(RN MONTHLY_DIARIES setQueryData).

final class MonthlyDiariesFamily extends $Family
    with
        $ClassFamilyOverride<
          MonthlyDiaries,
          AsyncValue<List<DailyDiary>>,
          List<DailyDiary>,
          FutureOr<List<DailyDiary>>,
          String
        > {
  MonthlyDiariesFamily._()
    : super(
        retry: null,
        name: r'monthlyDiariesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 특정 월(`YYYY-MM`)의 일기 목록. 본인 액션으로만 변경되므로 cacheFor(standard)로 캐시하고
  /// 생성/수정/삭제 시 invalidate 한다. RN INDEPENDENT_QUERY_CONFIG.
  /// 삭제·공개 전환은 재조회 응답 전에 로드된 목록을 먼저 고친다(RN MONTHLY_DIARIES setQueryData).

  MonthlyDiariesProvider call(String month) => MonthlyDiariesProvider._(argument: month, from: this);

  @override
  String toString() => r'monthlyDiariesProvider';
}

/// 특정 월(`YYYY-MM`)의 일기 목록. 본인 액션으로만 변경되므로 cacheFor(standard)로 캐시하고
/// 생성/수정/삭제 시 invalidate 한다. RN INDEPENDENT_QUERY_CONFIG.
/// 삭제·공개 전환은 재조회 응답 전에 로드된 목록을 먼저 고친다(RN MONTHLY_DIARIES setQueryData).

abstract class _$MonthlyDiaries extends $AsyncNotifier<List<DailyDiary>> {
  late final _$args = ref.$arg as String;
  String get month => _$args;

  FutureOr<List<DailyDiary>> build(String month);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<DailyDiary>>, List<DailyDiary>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<DailyDiary>>, List<DailyDiary>>,
              AsyncValue<List<DailyDiary>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
