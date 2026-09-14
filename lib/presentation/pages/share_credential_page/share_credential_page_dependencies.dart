import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/ports/external_redirect_launcher.dart';
import '../../../application/services/share/consent_service.dart';
import '../../../application/services/share/credential_matching_service.dart';
import '../../../application/services/share/share_credential_flow_service.dart';
import '../../../application/services/share/share_request_validation_service.dart';
import '../../../application/services/share/share_submission_service.dart';
import '../../../application/services/share/share_vault_session.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../infrastructure/external_link/external_redirect_service.dart';

final externalRedirectLauncherProvider = Provider<ExternalRedirectLauncher>(
  (ref) => ref.read(externalRedirectServiceProvider),
);

class _ShareVaultSession implements ShareVaultSession {
  _ShareVaultSession(this._ref);

  final Ref _ref;
  List<Profile> _profiles = const [];

  @override
  bool isOpen(String vaultId) =>
      _ref.read(vaultServiceProvider).currentVaultId == vaultId;

  @override
  Future<void> unlock({required String vaultId, required String password}) =>
      _ref
          .read(vaultServiceProvider.notifier)
          .open(vaultId: vaultId, password: password);

  @override
  Future<List<Profile>> loadProfiles(String vaultId) async {
    if (!isOpen(vaultId)) {
      _profiles = const [];
      return _profiles;
    }
    final vault = _ref.read(vaultServiceProvider).currentVault;
    if (vault == null) {
      _profiles = const [];
      return _profiles;
    }
    _profiles = await vault.listProfiles();
    return _profiles;
  }

  @override
  List<Profile> get profiles => _profiles;
}

final shareCredentialFlowServiceProvider = Provider<ShareCredentialFlowService>(
  (ref) => ShareCredentialFlowService(
    vaultSession: _ShareVaultSession(ref),
    validationService: ref.read(shareRequestValidationServiceProvider),
    matchingService: ref.read(credentialMatchingServiceProvider),
    consentService: ref.read(consentServiceProvider),
    submissionService: ref.read(shareSubmissionServiceProvider),
  ),
);
