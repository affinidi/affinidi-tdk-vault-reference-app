// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profilePageControllerHash() =>
    r'72af115ad0d5d3bb356c6ab3be68de9032a209b7';

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

abstract class _$ProfilePageController
    extends BuildlessAutoDisposeNotifier<ProfilePageState> {
  late final String profileId;

  ProfilePageState build({
    required String profileId,
  });
}

/// See also [ProfilePageController].
@ProviderFor(ProfilePageController)
const profilePageControllerProvider = ProfilePageControllerFamily();

/// See also [ProfilePageController].
class ProfilePageControllerFamily extends Family<ProfilePageState> {
  /// See also [ProfilePageController].
  const ProfilePageControllerFamily();

  /// See also [ProfilePageController].
  ProfilePageControllerProvider call({
    required String profileId,
  }) {
    return ProfilePageControllerProvider(
      profileId: profileId,
    );
  }

  @override
  ProfilePageControllerProvider getProviderOverride(
    covariant ProfilePageControllerProvider provider,
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
  String? get name => r'profilePageControllerProvider';
}

/// See also [ProfilePageController].
class ProfilePageControllerProvider extends AutoDisposeNotifierProviderImpl<
    ProfilePageController, ProfilePageState> {
  /// See also [ProfilePageController].
  ProfilePageControllerProvider({
    required String profileId,
  }) : this._internal(
          () => ProfilePageController()..profileId = profileId,
          from: profilePageControllerProvider,
          name: r'profilePageControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profilePageControllerHash,
          dependencies: ProfilePageControllerFamily._dependencies,
          allTransitiveDependencies:
              ProfilePageControllerFamily._allTransitiveDependencies,
          profileId: profileId,
        );

  ProfilePageControllerProvider._internal(
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
  ProfilePageState runNotifierBuild(
    covariant ProfilePageController notifier,
  ) {
    return notifier.build(
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(ProfilePageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProfilePageControllerProvider._internal(
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
  AutoDisposeNotifierProviderElement<ProfilePageController, ProfilePageState>
      createElement() {
    return _ProfilePageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfilePageControllerProvider &&
        other.profileId == profileId;
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
mixin ProfilePageControllerRef
    on AutoDisposeNotifierProviderRef<ProfilePageState> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _ProfilePageControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ProfilePageController,
        ProfilePageState> with ProfilePageControllerRef {
  _ProfilePageControllerProviderElement(super.provider);

  @override
  String get profileId => (origin as ProfilePageControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
