// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_record_store_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$consentRecordStoreHash() =>
    r'089835562c4b4380da70a80f3c09c767fef45176';

/// Provides a [FlutterSecureConsentRecordStore] backed by Flutter secure storage.
///
/// Keeps alive for the lifetime of the app — consent records are written
/// after every successful share and must not be discarded on dispose.
///
/// Returns the concrete type so callers can use extended API (e.g. [listAll]).
///
/// Copied from [consentRecordStore].
@ProviderFor(consentRecordStore)
final consentRecordStoreProvider =
    Provider<FlutterSecureConsentRecordStore>.internal(
  consentRecordStore,
  name: r'consentRecordStoreProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$consentRecordStoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConsentRecordStoreRef = ProviderRef<FlutterSecureConsentRecordStore>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
