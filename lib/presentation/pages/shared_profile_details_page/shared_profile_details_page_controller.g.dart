// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_profile_details_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedProfileDetailsPageControllerHash() => r'1af9f65dba3c56a6024f6337ae8fa128975152f1';

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

abstract class _$SharedProfileDetailsPageController
    extends BuildlessAutoDisposeNotifier<SharedProfileDetailsPageState> {
  late final String? parentNodeId;
  late final String profileId;

  SharedProfileDetailsPageState build({
    required String? parentNodeId,
    required String profileId,
  });
}

/// See also [SharedProfileDetailsPageController].
@ProviderFor(SharedProfileDetailsPageController)
const sharedProfileDetailsPageControllerProvider = SharedProfileDetailsPageControllerFamily();

/// See also [SharedProfileDetailsPageController].
class SharedProfileDetailsPageControllerFamily extends Family<SharedProfileDetailsPageState> {
  /// See also [SharedProfileDetailsPageController].
  const SharedProfileDetailsPageControllerFamily();

  /// See also [SharedProfileDetailsPageController].
  SharedProfileDetailsPageControllerProvider call({
    required String? parentNodeId,
    required String profileId,
  }) {
    return SharedProfileDetailsPageControllerProvider(
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  SharedProfileDetailsPageControllerProvider getProviderOverride(
    covariant SharedProfileDetailsPageControllerProvider provider,
  ) {
    return call(
      parentNodeId: provider.parentNodeId,
      profileId: provider.profileId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies => _allTransitiveDependencies;

  @override
  String? get name => r'sharedProfileDetailsPageControllerProvider';
}

/// See also [SharedProfileDetailsPageController].
class SharedProfileDetailsPageControllerProvider
    extends AutoDisposeNotifierProviderImpl<SharedProfileDetailsPageController, SharedProfileDetailsPageState> {
  /// See also [SharedProfileDetailsPageController].
  SharedProfileDetailsPageControllerProvider({
    required String? parentNodeId,
    required String profileId,
  }) : this._internal(
          () => SharedProfileDetailsPageController()
            ..parentNodeId = parentNodeId
            ..profileId = profileId,
          from: sharedProfileDetailsPageControllerProvider,
          name: r'sharedProfileDetailsPageControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$sharedProfileDetailsPageControllerHash,
          dependencies: SharedProfileDetailsPageControllerFamily._dependencies,
          allTransitiveDependencies: SharedProfileDetailsPageControllerFamily._allTransitiveDependencies,
          parentNodeId: parentNodeId,
          profileId: profileId,
        );

  SharedProfileDetailsPageControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parentNodeId,
    required this.profileId,
  }) : super.internal();

  final String? parentNodeId;
  final String profileId;

  @override
  SharedProfileDetailsPageState runNotifierBuild(
    covariant SharedProfileDetailsPageController notifier,
  ) {
    return notifier.build(
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(SharedProfileDetailsPageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SharedProfileDetailsPageControllerProvider._internal(
        () => create()
          ..parentNodeId = parentNodeId
          ..profileId = profileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parentNodeId: parentNodeId,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SharedProfileDetailsPageController, SharedProfileDetailsPageState>
      createElement() {
    return _SharedProfileDetailsPageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SharedProfileDetailsPageControllerProvider &&
        other.parentNodeId == parentNodeId &&
        other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parentNodeId.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SharedProfileDetailsPageControllerRef on AutoDisposeNotifierProviderRef<SharedProfileDetailsPageState> {
  /// The parameter `parentNodeId` of this provider.
  String? get parentNodeId;

  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _SharedProfileDetailsPageControllerProviderElement
    extends AutoDisposeNotifierProviderElement<SharedProfileDetailsPageController, SharedProfileDetailsPageState>
    with SharedProfileDetailsPageControllerRef {
  _SharedProfileDetailsPageControllerProviderElement(super.provider);

  @override
  String? get parentNodeId => (origin as SharedProfileDetailsPageControllerProvider).parentNodeId;
  @override
  String get profileId => (origin as SharedProfileDetailsPageControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
