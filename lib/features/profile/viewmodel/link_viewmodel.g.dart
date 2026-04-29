// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LinkViewModel)
final linkViewModelProvider = LinkViewModelProvider._();

final class LinkViewModelProvider
    extends $NotifierProvider<LinkViewModel, LinkState> {
  LinkViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkViewModelHash();

  @$internal
  @override
  LinkViewModel create() => LinkViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LinkState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LinkState>(value),
    );
  }
}

String _$linkViewModelHash() => r'4b5a63a61b952733792bf2aa6dd3b96a6159f7eb';

abstract class _$LinkViewModel extends $Notifier<LinkState> {
  LinkState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LinkState, LinkState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LinkState, LinkState>,
              LinkState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
