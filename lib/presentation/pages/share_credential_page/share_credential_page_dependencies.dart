import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/ports/external_redirect_launcher.dart';
import '../../../application/ports/share_vault_session.dart';
import '../../../application/services/profile/profile_service.dart';
import '../../../application/services/share/consent_service.dart';
import '../../../application/services/share/credential_matching_service.dart';
import '../../../application/services/share/share_credential_flow_service.dart';
import '../../../application/services/share/share_request_validation_service.dart';
import '../../../application/services/share/share_submission_service.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../infrastructure/external_link/external_redirect_service.dart';

final externalRedirectLauncherProvider = Provider<ExternalRedirectLauncher>(
  (ref) => ref.read(externalRedirectServiceProvider),
);

class _ShareVaultSession implements ShareVaultSession {
  const _ShareVaultSession({
    required bool Function() hasOpenVault,
    required bool Function(String vaultId) isOpen,
    required Future<void> Function({
      required String vaultId,
      required String password,
    }) unlock,
    required Future<List<Profile>> Function() loadProfiles,
    required List<Profile> Function() profiles,
  })  : _hasOpenVault = hasOpenVault,
        _isOpen = isOpen,
        _unlock = unlock,
        _loadProfiles = loadProfiles,
        _profiles = profiles;

  final bool Function() _hasOpenVault;
  final bool Function(String vaultId) _isOpen;
  final Future<void> Function({
    required String vaultId,
    required String password,
  }) _unlock;
  final Future<List<Profile>> Function() _loadProfiles;
  final List<Profile> Function() _profiles;

  @override
  bool get hasOpenVault => _hasOpenVault();

  @override
  bool isOpen(String vaultId) => _isOpen(vaultId);

  @override
  Future<void> unlock({required String vaultId, required String password}) =>
      _unlock(vaultId: vaultId, password: password);

  @override
  Future<List<Profile>> loadProfiles() => _loadProfiles();

  @override
  List<Profile> get profiles => _profiles();
}

final shareCredentialFlowServiceProvider = Provider<ShareCredentialFlowService>(
  (ref) => ShareCredentialFlowService(
    vaultSession: _ShareVaultSession(
      hasOpenVault: () => ref.read(vaultServiceProvider).currentVault != null,
      isOpen: (vaultId) =>
          ref.read(vaultServiceProvider).currentVaultId == vaultId,
      unlock: ({required vaultId, required password}) => ref
          .read(vaultServiceProvider.notifier)
          .open(vaultId: vaultId, password: password),
      loadProfiles: () =>
          ref.read(profileServiceProvider.notifier).getProfiles(),
      profiles: () => ref.read(profileServiceProvider).profiles ?? const [],
    ),
    validationService: ref.read(shareRequestValidationServiceProvider),
    matchingService: ref.read(credentialMatchingServiceProvider),
    consentService: ref.read(consentServiceProvider),
    submissionService: ref.read(shareSubmissionServiceProvider),
  ),
);
