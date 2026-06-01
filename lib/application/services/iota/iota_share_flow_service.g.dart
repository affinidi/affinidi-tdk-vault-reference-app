// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iota_share_flow_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$iotaShareFlowServiceHash() =>
    r'273ff0f6b355b8367582d4e28e217b6def033e2b';

/// See also [iotaShareFlowService].
@ProviderFor(iotaShareFlowService)
final iotaShareFlowServiceProvider =
    AutoDisposeProvider<ShareFlowServiceInterface>.internal(
  iotaShareFlowService,
  name: r'iotaShareFlowServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$iotaShareFlowServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IotaShareFlowServiceRef
    = AutoDisposeProviderRef<ShareFlowServiceInterface>;
String _$iotaPdClassifierHash() => r'431dbd9cf5b1bddee64a0f5c991d9c96fdd447db';

/// See also [iotaPdClassifier].
@ProviderFor(iotaPdClassifier)
final iotaPdClassifierProvider = AutoDisposeProvider<PDClassifier>.internal(
  iotaPdClassifier,
  name: r'iotaPdClassifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$iotaPdClassifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IotaPdClassifierRef = AutoDisposeProviderRef<PDClassifier>;
String _$iotaShareRequirementsMatcherHash() =>
    r'0c852a6adcb138ff5d7102937c836e28ef3740fd';

/// See also [iotaShareRequirementsMatcher].
@ProviderFor(iotaShareRequirementsMatcher)
final iotaShareRequirementsMatcherProvider =
    AutoDisposeProvider<ShareRequirementsMatcher>.internal(
  iotaShareRequirementsMatcher,
  name: r'iotaShareRequirementsMatcherProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$iotaShareRequirementsMatcherHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IotaShareRequirementsMatcherRef
    = AutoDisposeProviderRef<ShareRequirementsMatcher>;
String _$iotaVerifierMetadataServiceHash() =>
    r'a2d13e66ea735d434220be8d9f0d609c13f7cc7a';

/// See also [iotaVerifierMetadataService].
@ProviderFor(iotaVerifierMetadataService)
final iotaVerifierMetadataServiceProvider =
    AutoDisposeProvider<VerifierMetadataService>.internal(
  iotaVerifierMetadataService,
  name: r'iotaVerifierMetadataServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$iotaVerifierMetadataServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IotaVerifierMetadataServiceRef
    = AutoDisposeProviderRef<VerifierMetadataService>;
String _$iotaShareResponseServiceHash() =>
    r'0dd2f45d45672b48a36b1f04c68a3caa4fd9e5b2';

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

/// See also [iotaShareResponseService].
@ProviderFor(iotaShareResponseService)
const iotaShareResponseServiceProvider = IotaShareResponseServiceFamily();

/// See also [iotaShareResponseService].
class IotaShareResponseServiceFamily
    extends Family<IotaShareResponseServiceInterface> {
  /// See also [iotaShareResponseService].
  const IotaShareResponseServiceFamily();

  /// See also [iotaShareResponseService].
  IotaShareResponseServiceProvider call({
    required String vaultId,
    required int accountIndex,
  }) {
    return IotaShareResponseServiceProvider(
      vaultId: vaultId,
      accountIndex: accountIndex,
    );
  }

  @override
  IotaShareResponseServiceProvider getProviderOverride(
    covariant IotaShareResponseServiceProvider provider,
  ) {
    return call(
      vaultId: provider.vaultId,
      accountIndex: provider.accountIndex,
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
  String? get name => r'iotaShareResponseServiceProvider';
}

/// See also [iotaShareResponseService].
class IotaShareResponseServiceProvider
    extends AutoDisposeProvider<IotaShareResponseServiceInterface> {
  /// See also [iotaShareResponseService].
  IotaShareResponseServiceProvider({
    required String vaultId,
    required int accountIndex,
  }) : this._internal(
          (ref) => iotaShareResponseService(
            ref as IotaShareResponseServiceRef,
            vaultId: vaultId,
            accountIndex: accountIndex,
          ),
          from: iotaShareResponseServiceProvider,
          name: r'iotaShareResponseServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$iotaShareResponseServiceHash,
          dependencies: IotaShareResponseServiceFamily._dependencies,
          allTransitiveDependencies:
              IotaShareResponseServiceFamily._allTransitiveDependencies,
          vaultId: vaultId,
          accountIndex: accountIndex,
        );

  IotaShareResponseServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vaultId,
    required this.accountIndex,
  }) : super.internal();

  final String vaultId;
  final int accountIndex;

  @override
  Override overrideWith(
    IotaShareResponseServiceInterface Function(
            IotaShareResponseServiceRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IotaShareResponseServiceProvider._internal(
        (ref) => create(ref as IotaShareResponseServiceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vaultId: vaultId,
        accountIndex: accountIndex,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<IotaShareResponseServiceInterface>
      createElement() {
    return _IotaShareResponseServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IotaShareResponseServiceProvider &&
        other.vaultId == vaultId &&
        other.accountIndex == accountIndex;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vaultId.hashCode);
    hash = _SystemHash.combine(hash, accountIndex.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IotaShareResponseServiceRef
    on AutoDisposeProviderRef<IotaShareResponseServiceInterface> {
  /// The parameter `vaultId` of this provider.
  String get vaultId;

  /// The parameter `accountIndex` of this provider.
  int get accountIndex;
}

class _IotaShareResponseServiceProviderElement
    extends AutoDisposeProviderElement<IotaShareResponseServiceInterface>
    with IotaShareResponseServiceRef {
  _IotaShareResponseServiceProviderElement(super.provider);

  @override
  String get vaultId => (origin as IotaShareResponseServiceProvider).vaultId;
  @override
  int get accountIndex =>
      (origin as IotaShareResponseServiceProvider).accountIndex;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
