// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_diaries_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 특정 월(`YYYY-MM`)의 일기 목록. 본인 액션으로만 변경되므로 cacheFor(standard)로 캐시하고
/// 생성/수정/삭제 시 invalidate 한다. RN INDEPENDENT_QUERY_CONFIG.

@ProviderFor(monthlyDiaries)
final monthlyDiariesProvider = MonthlyDiariesFamily._();

/// 특정 월(`YYYY-MM`)의 일기 목록. 본인 액션으로만 변경되므로 cacheFor(standard)로 캐시하고
/// 생성/수정/삭제 시 invalidate 한다. RN INDEPENDENT_QUERY_CONFIG.

final class MonthlyDiariesProvider
    extends $FunctionalProvider<AsyncValue<List<DailyDiary>>, List<DailyDiary>, FutureOr<List<DailyDiary>>>
    with $FutureModifier<List<DailyDiary>>, $FutureProvider<List<DailyDiary>> {
  /// 특정 월(`YYYY-MM`)의 일기 목록. 본인 액션으로만 변경되므로 cacheFor(standard)로 캐시하고
  /// 생성/수정/삭제 시 invalidate 한다. RN INDEPENDENT_QUERY_CONFIG.
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
  $FutureProviderElement<List<DailyDiary>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DailyDiary>> create(Ref ref) {
    final argument = this.argument as String;
    return monthlyDiaries(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyDiariesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthlyDiariesHash() => r'a81bbc92fbe11886ad0d9093ace62bc71283cabe';

/// 특정 월(`YYYY-MM`)의 일기 목록. 본인 액션으로만 변경되므로 cacheFor(standard)로 캐시하고
/// 생성/수정/삭제 시 invalidate 한다. RN INDEPENDENT_QUERY_CONFIG.

final class MonthlyDiariesFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<DailyDiary>>, String> {
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

  MonthlyDiariesProvider call(String month) => MonthlyDiariesProvider._(argument: month, from: this);

  @override
  String toString() => r'monthlyDiariesProvider';
}
