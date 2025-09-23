// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_credential_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$claimCredentialRepositoryHash() =>
    r'91ca05e43cc728fe745636f105fbfcf962f90e77';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [claimCredentialRepository].
@ProviderFor(claimCredentialRepository)
const claimCredentialRepositoryProvider = ClaimCredentialRepositoryFamily();

/// See also [claimCredentialRepository].
class ClaimCredentialRepositoryFamily
    extends Family<AsyncValue<ClaimCredentialRepository>> {
  /// See also [claimCredentialRepository].
  const ClaimCredentialRepositoryFamily();

  /// See also [claimCredentialRepository].
  ClaimCredentialRepositoryProvider call(
    String vaultId,
    int accountIndex,
  ) {
    return ClaimCredentialRepositoryProvider(
      vaultId,
      accountIndex,
    );
  }

  @override
  ClaimCredentialRepositoryProvider getProviderOverride(
    covariant ClaimCredentialRepositoryProvider provider,
  ) {
    return call(
      provider.vaultId,
      provider.accountIndex,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'claimCredentialRepositoryProvider';
}

/// See also [claimCredentialRepository].
class ClaimCredentialRepositoryProvider
    extends AutoDisposeFutureProvider<ClaimCredentialRepository> {
  /// See also [claimCredentialRepository].
  ClaimCredentialRepositoryProvider(
    String vaultId,
    int accountIndex,
  ) : this._internal(
          (ref) => claimCredentialRepository(
            ref as ClaimCredentialRepositoryRef,
            vaultId,
            accountIndex,
          ),
          from: claimCredentialRepositoryProvider,
          name: r'claimCredentialRepositoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$claimCredentialRepositoryHash,
          dependencies: ClaimCredentialRepositoryFamily._dependencies,
          allTransitiveDependencies:
              ClaimCredentialRepositoryFamily._allTransitiveDependencies,
          vaultId: vaultId,
          accountIndex: accountIndex,
        );

  ClaimCredentialRepositoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vaultId,
    required this.accountIndex,
  }) : super.internal();

  final String vaultId;
  final int accountIndex;

  @override
  Override overrideWith(
    FutureOr<ClaimCredentialRepository> Function(
            ClaimCredentialRepositoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ClaimCredentialRepositoryProvider._internal(
        (ref) => create(ref as ClaimCredentialRepositoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vaultId: vaultId,
        accountIndex: accountIndex,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ClaimCredentialRepository> createElement() {
    return _ClaimCredentialRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClaimCredentialRepositoryProvider &&
        other.vaultId == vaultId &&
        other.accountIndex == accountIndex;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vaultId.hashCode);
    hash = _SystemHash.combine(hash, accountIndex.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ClaimCredentialRepositoryRef
    on AutoDisposeFutureProviderRef<ClaimCredentialRepository> {
  /// The parameter `vaultId` of this provider.
  String get vaultId;

  /// The parameter `accountIndex` of this provider.
  int get accountIndex;
}

class _ClaimCredentialRepositoryProviderElement
    extends AutoDisposeFutureProviderElement<ClaimCredentialRepository>
    with ClaimCredentialRepositoryRef {
  _ClaimCredentialRepositoryProviderElement(super.provider);

  @override
  String get vaultId => (origin as ClaimCredentialRepositoryProvider).vaultId;
  @override
  int get accountIndex =>
      (origin as ClaimCredentialRepositoryProvider).accountIndex;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
