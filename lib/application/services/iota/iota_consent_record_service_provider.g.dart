// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iota_consent_record_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$iotaConsentRecordServiceHash() =>
    r'075051f28ee7db4ed86093e88eb3e233f3ae82ed';

/// Provides an [IotaConsentRecordService] wired to the app's secure-storage
/// [ConsentStorage].
///
/// Kept alive so the underlying store singleton is shared across the app.
/// The [_NullShareResponseService] stub is intentional: this provider is used
/// only for [IotaConsentRecordService.saveConsentRecord], which never invokes
/// the share response service. Auto-consent submission uses a fresh
/// [IotaConsentRecordService] with a real signer; see
/// [ShareCredentialPageController._tryAutomaticConsentAndSubmit].
///
/// Copied from [iotaConsentRecordService].
@ProviderFor(iotaConsentRecordService)
final iotaConsentRecordServiceProvider =
    Provider<IotaConsentRecordService>.internal(
  iotaConsentRecordService,
  name: r'iotaConsentRecordServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$iotaConsentRecordServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IotaConsentRecordServiceRef = ProviderRef<IotaConsentRecordService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
