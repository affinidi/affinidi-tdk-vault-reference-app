// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$consentStorageHash() => r'c0ff03982944fdc930b32d01b096ef7fd99f21c2';

/// Provides a [FlutterSecureConsentStorage] backed by Flutter secure storage.
///
/// Keeps alive for the lifetime of the app — consent records are written
/// after every successful share and must not be discarded on dispose.
///
/// Returns the concrete type so callers can use extended API (e.g. [listAll]).
///
/// Copied from [consentStorage].
@ProviderFor(consentStorage)
final consentStorageProvider = Provider<FlutterSecureConsentStorage>.internal(
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
typedef ConsentStorageRef = ProviderRef<FlutterSecureConsentStorage>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
