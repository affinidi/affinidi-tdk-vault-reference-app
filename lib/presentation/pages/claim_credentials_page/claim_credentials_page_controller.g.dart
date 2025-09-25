// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_credentials_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$claimCredentialsPageControllerHash() =>
    r'76b04cf0270640f23025723cff5a4b548e1ec698';

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

abstract class _$ClaimCredentialsPageController
    extends BuildlessAutoDisposeNotifier<ClaimCredentialsPageState> {
  late final String profileId;

  ClaimCredentialsPageState build({
    required String profileId,
  });
}

/// See also [ClaimCredentialsPageController].
@ProviderFor(ClaimCredentialsPageController)
const claimCredentialsPageControllerProvider =
    ClaimCredentialsPageControllerFamily();

/// See also [ClaimCredentialsPageController].
class ClaimCredentialsPageControllerFamily
    extends Family<ClaimCredentialsPageState> {
  /// See also [ClaimCredentialsPageController].
  const ClaimCredentialsPageControllerFamily();

  /// See also [ClaimCredentialsPageController].
  ClaimCredentialsPageControllerProvider call({
    required String profileId,
  }) {
    return ClaimCredentialsPageControllerProvider(
      profileId: profileId,
    );
  }

  @override
  ClaimCredentialsPageControllerProvider getProviderOverride(
    covariant ClaimCredentialsPageControllerProvider provider,
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
  String? get name => r'claimCredentialsPageControllerProvider';
}

/// See also [ClaimCredentialsPageController].
class ClaimCredentialsPageControllerProvider
    extends AutoDisposeNotifierProviderImpl<ClaimCredentialsPageController,
        ClaimCredentialsPageState> {
  /// See also [ClaimCredentialsPageController].
  ClaimCredentialsPageControllerProvider({
    required String profileId,
  }) : this._internal(
          () => ClaimCredentialsPageController()..profileId = profileId,
          from: claimCredentialsPageControllerProvider,
          name: r'claimCredentialsPageControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$claimCredentialsPageControllerHash,
          dependencies: ClaimCredentialsPageControllerFamily._dependencies,
          allTransitiveDependencies:
              ClaimCredentialsPageControllerFamily._allTransitiveDependencies,
          profileId: profileId,
        );

  ClaimCredentialsPageControllerProvider._internal(
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
  ClaimCredentialsPageState runNotifierBuild(
    covariant ClaimCredentialsPageController notifier,
  ) {
    return notifier.build(
      profileId: profileId,
    );
  }

  @override
  Override overrideWith(ClaimCredentialsPageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ClaimCredentialsPageControllerProvider._internal(
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
  AutoDisposeNotifierProviderElement<ClaimCredentialsPageController,
      ClaimCredentialsPageState> createElement() {
    return _ClaimCredentialsPageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClaimCredentialsPageControllerProvider &&
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
mixin ClaimCredentialsPageControllerRef
    on AutoDisposeNotifierProviderRef<ClaimCredentialsPageState> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _ClaimCredentialsPageControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ClaimCredentialsPageController,
        ClaimCredentialsPageState> with ClaimCredentialsPageControllerRef {
  _ClaimCredentialsPageControllerProviderElement(super.provider);

  @override
  String get profileId =>
      (origin as ClaimCredentialsPageControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
