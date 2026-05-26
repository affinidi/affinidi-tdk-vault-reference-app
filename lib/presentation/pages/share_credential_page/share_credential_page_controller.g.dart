// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_credential_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shareCredentialPageControllerHash() =>
    r'24a839ed31a5a1b0d7dc14ae439c54e04b4fb6f9';

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

abstract class _$ShareCredentialPageController
    extends BuildlessAutoDisposeNotifier<ShareCredentialPageState> {
  late final String requestJwt;
  late final String? clientId;

  ShareCredentialPageState build({
    required String requestJwt,
    String? clientId,
  });
}

/// See also [ShareCredentialPageController].
@ProviderFor(ShareCredentialPageController)
const shareCredentialPageControllerProvider =
    ShareCredentialPageControllerFamily();

/// See also [ShareCredentialPageController].
class ShareCredentialPageControllerFamily
    extends Family<ShareCredentialPageState> {
  /// See also [ShareCredentialPageController].
  const ShareCredentialPageControllerFamily();

  /// See also [ShareCredentialPageController].
  ShareCredentialPageControllerProvider call({
    required String requestJwt,
    String? clientId,
  }) {
    return ShareCredentialPageControllerProvider(
      requestJwt: requestJwt,
      clientId: clientId,
    );
  }

  @override
  ShareCredentialPageControllerProvider getProviderOverride(
    covariant ShareCredentialPageControllerProvider provider,
  ) {
    return call(
      requestJwt: provider.requestJwt,
      clientId: provider.clientId,
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
  String? get name => r'shareCredentialPageControllerProvider';
}

/// See also [ShareCredentialPageController].
class ShareCredentialPageControllerProvider
    extends AutoDisposeNotifierProviderImpl<ShareCredentialPageController,
        ShareCredentialPageState> {
  /// See also [ShareCredentialPageController].
  ShareCredentialPageControllerProvider({
    required String requestJwt,
    String? clientId,
  }) : this._internal(
          () => ShareCredentialPageController()
            ..requestJwt = requestJwt
            ..clientId = clientId,
          from: shareCredentialPageControllerProvider,
          name: r'shareCredentialPageControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$shareCredentialPageControllerHash,
          dependencies: ShareCredentialPageControllerFamily._dependencies,
          allTransitiveDependencies:
              ShareCredentialPageControllerFamily._allTransitiveDependencies,
          requestJwt: requestJwt,
          clientId: clientId,
        );

  ShareCredentialPageControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.requestJwt,
    required this.clientId,
  }) : super.internal();

  final String requestJwt;
  final String? clientId;

  @override
  ShareCredentialPageState runNotifierBuild(
    covariant ShareCredentialPageController notifier,
  ) {
    return notifier.build(
      requestJwt: requestJwt,
      clientId: clientId,
    );
  }

  @override
  Override overrideWith(ShareCredentialPageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ShareCredentialPageControllerProvider._internal(
        () => create()
          ..requestJwt = requestJwt
          ..clientId = clientId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        requestJwt: requestJwt,
        clientId: clientId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ShareCredentialPageController,
      ShareCredentialPageState> createElement() {
    return _ShareCredentialPageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShareCredentialPageControllerProvider &&
        other.requestJwt == requestJwt &&
        other.clientId == clientId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, requestJwt.hashCode);
    hash = _SystemHash.combine(hash, clientId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShareCredentialPageControllerRef
    on AutoDisposeNotifierProviderRef<ShareCredentialPageState> {
  /// The parameter `requestJwt` of this provider.
  String get requestJwt;

  /// The parameter `clientId` of this provider.
  String? get clientId;
}

class _ShareCredentialPageControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ShareCredentialPageController,
        ShareCredentialPageState> with ShareCredentialPageControllerRef {
  _ShareCredentialPageControllerProviderElement(super.provider);

  @override
  String get requestJwt =>
      (origin as ShareCredentialPageControllerProvider).requestJwt;
  @override
  String? get clientId =>
      (origin as ShareCredentialPageControllerProvider).clientId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
