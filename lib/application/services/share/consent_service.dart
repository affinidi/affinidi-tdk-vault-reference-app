import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ssi/ssi.dart';

import '../iota/iota_consent_record_service.dart';

/// Coordinates consent-record operations for the share flow: deciding whether
/// a share request can be auto-approved from a previously stored consent, and
/// persisting a new consent record after a completed share.
class ConsentService {
  ConsentService(this._ref);

  final Ref _ref;

  IotaConsentRecordServiceInterface _consentRecordService(
    String vaultId,
    int accountIndex,
  ) =>
      _ref.read(
        iotaConsentRecordServiceProvider(
          vaultId: vaultId,
          accountIndex: accountIndex,
        ),
      );

  /// Decides whether a share request can be auto-approved from a previously
  /// stored consent, submitting the VP on the caller's behalf when it can.
  ///
  /// Returns [AutoConsentApproved] (with an optional verifier redirect) or
  /// [AutoConsentDeclined].
  Future<AutoConsentResult> tryAutomaticConsent({
    required String vaultId,
    required int accountIndex,
    required Oid4vpShareRequest shareRequest,
    required MatchedCredentialsResult matchResult,
    required VerifierClientMetadata verifierMetadata,
  }) =>
      _consentRecordService(vaultId, accountIndex).tryAutomaticConsent(
        shareRequest: shareRequest,
        matchedCredentials: matchResult,
        verifierMetadata: verifierMetadata,
        vaultId: vaultId,
      );

  /// Persists a consent record for a completed share. The `requestHash` used
  /// for later auto-consent lookups is derived internally from the request and
  /// vault.
  Future<void> saveConsent({
    required String vaultId,
    required Profile profile,
    required Oid4vpShareRequest shareRequest,
    required VerifierClientMetadata verifierMetadata,
    required List<ParsedVerifiableCredential<dynamic>> sharedVcs,
    required bool isAutoShareEnabled,
    required bool isConsentManagementEnabled,
  }) {
    final claimedVcTypesCsv =
        (sharedVcs.expand((vc) => vc.type).toSet().toList()..sort()).join(',');

    return _consentRecordService(vaultId, profile.accountIndex)
        .saveConsentRecord(
      shareRequest: shareRequest,
      verifierMetadata: verifierMetadata,
      profileId: profile.id,
      profileName: profile.name,
      vaultId: vaultId,
      sharedVcs: sharedVcs,
      claimedVcTypesCsv: claimedVcTypesCsv,
      isAutoShareEnabled: isAutoShareEnabled,
      isConsentManagementEnabled: isConsentManagementEnabled,
    );
  }
}

final consentServiceProvider =
    Provider<ConsentService>((ref) => ConsentService(ref));
