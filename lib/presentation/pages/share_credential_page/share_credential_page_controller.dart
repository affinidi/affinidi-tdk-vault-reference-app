import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ssi/ssi.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../application/services/iota/iota_consent_record_service.dart';
import '../../../application/services/iota/iota_share_flow_service.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../application/services/vaults_manager/vaults_manager_service.dart';
import '../../../infrastructure/exceptions/app_exception.dart';
import '../../../infrastructure/extensions/matched_credentials_result_extensions.dart';
import '../../../infrastructure/extensions/verifiable_credential_extensions.dart';
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

  int _resolveSelectedAccountIndex() => _resolveSelectedProfile().accountIndex;

  IotaShareResponseServiceInterface _readResponseService(String vaultId) {
    final accountIndex = _resolveSelectedAccountIndex();
    return ref.read(
      iotaShareResponseServiceProvider(
        vaultId: vaultId,
        accountIndex: accountIndex,
      ),
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
      final service = ref.read(iotaShareFlowServiceProvider);
      final uri = Uri(queryParameters: {'request': jwt});
      final result = await service.validateOid4vpRequest(uri);

      VerifierClientMetadata? verifierMetadata;
      try {
        final metadataService = ref.read(iotaVerifierMetadataServiceProvider);
        verifierMetadata = await metadataService.fetchVerifierMetadata(
          clientId: result.request.clientId,
          clientMetadata: result.request.clientMetadata,
          clientMetadataUri: result.request.clientMetadataUri,
        );
      } on TdkException catch (e, st) {
        if (e.code != TdkExceptionType.failedToFetchVerifierMetadata.code) {
          rethrow;
        }
        ErrorLoggingHandler.instance.logError(
          e,
          st,
          reason: 'fetchVerifierMetadata failed; continuing without metadata',
        );
      }

      final currentVaultId = ref.read(vaultServiceProvider).currentVaultId;
      final shouldLoadProfilesWithoutPassphrase =
          currentVaultId != null && currentVaultId == state.selectedVaultId;

      state = state.copyWith(
        shareRequest: result,
        verifierMetadata: verifierMetadata,
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

      final listResult = await _fetchAllCredentials(storage);
      if (isStale()) {
        return;
      }
      final allVCs = listResult
          .map((credential) => credential.verifiableCredential)
          .toList();

      final matcher = ref.read(iotaCredentialMatcherServiceProvider);
      final matchResult = await matcher.match(shareRequest, allVCs);
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

      await _tryAutoConsent(
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

  /// Fetches every credential in [storage] by walking the pagination cursor
  /// until the underlying API reports no more pages.
  ///
  /// Returns the full flattened list of [DigitalCredential]s. The presentation
  /// definition matcher needs to evaluate against the entire credential set;
  /// capping at a fixed page size would silently exclude credentials beyond
  /// that page.
  Future<List<DigitalCredential>> _fetchAllCredentials(
    CredentialStorage storage,
  ) async {
    final all = <DigitalCredential>[];
    String? cursor;
    do {
      final page = await storage.listCredentials(exclusiveStartItemId: cursor);
      all.addAll(page.items);
      cursor = page.lastEvaluatedItemId;
    } while (cursor != null);
    return all;
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
  Future<void> _tryAutoConsent({
    required String vaultId,
    required Oid4vpShareRequest shareRequest,
    required MatchedCredentialsResult matchResult,
  }) async {
    try {
      final profile = _resolveSelectedProfile();
      final consentService = ref.read(
        iotaConsentRecordServiceProvider(
          vaultId: vaultId,
          accountIndex: profile.accountIndex,
        ),
      );

      final result = await consentService.tryAutomaticConsent(
        shareRequest: shareRequest,
        matchedCredentials: matchResult,
        verifierMetadata:
            state.verifierMetadata ?? const VerifierClientMetadata(),
        vaultId: vaultId,
      );

      switch (result) {
        case AutoConsentApproved(:final redirectUri):
          var showToast = redirectUri == null;
          if (redirectUri != null) {
            final launched = await launchUrl(
              redirectUri,
              mode: LaunchMode.externalApplication,
            );
            if (!launched) showToast = true;
          }
          state = state.copyWith(
            stage: StageDismissed(showShareSuccessToast: showToast),
          );
        case AutoConsentDeclined():
          // No prior record qualifies — keep StageReadyToShare for
          // the user to confirm interactively.
          break;
      }
    } catch (e, st) {
      ErrorLoggingHandler.instance.logError(
        e,
        st,
        reason: 'tryAutoConsent failed; falling back to interactive share',
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

  /// Persists the consent record for a successful share submission.
  ///
  /// Called after [submitSelectedCredentials] receives a successful response
  /// from the verifier. The `isAutoShareEnabled` flag mirrors the
  /// "auto-allow consent" checkbox; the `requestHash` is computed from
  /// `clientId|vaultId|groupIds` so a future request with the same shape can
  /// be looked up by [IotaConsentRecordService.tryAutomaticConsent].
  ///
  /// Persistence failures are logged but never re-thrown — the share itself
  /// has already succeeded, and a missing consent record only degrades the
  /// auto-allow optimisation on subsequent requests.
  Future<void> _persistConsentRecord({
    required String vaultId,
    required Oid4vpShareRequest shareRequest,
    required List<ParsedVerifiableCredential<dynamic>> selectedCredentials,
  }) async {
    try {
      final profile = _resolveSelectedProfile();
      final consentService = ref.read(
        iotaConsentRecordServiceProvider(
          vaultId: vaultId,
          accountIndex: profile.accountIndex,
        ),
      );

      final claimedVcTypes =
          (selectedCredentials.expand((vc) => vc.type).toSet().toList()..sort())
              .join(',');

      await consentService.saveConsentRecord(
        shareRequest: shareRequest,
        verifierMetadata:
            state.verifierMetadata ?? const VerifierClientMetadata(),
        profileId: profile.id,
        profileName: profile.name,
        vaultId: vaultId,
        sharedVcs: selectedCredentials,
        claimedVcTypesCsv: claimedVcTypes,
        isAutoShareEnabled: state.autoAllowConsent,
        isConsentManagementEnabled: state.isConsentManagementEnabled,
      );
    } catch (e, st) {
      ErrorLoggingHandler.instance.logError(
        e,
        st,
        reason: 'Failed to persist consent record after share',
      );
    }
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

      final selectedCredentialIds =
          state.selectedCredentialIds.toList(growable: false);
      if (selectedCredentialIds.isEmpty) {
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

      final responseService = _readResponseService(vaultId);

      final selectedIds = selectedCredentialIds.toSet();
      final selectedCredentials = <ParsedVerifiableCredential<dynamic>>[];

      for (final group in matchResult.groups) {
        final requiredCount = group.minimumVCsCountToShare;
        final selectedForGroup = group.availableCredentials
            .where((vc) => selectedIds.contains(vc.id.toString()))
            .take(requiredCount)
            .toList(growable: false);

        if (selectedForGroup.length < requiredCount) {
          throw AppException(
            message: l.shareFlowNotEnoughMatchingCredentials,
            type: AppExceptionType.missingVerifiableCredentials,
          );
        }

        for (final vc in selectedForGroup) {
          selectedCredentials.add(vc.toParsedCredential());
        }
      }

      final redirectUri = await responseService.submitShareResponse(
        shareRequest: shareRequest,
        selectedCredentials: selectedCredentials,
        acceptResponseUri: shareRequest.request.acceptResponseUri,
      );

      await _persistConsentRecord(
        vaultId: vaultId,
        shareRequest: shareRequest,
        selectedCredentials: selectedCredentials,
      );

      var showToast = redirectUri == null;
      if (redirectUri != null) {
        final launched =
            await launchUrl(redirectUri, mode: LaunchMode.externalApplication);
        if (!launched) showToast = true;
      }
      state = state.copyWith(
        stage: StageDismissed(showShareSuccessToast: showToast),
      );
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

      final responseService = _readResponseService(vaultId);
      final redirectUri = await responseService.rejectShareResponse(
        shareRequest: shareRequest,
        rejectResponseUri: shareRequest.request.rejectResponseUri,
      );
      if (redirectUri != null) {
        final launched = await launchUrl(
          redirectUri,
          mode: LaunchMode.externalApplication,
        );
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
