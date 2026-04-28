// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'truv_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(truvRepository)
final truvRepositoryProvider = TruvRepositoryProvider._();

final class TruvRepositoryProvider
    extends $FunctionalProvider<TruvRepository, TruvRepository, TruvRepository>
    with $Provider<TruvRepository> {
  TruvRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'truvRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$truvRepositoryHash();

  @$internal
  @override
  $ProviderElement<TruvRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TruvRepository create(Ref ref) {
    return truvRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TruvRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TruvRepository>(value),
    );
  }
}

String _$truvRepositoryHash() => r'7cf551239b478d7887f0332fef2f79dd15157ee3';
