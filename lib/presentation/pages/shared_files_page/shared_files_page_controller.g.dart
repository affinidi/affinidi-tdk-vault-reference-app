// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_files_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedFilesPageControllerHash() =>
    r'b6d4dab4989e5eff4ec798360845f50024e214fe';

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

abstract class _$SharedFilesPageController
    extends BuildlessAutoDisposeNotifier<SharedFilesPageState> {
  late final String? parentNodeId;
  late final String profileId;

  SharedFilesPageState build({
    required String? parentNodeId,
    required String profileId,
  });
}

/// See also [SharedFilesPageController].
@ProviderFor(SharedFilesPageController)
const sharedFilesPageControllerProvider = SharedFilesPageControllerFamily();

/// See also [SharedFilesPageController].
class SharedFilesPageControllerFamily extends Family<SharedFilesPageState> {
  /// See also [SharedFilesPageController].
  const SharedFilesPageControllerFamily();

  /// See also [SharedFilesPageController].
  SharedFilesPageControllerProvider call({
    required String? parentNodeId,
    required String profileId,
  }) {
    return SharedFilesPageControllerProvider(
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  SharedFilesPageControllerProvider getProviderOverride(
    covariant SharedFilesPageControllerProvider provider,
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
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sharedFilesPageControllerProvider';
}

/// See also [SharedFilesPageController].
class SharedFilesPageControllerProvider extends AutoDisposeNotifierProviderImpl<
    SharedFilesPageController, SharedFilesPageState> {
  /// See also [SharedFilesPageController].
  SharedFilesPageControllerProvider({
    required String? parentNodeId,
    required String profileId,
  }) : this._internal(
          () => SharedFilesPageController()
            ..parentNodeId = parentNodeId
            ..profileId = profileId,
          from: sharedFilesPageControllerProvider,
          name: r'sharedFilesPageControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sharedFilesPageControllerHash,
          dependencies: SharedFilesPageControllerFamily._dependencies,
          allTransitiveDependencies:
              SharedFilesPageControllerFamily._allTransitiveDependencies,
          parentNodeId: parentNodeId,
          profileId: profileId,
        );

  SharedFilesPageControllerProvider._internal(
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
  SharedFilesPageState runNotifierBuild(
    covariant SharedFilesPageController notifier,
  ) {
    return notifier.build(
      parentNodeId: parentNodeId,
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(SharedFilesPageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SharedFilesPageControllerProvider._internal(
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
  AutoDisposeNotifierProviderElement<SharedFilesPageController,
      SharedFilesPageState> createElement() {
    return _SharedFilesPageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SharedFilesPageControllerProvider &&
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
mixin SharedFilesPageControllerRef
    on AutoDisposeNotifierProviderRef<SharedFilesPageState> {
  /// The parameter `parentNodeId` of this provider.
  String? get parentNodeId;

  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _SharedFilesPageControllerProviderElement
    extends AutoDisposeNotifierProviderElement<SharedFilesPageController,
        SharedFilesPageState> with SharedFilesPageControllerRef {
  _SharedFilesPageControllerProviderElement(super.provider);

  @override
  String? get parentNodeId =>
      (origin as SharedFilesPageControllerProvider).parentNodeId;
  @override
  String get profileId =>
      (origin as SharedFilesPageControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
