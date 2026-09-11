// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileTypeHash() => r'123038744ecc5d56d82a1d21b73c6f1263ba7001';

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

/// Provider that returns the profile type for a given profile repository id.
///
/// Copied from [profileType].
@ProviderFor(profileType)
const profileTypeProvider = ProfileTypeFamily();

/// Provider that returns the profile type for a given profile repository id.
///
/// Copied from [profileType].
class ProfileTypeFamily extends Family<ProfileType> {
  /// Provider that returns the profile type for a given profile repository id.
  ///
  /// Copied from [profileType].
  const ProfileTypeFamily();

  /// Provider that returns the profile type for a given profile repository id.
  ///
  /// Copied from [profileType].
  ProfileTypeProvider call(
    String repositoryId,
  ) {
    return ProfileTypeProvider(
      repositoryId,
    );
  }

  @override
  ProfileTypeProvider getProviderOverride(
    covariant ProfileTypeProvider provider,
  ) {
    return call(
      provider.repositoryId,
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
  String? get name => r'profileTypeProvider';
}

/// Provider that returns the profile type for a given profile repository id.
///
/// Copied from [profileType].
class ProfileTypeProvider extends AutoDisposeProvider<ProfileType> {
  /// Provider that returns the profile type for a given profile repository id.
  ///
  /// Copied from [profileType].
  ProfileTypeProvider(
    String repositoryId,
  ) : this._internal(
          (ref) => profileType(
            ref as ProfileTypeRef,
            repositoryId,
          ),
          from: profileTypeProvider,
          name: r'profileTypeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profileTypeHash,
          dependencies: ProfileTypeFamily._dependencies,
          allTransitiveDependencies:
              ProfileTypeFamily._allTransitiveDependencies,
          repositoryId: repositoryId,
        );

  ProfileTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.repositoryId,
  }) : super.internal();

  final String repositoryId;

  @override
  Override overrideWith(
    ProfileType Function(ProfileTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProfileTypeProvider._internal(
        (ref) => create(ref as ProfileTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        repositoryId: repositoryId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<ProfileType> createElement() {
    return _ProfileTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileTypeProvider && other.repositoryId == repositoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, repositoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProfileTypeRef on AutoDisposeProviderRef<ProfileType> {
  /// The parameter `repositoryId` of this provider.
  String get repositoryId;
}

class _ProfileTypeProviderElement
    extends AutoDisposeProviderElement<ProfileType> with ProfileTypeRef {
  _ProfileTypeProviderElement(super.provider);

  @override
  String get repositoryId => (origin as ProfileTypeProvider).repositoryId;
}

String _$profileServiceHash() => r'7643b36291a17c690ce3ceb23962dda6a76384fb';

/// Service responsible for managing profiles within a vault.
///
/// This service provides functionality to:
/// - Retrieve profiles from the vault
/// - Create new profiles with different storage types (VFS/Edge)
/// - Delete profiles and their associated data
/// - Update profile information
///
/// The service supports both cloud-based (VFS) and local (Edge) profile storage.
/// Each profile type has its own repository and storage mechanism.
///
/// Copied from [ProfileService].
@ProviderFor(ProfileService)
final profileServiceProvider =
    AutoDisposeNotifierProvider<ProfileService, ProfileServiceState>.internal(
  ProfileService.new,
  name: r'profileServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileService = AutoDisposeNotifier<ProfileServiceState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
