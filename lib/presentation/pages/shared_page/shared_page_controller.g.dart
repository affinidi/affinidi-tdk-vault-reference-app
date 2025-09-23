// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPageControllerHash() => r'9629b5c068dc080b104c37e9645dfd7d74574174';

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

abstract class _$SharedPageController extends BuildlessAutoDisposeNotifier<SharedPageState> {
  late final String profileId;

  SharedPageState build({
    required String profileId,
  });
}

/// See also [SharedPageController].
@ProviderFor(SharedPageController)
const sharedPageControllerProvider = SharedPageControllerFamily();

/// See also [SharedPageController].
class SharedPageControllerFamily extends Family<SharedPageState> {
  /// See also [SharedPageController].
  const SharedPageControllerFamily();

  /// See also [SharedPageController].
  SharedPageControllerProvider call({
    required String profileId,
  }) {
    return SharedPageControllerProvider(
      profileId: profileId,
    );
  }

  @override
  SharedPageControllerProvider getProviderOverride(
    covariant SharedPageControllerProvider provider,
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
  Iterable<ProviderOrFamily>? get allTransitiveDependencies => _allTransitiveDependencies;

  @override
  String? get name => r'sharedPageControllerProvider';
}

/// See also [SharedPageController].
class SharedPageControllerProvider extends AutoDisposeNotifierProviderImpl<SharedPageController, SharedPageState> {
  /// See also [SharedPageController].
  SharedPageControllerProvider({
    required String profileId,
  }) : this._internal(
          () => SharedPageController()..profileId = profileId,
          from: sharedPageControllerProvider,
          name: r'sharedPageControllerProvider',
          debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$sharedPageControllerHash,
          dependencies: SharedPageControllerFamily._dependencies,
          allTransitiveDependencies: SharedPageControllerFamily._allTransitiveDependencies,
          profileId: profileId,
        );

  SharedPageControllerProvider._internal(
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
  SharedPageState runNotifierBuild(
    covariant SharedPageController notifier,
  ) {
    return notifier.build(
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(SharedPageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SharedPageControllerProvider._internal(
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
  AutoDisposeNotifierProviderElement<SharedPageController, SharedPageState> createElement() {
    return _SharedPageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SharedPageControllerProvider && other.profileId == profileId;
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
mixin SharedPageControllerRef on AutoDisposeNotifierProviderRef<SharedPageState> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _SharedPageControllerProviderElement
    extends AutoDisposeNotifierProviderElement<SharedPageController, SharedPageState> with SharedPageControllerRef {
  _SharedPageControllerProviderElement(super.provider);

  @override
  String get profileId => (origin as SharedPageControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
