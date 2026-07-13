// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iota_consent_record_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$consentStorageHash() => r'f35ffd738bae99ccf7ba310b6daee59951b24203';

/// Application-wide [ConsentStorage] backed by Flutter secure storage.
///
/// Held as a singleton so that every consent-record service writes to the
/// same backing keychain namespace.
///
/// Copied from [consentStorage].
@ProviderFor(consentStorage)
final consentStorageProvider = Provider<ConsentStorage>.internal(
  consentStorage,
  name: r'consentStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$consentStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConsentStorageRef = ProviderRef<ConsentStorage>;
String _$iotaConsentRecordServiceHash() =>
    r'7fed88f324d201e76452a8d807ba291b7f2818bb';

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
