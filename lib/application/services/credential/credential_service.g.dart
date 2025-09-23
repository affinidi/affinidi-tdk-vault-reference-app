// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$credentialServiceHash() => r'd7e57a9a210bf411be7d45eb783168d6c0baf5bd';

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

abstract class _$CredentialService
    extends BuildlessAutoDisposeNotifier<CredentialServiceState> {
  late final String profileId;

  CredentialServiceState build({
    required String profileId,
  });
}

/// A service that manages claimed digital credentials (e.g. fetch, save, delete)
/// for a specific profile stored inside a Vault.
///
/// Copied from [CredentialService].
@ProviderFor(CredentialService)
const credentialServiceProvider = CredentialServiceFamily();

/// A service that manages claimed digital credentials (e.g. fetch, save, delete)
/// for a specific profile stored inside a Vault.
///
/// Copied from [CredentialService].
class CredentialServiceFamily extends Family<CredentialServiceState> {
  /// A service that manages claimed digital credentials (e.g. fetch, save, delete)
  /// for a specific profile stored inside a Vault.
  ///
  /// Copied from [CredentialService].
  const CredentialServiceFamily();

  /// A service that manages claimed digital credentials (e.g. fetch, save, delete)
  /// for a specific profile stored inside a Vault.
  ///
  /// Copied from [CredentialService].
  CredentialServiceProvider call({
    required String profileId,
  }) {
    return CredentialServiceProvider(
      profileId: profileId,
    );
  }

  @override
  CredentialServiceProvider getProviderOverride(
    covariant CredentialServiceProvider provider,
  ) {
    return call(
      profileId: provider.profileId,
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
  String? get name => r'credentialServiceProvider';
}

/// A service that manages claimed digital credentials (e.g. fetch, save, delete)
/// for a specific profile stored inside a Vault.
///
/// Copied from [CredentialService].
class CredentialServiceProvider extends AutoDisposeNotifierProviderImpl<
    CredentialService, CredentialServiceState> {
  /// A service that manages claimed digital credentials (e.g. fetch, save, delete)
  /// for a specific profile stored inside a Vault.
  ///
  /// Copied from [CredentialService].
  CredentialServiceProvider({
    required String profileId,
  }) : this._internal(
          () => CredentialService()..profileId = profileId,
          from: credentialServiceProvider,
          name: r'credentialServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$credentialServiceHash,
          dependencies: CredentialServiceFamily._dependencies,
          allTransitiveDependencies:
              CredentialServiceFamily._allTransitiveDependencies,
          profileId: profileId,
        );

  CredentialServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileId,
  }) : super.internal();

  final String profileId;

  @override
  CredentialServiceState runNotifierBuild(
    covariant CredentialService notifier,
  ) {
    return notifier.build(
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(CredentialService Function() create) {
    return ProviderOverride(
      origin: this,
      override: CredentialServiceProvider._internal(
        () => create()..profileId = profileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<CredentialService, CredentialServiceState>
      createElement() {
    return _CredentialServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CredentialServiceProvider && other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CredentialServiceRef
    on AutoDisposeNotifierProviderRef<CredentialServiceState> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _CredentialServiceProviderElement
    extends AutoDisposeNotifierProviderElement<CredentialService,
        CredentialServiceState> with CredentialServiceRef {
  _CredentialServiceProviderElement(super.provider);

  @override
  String get profileId => (origin as CredentialServiceProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
