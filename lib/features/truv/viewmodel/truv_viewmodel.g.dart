// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truv_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TruvViewModel)
final truvViewModelProvider = TruvViewModelProvider._();

final class TruvViewModelProvider
    extends $NotifierProvider<TruvViewModel, TruvState> {
  TruvViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'truvViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$truvViewModelHash();

  @$internal
  @override
  TruvViewModel create() => TruvViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TruvState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TruvState>(value),
    );
  }
}

String _$truvViewModelHash() => r'493afdf6655cc5d4e256475f43723ee977a0b748';

abstract class _$TruvViewModel extends $Notifier<TruvState> {
  TruvState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TruvState, TruvState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TruvState, TruvState>,
              TruvState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
