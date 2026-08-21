import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ssi/ssi.dart';

import '../../../infrastructure/extensions/verifiable_credential_extensions.dart';
import '../../../infrastructure/loggers/error_logger/error_logging_handler.dart';
import 'consent_service.dart';
import 'share_response_service.dart';

/// Outcome of assembling the credentials to submit for a share.
sealed class CredentialSelection {
  const CredentialSelection();
}

/// Enough credentials were selected for every group.
class CredentialsSelected extends CredentialSelection {
  const CredentialsSelected(this.credentials);

  final List<ParsedVerifiableCredential<dynamic>> credentials;
}

/// At least one group had fewer than its required number of credentials.
class InsufficientCredentials extends CredentialSelection {
  const InsufficientCredentials();
}

/// Builds and submits the OID4VP presentation, and rejects requests, on the
/// share flow's behalf. Keeps credential assembly and consent persistence out
/// of the page controller.
class ShareSubmissionService {
  ShareSubmissionService({
    required ShareResponseService responseService,
    required ConsentService consentService,
  })  : _responseService = responseService,
        _consentService = consentService;

  final ShareResponseService _responseService;
  final ConsentService _consentService;

  /// Selects the credentials to submit, honouring each group's
  /// `minimumVCsCountToShare`. Returns [InsufficientCredentials] when a group
  /// has fewer selected credentials than it requires.
  CredentialSelection selectCredentials({
    required MatchedCredentialsResult matchResult,
    required Set<String> selectedIds,
  }) {
    final selected = <ParsedVerifiableCredential<dynamic>>[];
    for (final group in matchResult.groups) {
      final requiredCount = group.minimumVCsCountToShare;
      final forGroup = group.availableCredentials
          .where((vc) => selectedIds.contains(vc.id.toString()))
          .take(requiredCount)
          .toList(growable: false);

      if (forGroup.length < requiredCount) {
        return const InsufficientCredentials();
      }
      for (final vc in forGroup) {
        selected.add(vc.toParsedCredential());
      }
    }
    return CredentialsSelected(selected);
  }

  /// Submits [credentials] as a Verifiable Presentation and persists a consent
  /// record. Returns the verifier redirect [Uri] when present.
  ///
  /// Consent persistence failures are logged but not rethrown: the share has
  /// already succeeded, and a missing record only degrades the auto-allow
  /// optimisation on later requests.
  Future<Uri?> submit({
    required String vaultId,
    required Profile profile,
    required Oid4vpShareRequest shareRequest,
    required List<ParsedVerifiableCredential<dynamic>> credentials,
    required VerifierClientMetadata verifierMetadata,
    required bool isAutoShareEnabled,
    required bool isConsentManagementEnabled,
  }) async {
    final redirectUri = await _responseService.submitShareRequest(
      vaultId: vaultId,
      accountIndex: profile.accountIndex,
      shareRequest: shareRequest,
      selectedCredentials: credentials,
    );

    try {
      await _consentService.saveConsent(
        vaultId: vaultId,
        profile: profile,
        shareRequest: shareRequest,
        verifierMetadata: verifierMetadata,
        sharedVcs: credentials,
        isAutoShareEnabled: isAutoShareEnabled,
        isConsentManagementEnabled: isConsentManagementEnabled,
      );
    } catch (e, st) {
      ErrorLoggingHandler.instance.logError(
        e,
        st,
        reason: 'Failed to persist consent record after share',
      );
    }

    return redirectUri;
  }

  /// Sends an explicit rejection to the verifier. Returns the verifier redirect
  /// [Uri] when present.
  Future<Uri?> reject({
    required String vaultId,
    required Profile profile,
    required Oid4vpShareRequest shareRequest,
  }) =>
      _responseService.rejectShareRequest(
        vaultId: vaultId,
        accountIndex: profile.accountIndex,
        shareRequest: shareRequest,
      );
}

final shareSubmissionServiceProvider = Provider<ShareSubmissionService>(
  (ref) => ShareSubmissionService(
    responseService: ref.read(shareResponseServiceProvider),
    consentService: ref.read(consentServiceProvider),
  ),
);
