// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paywall_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PaywallViewModel)
final paywallViewModelProvider = PaywallViewModelProvider._();

final class PaywallViewModelProvider
    extends $NotifierProvider<PaywallViewModel, PaywallState> {
  PaywallViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paywallViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paywallViewModelHash();

  @$internal
  @override
  PaywallViewModel create() => PaywallViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaywallState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaywallState>(value),
    );
  }
}

String _$paywallViewModelHash() => r'614bfd6e2fe2fb78d59b095f81304e6d75083f13';

abstract class _$PaywallViewModel extends $Notifier<PaywallState> {
  PaywallState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PaywallState, PaywallState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PaywallState, PaywallState>,
              PaywallState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
