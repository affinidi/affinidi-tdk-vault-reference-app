// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileTypeHash() => r'9c55b76ee9b33451a3a64d10122ee02f709eb8f0';

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

/// Provider that returns the profile type for a given profile ID.
///
/// Copied from [profileType].
@ProviderFor(profileType)
const profileTypeProvider = ProfileTypeFamily();

/// Provider that returns the profile type for a given profile ID.
///
/// Copied from [profileType].
class ProfileTypeFamily extends Family<ProfileType> {
  /// Provider that returns the profile type for a given profile ID.
  ///
  /// Copied from [profileType].
  const ProfileTypeFamily();

  /// Provider that returns the profile type for a given profile ID.
  ///
  /// Copied from [profileType].
  ProfileTypeProvider call(
    String profileId,
  ) {
    return ProfileTypeProvider(
      profileId,
    );
  }

  @override
  ProfileTypeProvider getProviderOverride(
    covariant ProfileTypeProvider provider,
  ) {
    return call(
      provider.profileId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies => _allTransitiveDependencies;

  @override
  String? get name => r'profileTypeProvider';
}

/// Provider that returns the profile type for a given profile ID.
///
/// Copied from [profileType].
class ProfileTypeProvider extends AutoDisposeProvider<ProfileType> {
  /// Provider that returns the profile type for a given profile ID.
  ///
  /// Copied from [profileType].
  ProfileTypeProvider(
    String profileId,
  ) : this._internal(
          (ref) => profileType(
            ref as ProfileTypeRef,
            profileId,
          ),
          from: profileTypeProvider,
          name: r'profileTypeProvider',
          debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$profileTypeHash,
          dependencies: ProfileTypeFamily._dependencies,
          allTransitiveDependencies: ProfileTypeFamily._allTransitiveDependencies,
          profileId: profileId,
        );

  ProfileTypeProvider._internal(
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
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<ProfileType> createElement() {
    return _ProfileTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileTypeProvider && other.profileId == profileId;
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
mixin ProfileTypeRef on AutoDisposeProviderRef<ProfileType> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _ProfileTypeProviderElement extends AutoDisposeProviderElement<ProfileType> with ProfileTypeRef {
  _ProfileTypeProviderElement(super.provider);

  @override
  String get profileId => (origin as ProfileTypeProvider).profileId;
}

String _$profileServiceHash() => r'0b37908f5ef500b0424a579db02b525ad9da021f';

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
final profileServiceProvider = AutoDisposeNotifierProvider<ProfileService, ProfileServiceState>.internal(
  ProfileService.new,
  name: r'profileServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$profileServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileService = AutoDisposeNotifier<ProfileServiceState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
