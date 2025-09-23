// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_settings_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedProfileAccessesHash() =>
    r'f44f891b95d6ce563c42e3ab71e689fffa7ede54';

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

/// See also [sharedProfileAccesses].
@ProviderFor(sharedProfileAccesses)
const sharedProfileAccessesProvider = SharedProfileAccessesFamily();

/// See also [sharedProfileAccesses].
class SharedProfileAccessesFamily
    extends Family<AsyncValue<List<SharedProfileAccessData>>> {
  /// See also [sharedProfileAccesses].
  const SharedProfileAccessesFamily();

  /// See also [sharedProfileAccesses].
  SharedProfileAccessesProvider call(
    String profileId,
  ) {
    return SharedProfileAccessesProvider(
      profileId,
    );
  }

  @override
  SharedProfileAccessesProvider getProviderOverride(
    covariant SharedProfileAccessesProvider provider,
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
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sharedProfileAccessesProvider';
}

/// See also [sharedProfileAccesses].
class SharedProfileAccessesProvider
    extends AutoDisposeStreamProvider<List<SharedProfileAccessData>> {
  /// See also [sharedProfileAccesses].
  SharedProfileAccessesProvider(
    String profileId,
  ) : this._internal(
          (ref) => sharedProfileAccesses(
            ref as SharedProfileAccessesRef,
            profileId,
          ),
          from: sharedProfileAccessesProvider,
          name: r'sharedProfileAccessesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sharedProfileAccessesHash,
          dependencies: SharedProfileAccessesFamily._dependencies,
          allTransitiveDependencies:
              SharedProfileAccessesFamily._allTransitiveDependencies,
          profileId: profileId,
        );

  SharedProfileAccessesProvider._internal(
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
    Stream<List<SharedProfileAccessData>> Function(
            SharedProfileAccessesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SharedProfileAccessesProvider._internal(
        (ref) => create(ref as SharedProfileAccessesRef),
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
  AutoDisposeStreamProviderElement<List<SharedProfileAccessData>>
      createElement() {
    return _SharedProfileAccessesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SharedProfileAccessesProvider &&
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
mixin SharedProfileAccessesRef
    on AutoDisposeStreamProviderRef<List<SharedProfileAccessData>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _SharedProfileAccessesProviderElement
    extends AutoDisposeStreamProviderElement<List<SharedProfileAccessData>>
    with SharedProfileAccessesRef {
  _SharedProfileAccessesProviderElement(super.provider);

  @override
  String get profileId => (origin as SharedProfileAccessesProvider).profileId;
}

String _$profileSettingsPageControllerHash() =>
    r'0f790677400017ccbd97dee539bd3489f9dff620';

abstract class _$ProfileSettingsPageController
    extends BuildlessAutoDisposeNotifier<ProfileSettingsPageState> {
  late final String profileId;

  ProfileSettingsPageState build(
    String profileId,
  );
}

/// See also [ProfileSettingsPageController].
@ProviderFor(ProfileSettingsPageController)
const profileSettingsPageControllerProvider =
    ProfileSettingsPageControllerFamily();

/// See also [ProfileSettingsPageController].
class ProfileSettingsPageControllerFamily
    extends Family<ProfileSettingsPageState> {
  /// See also [ProfileSettingsPageController].
  const ProfileSettingsPageControllerFamily();

  /// See also [ProfileSettingsPageController].
  ProfileSettingsPageControllerProvider call(
    String profileId,
  ) {
    return ProfileSettingsPageControllerProvider(
      profileId,
    );
  }

  @override
  ProfileSettingsPageControllerProvider getProviderOverride(
    covariant ProfileSettingsPageControllerProvider provider,
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
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'profileSettingsPageControllerProvider';
}

/// See also [ProfileSettingsPageController].
class ProfileSettingsPageControllerProvider
    extends AutoDisposeNotifierProviderImpl<ProfileSettingsPageController,
        ProfileSettingsPageState> {
  /// See also [ProfileSettingsPageController].
  ProfileSettingsPageControllerProvider(
    String profileId,
  ) : this._internal(
          () => ProfileSettingsPageController()..profileId = profileId,
          from: profileSettingsPageControllerProvider,
          name: r'profileSettingsPageControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profileSettingsPageControllerHash,
          dependencies: ProfileSettingsPageControllerFamily._dependencies,
          allTransitiveDependencies:
              ProfileSettingsPageControllerFamily._allTransitiveDependencies,
          profileId: profileId,
        );

  ProfileSettingsPageControllerProvider._internal(
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
  ProfileSettingsPageState runNotifierBuild(
    covariant ProfileSettingsPageController notifier,
  ) {
    return notifier.build(
      profileId,
    );
  }

  @override
  Override overrideWith(ProfileSettingsPageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProfileSettingsPageControllerProvider._internal(
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
  AutoDisposeNotifierProviderElement<ProfileSettingsPageController,
      ProfileSettingsPageState> createElement() {
    return _ProfileSettingsPageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileSettingsPageControllerProvider &&
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
mixin ProfileSettingsPageControllerRef
    on AutoDisposeNotifierProviderRef<ProfileSettingsPageState> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _ProfileSettingsPageControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ProfileSettingsPageController,
        ProfileSettingsPageState> with ProfileSettingsPageControllerRef {
  _ProfileSettingsPageControllerProviderElement(super.provider);

  @override
  String get profileId =>
      (origin as ProfileSettingsPageControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
