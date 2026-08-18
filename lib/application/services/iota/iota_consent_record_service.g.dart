// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iota_consent_record_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$consentStorageHash() => r'2162d385ea2be693624346b4c5f00bf04b4b7d2f';

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

/// Per-vault [ConsentStorage] backed by Flutter secure storage.
///
/// Namespaced by [vaultId] so each vault keeps its own consent history and a
/// backup captures only that vault's records.
///
/// Copied from [consentStorage].
@ProviderFor(consentStorage)
const consentStorageProvider = ConsentStorageFamily();

/// Per-vault [ConsentStorage] backed by Flutter secure storage.
///
/// Namespaced by [vaultId] so each vault keeps its own consent history and a
/// backup captures only that vault's records.
///
/// Copied from [consentStorage].
class ConsentStorageFamily extends Family<ConsentStorage> {
  /// Per-vault [ConsentStorage] backed by Flutter secure storage.
  ///
  /// Namespaced by [vaultId] so each vault keeps its own consent history and a
  /// backup captures only that vault's records.
  ///
  /// Copied from [consentStorage].
  const ConsentStorageFamily();

  /// Per-vault [ConsentStorage] backed by Flutter secure storage.
  ///
  /// Namespaced by [vaultId] so each vault keeps its own consent history and a
  /// backup captures only that vault's records.
  ///
  /// Copied from [consentStorage].
  ConsentStorageProvider call({
    required String vaultId,
  }) {
    return ConsentStorageProvider(
      vaultId: vaultId,
    );
  }

  @override
  ConsentStorageProvider getProviderOverride(
    covariant ConsentStorageProvider provider,
  ) {
    return call(
      vaultId: provider.vaultId,
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
  String? get name => r'consentStorageProvider';
}

/// Per-vault [ConsentStorage] backed by Flutter secure storage.
///
/// Namespaced by [vaultId] so each vault keeps its own consent history and a
/// backup captures only that vault's records.
///
/// Copied from [consentStorage].
class ConsentStorageProvider extends Provider<ConsentStorage> {
  /// Per-vault [ConsentStorage] backed by Flutter secure storage.
  ///
  /// Namespaced by [vaultId] so each vault keeps its own consent history and a
  /// backup captures only that vault's records.
  ///
  /// Copied from [consentStorage].
  ConsentStorageProvider({
    required String vaultId,
  }) : this._internal(
          (ref) => consentStorage(
            ref as ConsentStorageRef,
            vaultId: vaultId,
          ),
          from: consentStorageProvider,
          name: r'consentStorageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$consentStorageHash,
          dependencies: ConsentStorageFamily._dependencies,
          allTransitiveDependencies:
              ConsentStorageFamily._allTransitiveDependencies,
          vaultId: vaultId,
        );

  ConsentStorageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vaultId,
  }) : super.internal();

  final String vaultId;

  @override
  Override overrideWith(
    ConsentStorage Function(ConsentStorageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConsentStorageProvider._internal(
        (ref) => create(ref as ConsentStorageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vaultId: vaultId,
      ),
    );
  }

  @override
  ProviderElement<ConsentStorage> createElement() {
    return _ConsentStorageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConsentStorageProvider && other.vaultId == vaultId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vaultId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConsentStorageRef on ProviderRef<ConsentStorage> {
  /// The parameter `vaultId` of this provider.
  String get vaultId;
}

class _ConsentStorageProviderElement extends ProviderElement<ConsentStorage>
    with ConsentStorageRef {
  _ConsentStorageProviderElement(super.provider);

  @override
  String get vaultId => (origin as ConsentStorageProvider).vaultId;
}

String _$iotaConsentRecordServiceHash() =>
    r'dd45d905e1a59cd0fa07473f22e91f89df7ce3b0';

/// Per-vault [IotaConsentRecordService] used to persist a consent record
/// after a successful share submission.
///
/// Parameters:
/// * [vaultId] - Identifier of the vault whose profile signed the VP.
/// * [accountIndex] - Index of the profile account within the vault. Required
///   to construct the underlying response service used by the consent-record
///   service for the (out-of-scope here) automatic-consent flow.
///
/// Copied from [iotaConsentRecordService].
@ProviderFor(iotaConsentRecordService)
const iotaConsentRecordServiceProvider = IotaConsentRecordServiceFamily();

/// Per-vault [IotaConsentRecordService] used to persist a consent record
/// after a successful share submission.
///
/// Parameters:
/// * [vaultId] - Identifier of the vault whose profile signed the VP.
/// * [accountIndex] - Index of the profile account within the vault. Required
///   to construct the underlying response service used by the consent-record
///   service for the (out-of-scope here) automatic-consent flow.
///
/// Copied from [iotaConsentRecordService].
class IotaConsentRecordServiceFamily
    extends Family<IotaConsentRecordServiceInterface> {
  /// Per-vault [IotaConsentRecordService] used to persist a consent record
  /// after a successful share submission.
  ///
  /// Parameters:
  /// * [vaultId] - Identifier of the vault whose profile signed the VP.
  /// * [accountIndex] - Index of the profile account within the vault. Required
  ///   to construct the underlying response service used by the consent-record
  ///   service for the (out-of-scope here) automatic-consent flow.
  ///
  /// Copied from [iotaConsentRecordService].
  const IotaConsentRecordServiceFamily();

  /// Per-vault [IotaConsentRecordService] used to persist a consent record
  /// after a successful share submission.
  ///
  /// Parameters:
  /// * [vaultId] - Identifier of the vault whose profile signed the VP.
  /// * [accountIndex] - Index of the profile account within the vault. Required
  ///   to construct the underlying response service used by the consent-record
  ///   service for the (out-of-scope here) automatic-consent flow.
  ///
  /// Copied from [iotaConsentRecordService].
  IotaConsentRecordServiceProvider call({
    required String vaultId,
    required int accountIndex,
  }) {
    return IotaConsentRecordServiceProvider(
      vaultId: vaultId,
      accountIndex: accountIndex,
    );
  }

  @override
  IotaConsentRecordServiceProvider getProviderOverride(
    covariant IotaConsentRecordServiceProvider provider,
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
  String? get name => r'iotaConsentRecordServiceProvider';
}

/// Per-vault [IotaConsentRecordService] used to persist a consent record
/// after a successful share submission.
///
/// Parameters:
/// * [vaultId] - Identifier of the vault whose profile signed the VP.
/// * [accountIndex] - Index of the profile account within the vault. Required
///   to construct the underlying response service used by the consent-record
///   service for the (out-of-scope here) automatic-consent flow.
///
/// Copied from [iotaConsentRecordService].
class IotaConsentRecordServiceProvider
    extends AutoDisposeProvider<IotaConsentRecordServiceInterface> {
  /// Per-vault [IotaConsentRecordService] used to persist a consent record
  /// after a successful share submission.
  ///
  /// Parameters:
  /// * [vaultId] - Identifier of the vault whose profile signed the VP.
  /// * [accountIndex] - Index of the profile account within the vault. Required
  ///   to construct the underlying response service used by the consent-record
  ///   service for the (out-of-scope here) automatic-consent flow.
  ///
  /// Copied from [iotaConsentRecordService].
  IotaConsentRecordServiceProvider({
    required String vaultId,
    required int accountIndex,
  }) : this._internal(
          (ref) => iotaConsentRecordService(
            ref as IotaConsentRecordServiceRef,
            vaultId: vaultId,
            accountIndex: accountIndex,
          ),
          from: iotaConsentRecordServiceProvider,
          name: r'iotaConsentRecordServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$iotaConsentRecordServiceHash,
          dependencies: IotaConsentRecordServiceFamily._dependencies,
          allTransitiveDependencies:
              IotaConsentRecordServiceFamily._allTransitiveDependencies,
          vaultId: vaultId,
          accountIndex: accountIndex,
        );

  IotaConsentRecordServiceProvider._internal(
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
    IotaConsentRecordServiceInterface Function(
            IotaConsentRecordServiceRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IotaConsentRecordServiceProvider._internal(
        (ref) => create(ref as IotaConsentRecordServiceRef),
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
  AutoDisposeProviderElement<IotaConsentRecordServiceInterface>
      createElement() {
    return _IotaConsentRecordServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IotaConsentRecordServiceProvider &&
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
mixin IotaConsentRecordServiceRef
    on AutoDisposeProviderRef<IotaConsentRecordServiceInterface> {
  /// The parameter `vaultId` of this provider.
  String get vaultId;

  /// The parameter `accountIndex` of this provider.
  int get accountIndex;
}

class _IotaConsentRecordServiceProviderElement
    extends AutoDisposeProviderElement<IotaConsentRecordServiceInterface>
    with IotaConsentRecordServiceRef {
  _IotaConsentRecordServiceProviderElement(super.provider);

  @override
  String get vaultId => (origin as IotaConsentRecordServiceProvider).vaultId;
  @override
  int get accountIndex =>
      (origin as IotaConsentRecordServiceProvider).accountIndex;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
