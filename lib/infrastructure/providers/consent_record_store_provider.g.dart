// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_record_store_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$consentRecordStoreHash() =>
    r'1304c381fcd9eef1136e7c4477082c7db28d55cf';

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

/// Provides a per-vault [FlutterSecureConsentStorage] backed by Flutter
/// secure storage.
///
/// Keeps alive for the lifetime of the app — consent records are written
/// after every successful share and must not be discarded on dispose.
///
/// Namespaced by [vaultId] so each vault reads and writes only its own records.
/// Returns the concrete type so callers can use extended API (e.g. [listAll]).
///
/// Copied from [consentRecordStore].
@ProviderFor(consentRecordStore)
const consentRecordStoreProvider = ConsentRecordStoreFamily();

/// Provides a per-vault [FlutterSecureConsentStorage] backed by Flutter
/// secure storage.
///
/// Keeps alive for the lifetime of the app — consent records are written
/// after every successful share and must not be discarded on dispose.
///
/// Namespaced by [vaultId] so each vault reads and writes only its own records.
/// Returns the concrete type so callers can use extended API (e.g. [listAll]).
///
/// Copied from [consentRecordStore].
class ConsentRecordStoreFamily extends Family<FlutterSecureConsentStorage> {
  /// Provides a per-vault [FlutterSecureConsentStorage] backed by Flutter
  /// secure storage.
  ///
  /// Keeps alive for the lifetime of the app — consent records are written
  /// after every successful share and must not be discarded on dispose.
  ///
  /// Namespaced by [vaultId] so each vault reads and writes only its own records.
  /// Returns the concrete type so callers can use extended API (e.g. [listAll]).
  ///
  /// Copied from [consentRecordStore].
  const ConsentRecordStoreFamily();

  /// Provides a per-vault [FlutterSecureConsentStorage] backed by Flutter
  /// secure storage.
  ///
  /// Keeps alive for the lifetime of the app — consent records are written
  /// after every successful share and must not be discarded on dispose.
  ///
  /// Namespaced by [vaultId] so each vault reads and writes only its own records.
  /// Returns the concrete type so callers can use extended API (e.g. [listAll]).
  ///
  /// Copied from [consentRecordStore].
  ConsentRecordStoreProvider call({
    required String vaultId,
  }) {
    return ConsentRecordStoreProvider(
      vaultId: vaultId,
    );
  }

  @override
  ConsentRecordStoreProvider getProviderOverride(
    covariant ConsentRecordStoreProvider provider,
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
  String? get name => r'consentRecordStoreProvider';
}

/// Provides a per-vault [FlutterSecureConsentStorage] backed by Flutter
/// secure storage.
///
/// Keeps alive for the lifetime of the app — consent records are written
/// after every successful share and must not be discarded on dispose.
///
/// Namespaced by [vaultId] so each vault reads and writes only its own records.
/// Returns the concrete type so callers can use extended API (e.g. [listAll]).
///
/// Copied from [consentRecordStore].
class ConsentRecordStoreProvider extends Provider<FlutterSecureConsentStorage> {
  /// Provides a per-vault [FlutterSecureConsentStorage] backed by Flutter
  /// secure storage.
  ///
  /// Keeps alive for the lifetime of the app — consent records are written
  /// after every successful share and must not be discarded on dispose.
  ///
  /// Namespaced by [vaultId] so each vault reads and writes only its own records.
  /// Returns the concrete type so callers can use extended API (e.g. [listAll]).
  ///
  /// Copied from [consentRecordStore].
  ConsentRecordStoreProvider({
    required String vaultId,
  }) : this._internal(
          (ref) => consentRecordStore(
            ref as ConsentRecordStoreRef,
            vaultId: vaultId,
          ),
          from: consentRecordStoreProvider,
          name: r'consentRecordStoreProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$consentRecordStoreHash,
          dependencies: ConsentRecordStoreFamily._dependencies,
          allTransitiveDependencies:
              ConsentRecordStoreFamily._allTransitiveDependencies,
          vaultId: vaultId,
        );

  ConsentRecordStoreProvider._internal(
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
    FlutterSecureConsentStorage Function(ConsentRecordStoreRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConsentRecordStoreProvider._internal(
        (ref) => create(ref as ConsentRecordStoreRef),
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
  ProviderElement<FlutterSecureConsentStorage> createElement() {
    return _ConsentRecordStoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConsentRecordStoreProvider && other.vaultId == vaultId;
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
mixin ConsentRecordStoreRef on ProviderRef<FlutterSecureConsentStorage> {
  /// The parameter `vaultId` of this provider.
  String get vaultId;
}

class _ConsentRecordStoreProviderElement
    extends ProviderElement<FlutterSecureConsentStorage>
    with ConsentRecordStoreRef {
  _ConsentRecordStoreProviderElement(super.provider);

  @override
  String get vaultId => (origin as ConsentRecordStoreProvider).vaultId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
