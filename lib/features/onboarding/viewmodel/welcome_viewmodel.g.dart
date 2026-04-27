// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'welcome_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WelcomeViewModel)
final welcomeViewModelProvider = WelcomeViewModelProvider._();

final class WelcomeViewModelProvider
    extends $NotifierProvider<WelcomeViewModel, void> {
  WelcomeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'welcomeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$welcomeViewModelHash();

  @$internal
  @override
  WelcomeViewModel create() => WelcomeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$welcomeViewModelHash() => r'379be98cb232bb7f9cdb5d6e86c43175713a84d6';

abstract class _$WelcomeViewModel extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
