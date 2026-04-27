// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_comparison_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FareComparisonViewModel)
final fareComparisonViewModelProvider = FareComparisonViewModelProvider._();

final class FareComparisonViewModelProvider
    extends $NotifierProvider<FareComparisonViewModel, FareComparisonState> {
  FareComparisonViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fareComparisonViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fareComparisonViewModelHash();

  @$internal
  @override
  FareComparisonViewModel create() => FareComparisonViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FareComparisonState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FareComparisonState>(value),
    );
  }
}

String _$fareComparisonViewModelHash() =>
    r'1276e97bab1c66b780afb44953ec3236df4202dd';

abstract class _$FareComparisonViewModel
    extends $Notifier<FareComparisonState> {
  FareComparisonState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FareComparisonState, FareComparisonState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FareComparisonState, FareComparisonState>,
              FareComparisonState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
