// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_credentials_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedCredentialsPageControllerHash() =>
    r'04e67950cbfe543f4cf809b6fb8ad9c46269edde';

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

abstract class _$SharedCredentialsPageController
    extends BuildlessAutoDisposeNotifier<SharedCredentialsPageState> {
  late final String profileId;

  SharedCredentialsPageState build({
    required String profileId,
  });
}

/// See also [SharedCredentialsPageController].
@ProviderFor(SharedCredentialsPageController)
const sharedCredentialsPageControllerProvider =
    SharedCredentialsPageControllerFamily();

/// See also [SharedCredentialsPageController].
class SharedCredentialsPageControllerFamily
    extends Family<SharedCredentialsPageState> {
  /// See also [SharedCredentialsPageController].
  const SharedCredentialsPageControllerFamily();

  /// See also [SharedCredentialsPageController].
  SharedCredentialsPageControllerProvider call({
    required String profileId,
  }) {
    return SharedCredentialsPageControllerProvider(
      profileId: profileId,
    );
  }

  @override
  SharedCredentialsPageControllerProvider getProviderOverride(
    covariant SharedCredentialsPageControllerProvider provider,
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
  String? get name => r'sharedCredentialsPageControllerProvider';
}

/// See also [SharedCredentialsPageController].
class SharedCredentialsPageControllerProvider
    extends AutoDisposeNotifierProviderImpl<SharedCredentialsPageController,
        SharedCredentialsPageState> {
  /// See also [SharedCredentialsPageController].
  SharedCredentialsPageControllerProvider({
    required String profileId,
  }) : this._internal(
          () => SharedCredentialsPageController()..profileId = profileId,
          from: sharedCredentialsPageControllerProvider,
          name: r'sharedCredentialsPageControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sharedCredentialsPageControllerHash,
          dependencies: SharedCredentialsPageControllerFamily._dependencies,
          allTransitiveDependencies:
              SharedCredentialsPageControllerFamily._allTransitiveDependencies,
          profileId: profileId,
        );

  SharedCredentialsPageControllerProvider._internal(
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
  SharedCredentialsPageState runNotifierBuild(
    covariant SharedCredentialsPageController notifier,
  ) {
    return notifier.build(
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(SharedCredentialsPageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SharedCredentialsPageControllerProvider._internal(
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
  AutoDisposeNotifierProviderElement<SharedCredentialsPageController,
      SharedCredentialsPageState> createElement() {
    return _SharedCredentialsPageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SharedCredentialsPageControllerProvider &&
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
mixin SharedCredentialsPageControllerRef
    on AutoDisposeNotifierProviderRef<SharedCredentialsPageState> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _SharedCredentialsPageControllerProviderElement
    extends AutoDisposeNotifierProviderElement<SharedCredentialsPageController,
        SharedCredentialsPageState> with SharedCredentialsPageControllerRef {
  _SharedCredentialsPageControllerProviderElement(super.provider);

  @override
  String get profileId =>
      (origin as SharedCredentialsPageControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
