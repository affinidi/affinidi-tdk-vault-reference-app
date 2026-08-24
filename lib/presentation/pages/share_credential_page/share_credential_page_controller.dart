import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../application/services/share/consent_service.dart';
import '../../../application/services/share/credential_matching_service.dart';
import '../../../application/services/share/share_request_validation_service.dart';
import '../../../application/services/share/share_submission_service.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../application/services/vaults_manager/vaults_manager_service.dart';
import '../../../infrastructure/exceptions/app_exception.dart';
import '../../../infrastructure/external_link/external_redirect_service.dart';
import '../../../infrastructure/extensions/matched_credentials_result_extensions.dart';
import '../../../infrastructure/loggers/error_logger/error_logging_handler.dart';
import '../../../infrastructure/providers/localizations_provider.dart';
import '../../../navigation/flows/share_credential/share_credential_route_constants.dart';
import 'share_credential_page_state.dart';

part 'share_credential_page_controller.g.dart';

@riverpod
class ShareCredentialPageController extends _$ShareCredentialPageController {
  String? _selectedVaultId;
  bool _hasValidated = false;
  bool _isFromDeepLink = false;

  /// Returns a user-facing message for [e].
  ///
  /// All controller-level errors are expected to be [TdkException] (raised by
  /// the iota share-flow services) or [AppException] (raised by this app).
  /// Anything else is a programming error in the source layer; we surface a
  /// generic message rather than scraping `toString()` and let the underlying
  /// exception be diagnosed via [ErrorLoggingHandler].
  String _extractUserMessage(Object e) {
    if (e is TdkException) return e.message;
    if (e is AppException) return e.message;
    return ref.read(localizationsProvider).shareFlowGenericError;
  }

  Never _missingProfile(String message) => throw AppException(
        message: message,
        type: AppExceptionType.missingProfile,
      );

  Profile _resolveSelectedProfile() {
    final profileId =
        state.selectedProfileId ?? _missingProfile('Profile is not selected.');

    final profiles = state.profiles;
    if (profiles == null || profiles.isEmpty) {
      _missingProfile('Profiles are not loaded.');
    }

    return profiles.firstWhere(
      (profile) => profile.id == profileId,
      orElse: () =>
          _missingProfile('Selected profile was not found in current vault.'),
    );
  }

  @override
  ShareCredentialPageState build({
    required String requestJwt,
    String? clientId,
  }) {
    final vaultRegistry = ref.read(
      vaultsManagerServiceProvider.select((s) => s.vaultRegistry),
    );

    ref.onDispose(() {
      if (_isFromDeepLink) {
        ref.read(vaultServiceProvider.notifier).resetCurrentVault();
      }
    });

    if (vaultRegistry.isEmpty) {
      Future.microtask(_loadVaultsAndHandleEmpty);
    }

    if (_selectedVaultId == null && vaultRegistry.isNotEmpty) {
      final currentVaultId = ref.read(vaultServiceProvider).currentVaultId;
      _selectedVaultId =
          (currentVaultId != null && vaultRegistry.containsKey(currentVaultId))
              ? currentVaultId
              : vaultRegistry.keys.first;
    }

    ref.listen(
      vaultsManagerServiceProvider.select((s) => s.vaultRegistry),
      (_, newRegistry) {
        if (_selectedVaultId == null && newRegistry.isNotEmpty) {
          final currentVaultId = ref.read(vaultServiceProvider).currentVaultId;
          _selectedVaultId = (currentVaultId != null &&
                  newRegistry.containsKey(currentVaultId))
              ? currentVaultId
              : newRegistry.keys.first;
        }
        state = state.copyWith(
          vaultRegistry: newRegistry,
          selectedVaultId: _selectedVaultId,
        );
      },
    );

    if (!_hasValidated) {
      _hasValidated = true;
      Future.microtask(validateRequest);
    }

    return ShareCredentialPageState(
      requestJwt: requestJwt,
      clientId: clientId,
      vaultRegistry: vaultRegistry,
      selectedVaultId: _selectedVaultId,
    );
  }

  /// Records how the share flow was entered (see [ShareCredentialRouteSource]).
  ///
  /// Called from the page's route builder. When entered via a deep link the
  /// controller resets the current vault on dispose; a manual push leaves the
  /// already-open vault untouched. Replaces the previous `Navigator.canPop()`
  /// heuristic, which misclassified cold starts and hot restarts.
  void markSource(String? source) {
    _isFromDeepLink = source == ShareCredentialRouteSource.deeplink;
  }

  Future<void> _loadVaultsAndHandleEmpty() async {
    await ref.read(vaultsManagerServiceProvider.notifier).loadVaults();
    final registry = ref.read(
      vaultsManagerServiceProvider.select((s) => s.vaultRegistry),
    );
    if (registry.isEmpty) {
      state = state.copyWith(
        stage: StageRequestInvalid(
          ref.read(localizationsProvider).shareFlowNoVaultError,
        ),
      );
    }
  }

  void selectVault(String vaultId) {
    _selectedVaultId = vaultId;

    // Check if the vault is already open; if so, load profiles without passphrase
    final currentVaultId = ref.read(vaultServiceProvider).currentVaultId;
    if (currentVaultId == vaultId) {
      state = state.copyWith(
        selectedVaultId: vaultId,
        profiles: null,
        selectedProfileId: null,
        matchResult: null,
        selectedCredentialIds: const <String>{},
        stage: const StageVerifyingPassphrase(),
      );
      _loadProfilesForCurrentVault();
    } else {
      state = state.copyWith(
        selectedVaultId: vaultId,
        profiles: null,
        selectedProfileId: null,
        matchResult: null,
        selectedCredentialIds: const <String>{},
        stage: const StageAwaitingPassphrase(),
      );
    }
  }

  /// Loads profiles for the currently open vault without requiring passphrase.
  Future<void> _loadProfilesForCurrentVault() async {
    final vaultId = state.selectedVaultId;
    try {
      final vault = ref.read(vaultServiceProvider).currentVault;
      final profiles = vault != null ? await vault.listProfiles() : <Profile>[];
      if (state.selectedVaultId != vaultId) {
        return;
      }

      state = state.copyWith(
        selectedVaultId: _selectedVaultId,
        profiles: profiles,
        selectedProfileId: profiles.isNotEmpty ? profiles.first.id : null,
        matchResult: null,
        selectedCredentialIds: const <String>{},
        stage: const StageAwaitingProfile(),
      );

      if (profiles.isNotEmpty) {
        Future.microtask(() => matchCredentials(profiles.first.id));
      }
    } catch (e, st) {
      if (state.selectedVaultId != vaultId) return;
      ErrorLoggingHandler.instance
          .logError(e, st, reason: '_loadProfilesForCurrentVault failed');

      state = state.copyWith(
        selectedVaultId: _selectedVaultId,
        profiles: null,
        selectedProfileId: null,
        matchResult: null,
        selectedCredentialIds: const <String>{},
        stage: StageAwaitingPassphrase(
          error: ref.read(localizationsProvider).shareFlowErrorOccurred,
        ),
      );
    }
  }

  Future<void> validateRequest() async {
    final jwt = state.requestJwt;
    if (jwt.isEmpty) {
      state = state.copyWith(
        stage: StageRequestInvalid(
            ref.read(localizationsProvider).shareFlowValidationFailed),
      );
      return;
    }

    try {
      final validated =
          await ref.read(shareRequestValidationServiceProvider).validate(jwt);
      final result = validated.request;

      final currentVaultId = ref.read(vaultServiceProvider).currentVaultId;
      final shouldLoadProfilesWithoutPassphrase =
          currentVaultId != null && currentVaultId == state.selectedVaultId;

      state = state.copyWith(
        shareRequest: result,
        verifierMetadata: validated.verifierMetadata,
        stage: shouldLoadProfilesWithoutPassphrase
            ? const StageVerifyingPassphrase()
            : const StageAwaitingPassphrase(),
      );

      if (shouldLoadProfilesWithoutPassphrase) {
        await _loadProfilesForCurrentVault();
      }
    } on TdkException catch (e, st) {
      ErrorLoggingHandler.instance
          .logError(e, st, reason: 'validateRequest failed');
      final l = ref.read(localizationsProvider);
      final message = e.code == TdkExceptionType.invalidOrExpiredJwt.code
          ? l.shareFlowRequestExpiredOrInvalid
          : l.shareFlowValidationFailedDetails(e.message);
      state = state.copyWith(stage: StageRequestInvalid(message));
    } catch (e, st) {
      ErrorLoggingHandler.instance
          .logError(e, st, reason: 'validateRequest failed');
      state = state.copyWith(
        stage: StageRequestInvalid(
            ref.read(localizationsProvider).shareFlowValidationFailed),
      );
    }
  }

  /// Opens the selected vault using [passphrase] and loads its profiles.
  ///
  /// Parameters:
  /// * [passphrase] - Vault unlock passphrase entered by the user.
  ///
  /// Returns a [Future] that completes once `state` is updated. On wrong
  /// passphrase sets `state.stage` to [StageAwaitingPassphrase] with an
  /// `error`; on success populates `state.profiles` and triggers credential
  /// matching for the first profile.
  Future<void> verifyPassphrase(String passphrase) async {
    final vaultId = state.selectedVaultId;
    if (vaultId == null) return;

    state = state.copyWith(stage: const StageVerifyingPassphrase());

    try {
      await ref.read(vaultServiceProvider.notifier).open(
            vaultId: vaultId,
            password: passphrase,
          );

      final vault = ref.read(vaultServiceProvider).currentVault;
      final profiles = vault != null ? await vault.listProfiles() : <Profile>[];
      if (state.selectedVaultId != vaultId) {
        return;
      }

      state = state.copyWith(
        profiles: profiles,
        selectedProfileId: profiles.isNotEmpty ? profiles.first.id : null,
        stage: const StageAwaitingProfile(),
      );

      if (profiles.isNotEmpty) {
        Future.microtask(() => matchCredentials(profiles.first.id));
      }
    } catch (e, st) {
      if (state.selectedVaultId != vaultId) return;
      ErrorLoggingHandler.instance
          .logError(e, st, reason: 'verifyPassphrase failed');

      final l = ref.read(localizationsProvider);
      final errorMessage =
          (e is AppException && e.type == AppExceptionType.invalidPassword)
              ? l.incorrectPassphrase
              : l.shareFlowErrorOccurred;

      state = state.copyWith(
        stage: StageAwaitingPassphrase(error: errorMessage),
      );
    }
  }

  void selectProfile(String profileId) {
    state = state.copyWith(
      selectedProfileId: profileId,
      matchResult: null,
    );
    Future.microtask(() => matchCredentials(profileId));
  }

  /// Loads all credentials for [profileId] and matches them against the
  /// presentation definition in `state.shareRequest`.
  ///
  /// Parameters:
  /// * [profileId] - Identifier of the profile whose credentials should be
  ///   evaluated.
  ///
  /// Returns a [Future] that completes once `state.matchResult` reflects the
  /// matched VCs. Sets `state.stage` to [StageMatchFailed] instead of
  /// throwing on failure.
  Future<void> matchCredentials(String profileId) async {
    final shareRequest = state.shareRequest;
    if (shareRequest == null) return;

    final vaultId = state.selectedVaultId;
    if (vaultId == null) return;

    // Identity captured at start; a newer vault/profile selection supersedes
    // this run, so its writes are discarded.
    bool isStale() =>
        state.selectedVaultId != vaultId ||
        state.selectedProfileId != profileId;

    if (isStale()) {
      return;
    }

    state = state.copyWith(
      stage: const StageMatchingCredentials(),
      matchResult: null,
    );

    try {
      final vault = ref.read(vaultServiceProvider).currentVault;
      if (vault == null) {
        if (isStale()) return;
        state = state.copyWith(
          stage: StageMatchFailed(
            ref.read(localizationsProvider).shareFlowFailedToLoadCredentials,
          ),
        );
        return;
      }

      final profile = await vault.getProfileById(profileId);
      if (isStale()) {
        return;
      }
      final storage = profile.defaultCredentialStorage;
      if (storage == null) {
        state = state.copyWith(
          matchResult: const ClaimedCredentialsResult(vcsGroups: {}),
          stage: const StageReadyToShare(),
        );
        return;
      }

      final matchResult =
          await ref.read(credentialMatchingServiceProvider).match(
                shareRequest: shareRequest,
                storage: storage,
              );
      if (isStale()) {
        return;
      }

      state = state.copyWith(
        matchResult: matchResult,
        selectedCredentialIds: matchResult.requiredMatchedVcs
            .map((vc) => vc.id.toString())
            .toSet(),
        // Stay non-interactive while auto-consent runs so the user cannot
        // submit/reject concurrently with an in-flight auto-consent attempt.
        stage: const StageMatchingCredentials(),
      );

      await _tryAutomaticConsent(
        vaultId: vaultId,
        shareRequest: shareRequest,
        matchResult: matchResult,
      );
      if (isStale()) return;

      // Auto-consent may have already dismissed the flow (StageDismissed).
      // Only make the UI interactive if it did not.
      if (state.stage is! StageDismissed) {
        state = state.copyWith(stage: const StageReadyToShare());
      }
    } catch (e, st) {
      if (isStale()) return;
      ErrorLoggingHandler.instance
          .logError(e, st, reason: 'matchCredentials failed');
      state = state.copyWith(
        stage: StageMatchFailed(
          ref.read(localizationsProvider).shareFlowFailedToLoadCredentials,
        ),
      );
    }
  }

  void toggleCredentialSelection(String id, {required bool selected}) {
    final updated = Set<String>.from(state.selectedCredentialIds);
    if (selected) {
      updated.add(id);
    } else {
      updated.remove(id);
    }
    state = state.copyWith(selectedCredentialIds: updated);
  }

  void setAutoAllowConsent(bool value) {
    state = state.copyWith(autoAllowConsent: value);
  }

  /// Attempts automatic consent after credential matching completes.
  ///
  /// Looks up a stored consent record matching the current request fingerprint.
  /// If a prior share with auto-share enabled is found and all guards pass,
  /// the VP is submitted automatically and the page dismisses without user
  /// interaction. Falls back silently to the interactive share screen on any
  /// failure or when no matching record exists.
  ///
  /// Parameters:
  /// * [vaultId] - Vault that will sign the VP.
  /// * [shareRequest] - The validated OID4VP request.
  /// * [matchResult] - Credentials already matched against the request.
  Future<void> _tryAutomaticConsent({
    required String vaultId,
    required Oid4vpShareRequest shareRequest,
    required MatchedCredentialsResult matchResult,
  }) async {
    try {
      final profile = _resolveSelectedProfile();
      final result = await ref.read(consentServiceProvider).tryAutomaticConsent(
            vaultId: vaultId,
            accountIndex: profile.accountIndex,
            shareRequest: shareRequest,
            matchResult: matchResult,
            verifierMetadata:
                state.verifierMetadata ?? const VerifierClientMetadata(),
          );

      switch (result) {
        case AutoConsentApproved(:final redirectUri):
          await _dismissWithRedirect(redirectUri);
        case AutoConsentDeclined():
          // No prior record qualifies — keep StageReadyToShare for
          // the user to confirm interactively.
          break;
      }
    } catch (e, st) {
      ErrorLoggingHandler.instance.logError(
        e,
        st,
        reason: 'tryAutomaticConsent failed; falling back to interactive share',
      );
      // Non-fatal: the page stays at StageReadyToShare.
    }
  }

  /// Replaces the selected credentials for a single group.
  ///
  /// Clears every candidate id in [groupVcIds] from the current selection and
  /// adds [selectedIds], leaving other groups untouched. The picker enforces
  /// the group's `minimumVCsCountToShare`, so the resulting set stays valid
  /// for submission even when a group requires more than one credential.
  void setGroupSelection(List<String> groupVcIds, Set<String> selectedIds) {
    final updated = Set<String>.from(state.selectedCredentialIds)
      ..removeAll(groupVcIds)
      ..addAll(selectedIds);
    state = state.copyWith(selectedCredentialIds: updated);
  }

  /// Dismisses the flow after a successful share: launches the verifier
  /// redirect when present and shows the success toast only when no external
  /// redirect took the user away.
  Future<void> _dismissWithRedirect(Uri? redirectUri) async {
    var showToast = redirectUri == null;
    if (redirectUri != null) {
      final launched =
          await ref.read(externalRedirectServiceProvider).open(redirectUri);
      if (!launched) showToast = true;
    }
    state = state.copyWith(
      stage: StageDismissed(showShareSuccessToast: showToast),
    );
  }

  /// Submits the user-selected credentials as a Verifiable Presentation to
  /// the verifier callback URL.
  ///
  /// Returns a [Future] resolving to the verifier-supplied redirect [Uri]
  /// when present (which is launched in the external browser), or `null` when
  /// the verifier returned no redirect. Sets `state.stage` to
  /// [StageSubmitFailed] instead of throwing on failure.
  Future<Uri?> submitSelectedCredentials() async {
    state = state.copyWith(stage: const StageSubmitting());

    try {
      final l = ref.read(localizationsProvider);
      final shareRequest = state.shareRequest;
      final matchResult = state.matchResult;
      if (shareRequest == null || matchResult == null) {
        throw AppException(
          message: l.shareFlowErrorOccurred,
          type: AppExceptionType.missingRequiredData,
        );
      }

      if (state.selectedCredentialIds.isEmpty) {
        throw AppException(
          message: l.shareFlowSelectAtLeastOneCredential,
          type: AppExceptionType.missingVerifiableCredentials,
        );
      }

      final vaultId = state.selectedVaultId;
      if (vaultId == null) {
        throw AppException(
          message: l.shareFlowErrorOccurred,
          type: AppExceptionType.missingVaultId,
        );
      }

      final submissionService = ref.read(shareSubmissionServiceProvider);
      final selection = submissionService.selectCredentials(
        matchResult: matchResult,
        selectedIds: state.selectedCredentialIds,
      );
      if (selection is InsufficientCredentials) {
        throw AppException(
          message: l.shareFlowNotEnoughMatchingCredentials,
          type: AppExceptionType.missingVerifiableCredentials,
        );
      }

      final redirectUri = await submissionService.submit(
        vaultId: vaultId,
        profile: _resolveSelectedProfile(),
        shareRequest: shareRequest,
        credentials: (selection as CredentialsSelected).credentials,
        verifierMetadata:
            state.verifierMetadata ?? const VerifierClientMetadata(),
        isAutoShareEnabled: state.autoAllowConsent,
        isConsentManagementEnabled: state.isConsentManagementEnabled,
      );

      await _dismissWithRedirect(redirectUri);
      return redirectUri;
    } catch (e, st) {
      ErrorLoggingHandler.instance
          .logError(e, st, reason: 'submitSelectedCredentials failed');
      state = state.copyWith(
        stage: StageSubmitFailed(_extractUserMessage(e)),
      );
      return null;
    }
  }

  /// Sends an explicit reject response to the verifier callback URL.
  ///
  /// Returns a [Future] resolving to the verifier-supplied redirect [Uri]
  /// when present (which is launched in the external browser), or `null` when
  /// the verifier returned no redirect. Sets `state.stage` to
  /// [StageSubmitFailed] instead of throwing on failure.
  Future<Uri?> rejectShareRequest() async {
    state = state.copyWith(stage: const StageSubmitting());

    try {
      final l = ref.read(localizationsProvider);
      final shareRequest = state.shareRequest;
      if (shareRequest == null) {
        throw AppException(
          message: l.shareFlowErrorOccurred,
          type: AppExceptionType.missingRequiredData,
        );
      }

      final vaultId = state.selectedVaultId;
      if (vaultId == null) {
        throw AppException(
          message: l.shareFlowErrorOccurred,
          type: AppExceptionType.missingVaultId,
        );
      }

      final redirectUri = await ref.read(shareSubmissionServiceProvider).reject(
            vaultId: vaultId,
            profile: _resolveSelectedProfile(),
            shareRequest: shareRequest,
          );
      if (redirectUri != null) {
        final launched =
            await ref.read(externalRedirectServiceProvider).open(redirectUri);
        if (!launched) {
          throw AppException(
            message: l.shareFlowCouldNotOpenRedirect,
            type: AppExceptionType.other,
          );
        }
      }
      state = state.copyWith(
        stage: const StageDismissed(showShareSuccessToast: false),
      );
      return redirectUri;
    } catch (e, st) {
      ErrorLoggingHandler.instance
          .logError(e, st, reason: 'rejectShareRequest failed');
      state = state.copyWith(
        stage: StageSubmitFailed(_extractUserMessage(e)),
      );
      return null;
    }
  }
}
