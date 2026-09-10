import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../application/services/share/share_credential_flow_service.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../application/services/vaults_manager/vaults_manager_service.dart';
import '../../../infrastructure/exceptions/app_exception.dart';
import '../../../infrastructure/extensions/matched_credentials_result_extensions.dart';
import '../../../infrastructure/loggers/error_logger/error_logging_handler.dart';
import '../../../infrastructure/providers/localizations_provider.dart';
import '../../../navigation/flows/share_credential/share_credential_route_constants.dart';
import 'share_credential_page_dependencies.dart';
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
  String _messageFor(Object e) {
    final l = ref.read(localizationsProvider);
    if (e is AppException &&
        e.type == AppExceptionType.missingVerifiableCredentials) {
      return l.shareFlowNotEnoughMatchingCredentials;
    }
    if (e is AppException && e.type == AppExceptionType.redirectLaunchFailed) {
      return l.shareFlowCouldNotOpenRedirect;
    }
    if (e is TdkException) return e.message;
    if (e is AppException) return e.message;
    return l.shareFlowGenericError;
  }

  @override
  ShareCredentialPageState build({
    required String requestJwt,
    String? clientId,
  }) {
    final vaultRegistry = ref.read(
      vaultsManagerServiceProvider.select((s) => s.vaultRegistry),
    );

    final vaultService = ref.read(vaultServiceProvider.notifier);
    ref.onDispose(() async {
      if (_isFromDeepLink) {
        await vaultService.resetCurrentVault();
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

    final isOpen =
        ref.read(shareCredentialFlowServiceProvider).isVaultOpen(vaultId);
    state = state.copyWith(
      selectedVaultId: vaultId,
      profiles: null,
      selectedProfileId: null,
      matchResult: null,
      selectedCredentialIds: const <String>{},
      stage: isOpen
          ? const StageVerifyingPassphrase()
          : const StageAwaitingPassphrase(),
    );

    if (isOpen) {
      _loadProfilesForVault(vaultId);
    }
  }

  /// Loads profiles for [vaultId], assuming it is already unlocked. Shared by
  /// [selectVault] (vault already open), [validateRequest] (vault already
  /// open) and [verifyPassphrase] (just unlocked).
  Future<void> _loadProfilesForVault(String vaultId) async {
    try {
      final profiles = await ref
          .read(shareCredentialFlowServiceProvider)
          .loadProfilesForOpenVault();
      if (state.selectedVaultId != vaultId) {
        return;
      }

      state = state.copyWith(
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
          .logError(e, st, reason: '_loadProfilesForVault failed');

      state = state.copyWith(
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
      final flowService = ref.read(shareCredentialFlowServiceProvider);
      final validated = await flowService.validateRequest(jwt);

      final vaultId = state.selectedVaultId;
      final shouldLoadProfilesWithoutPassphrase =
          vaultId != null && flowService.isVaultOpen(vaultId);

      state = state.copyWith(
        shareRequest: validated.request,
        verifierMetadata: validated.verifierMetadata,
        stage: shouldLoadProfilesWithoutPassphrase
            ? const StageVerifyingPassphrase()
            : const StageAwaitingPassphrase(),
      );

      if (shouldLoadProfilesWithoutPassphrase) {
        await _loadProfilesForVault(vaultId);
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

  /// Unlocks the selected vault using [passphrase] and loads its profiles.
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
      await ref.read(shareCredentialFlowServiceProvider).unlockVault(
            vaultId: vaultId,
            password: passphrase,
          );
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
      return;
    }

    if (state.selectedVaultId != vaultId) return;
    await _loadProfilesForVault(vaultId);
  }

  void selectProfile(String profileId) {
    state = state.copyWith(
      selectedProfileId: profileId,
      matchResult: null,
    );
    Future.microtask(() => matchCredentials(profileId));
  }

  /// Matches [profileId]'s credentials against the presentation definition in
  /// `state.shareRequest`, and checks for automatic consent.
  ///
  /// Parameters:
  /// * [profileId] - Identifier of the profile whose credentials should be
  ///   evaluated.
  ///
  /// Returns a [Future] that completes once `state` reflects the outcome.
  /// Sets `state.stage` to [StageMatchFailed] instead of throwing on failure.
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
      final outcome =
          await ref.read(shareCredentialFlowServiceProvider).matchCredentials(
                vaultId: vaultId,
                profileId: profileId,
                shareRequest: shareRequest,
                verifierMetadata:
                    state.verifierMetadata ?? const VerifierClientMetadata(),
              );
      if (isStale()) {
        return;
      }

      switch (outcome) {
        case MatchReadyToShare(:final matchResult):
          state = state.copyWith(
            matchResult: matchResult,
            selectedCredentialIds: matchResult.requiredMatchedVcs
                .map((vc) => vc.id.toString())
                .toSet(),
            stage: const StageReadyToShare(),
          );
        case MatchAutoConsented(:final dismissal):
          state = state.copyWith(
            stage: StageDismissed(
              showShareSuccessToast:
                  await _shouldShowSuccessToast(dismissal.redirectUri),
            ),
          );
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

  /// Submits the user-selected credentials as a Verifiable Presentation to
  /// the verifier callback URL.
  ///
  /// Returns a [Future] resolving to the verifier-supplied redirect [Uri]
  /// when present (which is launched in the external browser), or `null` when
  /// the verifier returned no redirect. Sets `state.stage` to
  /// [StageSubmitFailed] instead of throwing on failure.
  Future<Uri?> submitSelectedCredentials() async {
    final l = ref.read(localizationsProvider);
    final shareRequest = state.shareRequest;
    final matchResult = state.matchResult;
    final vaultId = state.selectedVaultId;
    final profileId = state.selectedProfileId;

    if (shareRequest == null ||
        matchResult == null ||
        vaultId == null ||
        profileId == null) {
      state =
          state.copyWith(stage: StageSubmitFailed(l.shareFlowErrorOccurred));
      return null;
    }

    if (state.selectedCredentialIds.isEmpty) {
      state = state.copyWith(
        stage: StageSubmitFailed(l.shareFlowSelectAtLeastOneCredential),
      );
      return null;
    }

    state = state.copyWith(stage: const StageSubmitting());

    try {
      final outcome = await ref.read(shareCredentialFlowServiceProvider).submit(
            vaultId: vaultId,
            profileId: profileId,
            shareRequest: shareRequest,
            matchResult: matchResult,
            selectedCredentialIds: state.selectedCredentialIds,
            verifierMetadata:
                state.verifierMetadata ?? const VerifierClientMetadata(),
            autoAllowConsent: state.autoAllowConsent,
            isConsentManagementEnabled: state.isConsentManagementEnabled,
          );

      state = state.copyWith(
        stage: StageDismissed(
          showShareSuccessToast:
              await _shouldShowSuccessToast(outcome.redirectUri),
        ),
      );
      return outcome.redirectUri;
    } catch (e, st) {
      ErrorLoggingHandler.instance
          .logError(e, st, reason: 'submitSelectedCredentials failed');
      state = state.copyWith(stage: StageSubmitFailed(_messageFor(e)));
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
    final l = ref.read(localizationsProvider);
    final shareRequest = state.shareRequest;
    final vaultId = state.selectedVaultId;
    final profileId = state.selectedProfileId;

    if (shareRequest == null || vaultId == null || profileId == null) {
      state =
          state.copyWith(stage: StageSubmitFailed(l.shareFlowErrorOccurred));
      return null;
    }

    state = state.copyWith(stage: const StageSubmitting());

    try {
      final outcome = await ref.read(shareCredentialFlowServiceProvider).reject(
            vaultId: vaultId,
            profileId: profileId,
            shareRequest: shareRequest,
          );

      if (!await _launchRedirect(outcome.redirectUri)) {
        throw AppException(
          message: 'Could not open the verifier redirect link.',
          type: AppExceptionType.redirectLaunchFailed,
        );
      }
      state = state.copyWith(
        stage: const StageDismissed(showShareSuccessToast: false),
      );
      return outcome.redirectUri;
    } catch (e, st) {
      ErrorLoggingHandler.instance
          .logError(e, st, reason: 'rejectShareRequest failed');
      state = state.copyWith(stage: StageSubmitFailed(_messageFor(e)));
      return null;
    }
  }

  Future<bool> _shouldShowSuccessToast(Uri? redirectUri) async {
    if (redirectUri == null) return true;
    return !await _launchRedirect(redirectUri);
  }

  Future<bool> _launchRedirect(Uri? redirectUri) async {
    if (redirectUri == null) return true;
    return ref.read(externalRedirectLauncherProvider).open(redirectUri);
  }
}
