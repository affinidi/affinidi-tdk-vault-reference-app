import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ssi/ssi.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../application/services/iota/iota_share_flow_service.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../application/services/vaults_manager/vaults_manager_service.dart';
import '../../../infrastructure/exceptions/app_exception.dart';
import '../../../infrastructure/extensions/claimed_credentials_result_extensions.dart';
import '../../../infrastructure/extensions/veryfiable_credential_extensions.dart';
import '../../../infrastructure/loggers/error_logger/error_logging_handler.dart';
import '../../../infrastructure/providers/localizations_provider.dart';
import 'share_credential_page_state.dart';

part 'share_credential_page_controller.g.dart';

@riverpod
class ShareCredentialPageController extends _$ShareCredentialPageController {
  String? _selectedVaultId;
  bool _hasValidated = false;

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

  int _resolveSelectedAccountIndex() {
    final profileId =
        state.selectedProfileId ?? _missingProfile('Profile is not selected.');

    final profiles = state.profiles;
    if (profiles == null || profiles.isEmpty) {
      _missingProfile('Profiles are not loaded.');
    }

    final profile = profiles.firstWhere(
      (profile) => profile.id == profileId,
      orElse: () =>
          _missingProfile('Selected profile was not found in current vault.'),
    );

    return profile.accountIndex;
  }

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
    final vaultRegistry = ref.watch(
      vaultsManagerServiceProvider.select((state) => state.vaultRegistry),
    );

    if (_selectedVaultId == null && vaultRegistry.isNotEmpty) {
      _selectedVaultId = vaultRegistry.keys.first;
    }

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

  void selectVault(String vaultId) {
    _selectedVaultId = vaultId;
    state = state.copyWith(
      selectedVaultId: vaultId,
      profiles: null,
      selectedProfileId: null,
      matchResult: null,
      selectedCredentialIds: const <String>{},
      stage: const StageAwaitingPassphrase(),
    );
  }

  Future<void> validateRequest() async {
    final jwt = state.requestJwt;
    if (jwt.isEmpty) return;

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

      state = state.copyWith(
        shareRequest: result,
        verifierMetadata: verifierMetadata,
        stage: const StageAwaitingPassphrase(),
      );
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

      state = state.copyWith(
        profiles: profiles,
        selectedProfileId: profiles.isNotEmpty ? profiles.first.id : null,
        stage: const StageAwaitingProfile(),
      );

      if (profiles.isNotEmpty) {
        Future.microtask(() => matchCredentials(profiles.first.id));
      }
    } catch (e, st) {
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

    state = state.copyWith(
      stage: const StageMatchingCredentials(),
      matchResult: null,
    );

    try {
      final vault = ref.read(vaultServiceProvider).currentVault;
      if (vault == null) return;

      final profile = await vault.getProfileById(profileId);
      final storage = profile.defaultCredentialStorage;
      if (storage == null) {
        state = state.copyWith(
          matchResult: const ClaimedCredentialsResult(vcsGroups: {}),
          stage: const StageReadyToShare(),
        );
        return;
      }

      final listResult = await _fetchAllCredentials(storage);
      final allVCs = listResult
          .map((credential) => credential.verifiableCredential)
          .toList();

      final classifier = ref.read(iotaPdClassifierProvider);
      final requirements =
          classifier.classify(shareRequest.presentationDefinition);

      final matcher = ref.read(iotaShareRequirementsMatcherProvider);
      final matchResult = await matcher.match(requirements, allVCs);

      state = state.copyWith(
        matchResult: matchResult,
        selectedCredentialIds: matchResult.requiredMatchedVcs
            .map((vc) => vc.id.toString())
            .toSet(),
        stage: const StageReadyToShare(),
      );
    } catch (e, st) {
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

  void selectCredentialForGroup(List<String> groupVcIds, String selectedId) {
    final updated = Set<String>.from(state.selectedCredentialIds);
    updated.removeAll(groupVcIds);
    updated.add(selectedId);
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
    state = state.copyWith(stage: const StageSubmitting());

    try {
      final shareRequest = state.shareRequest;
      final matchResult = state.matchResult;
      if (shareRequest == null || matchResult == null) {
        throw AppException(
          message: 'Share request is not ready.',
          type: AppExceptionType.missingRequiredData,
        );
      }

      final selectedCredentialIds =
          state.selectedCredentialIds.toList(growable: false);
      final hasSelected = matchResult.requiredMatchedVcs.any(
        (vc) => selectedCredentialIds.contains(vc.id.toString()),
      );
      if (!hasSelected) {
        throw AppException(
          message: 'Select at least one credential.',
          type: AppExceptionType.missingVerifiableCredentials,
        );
      }

      final vaultId = state.selectedVaultId;
      if (vaultId == null) {
        throw AppException(
          message: 'Vault is not selected.',
          type: AppExceptionType.missingVaultId,
        );
      }

      final responseService = _readResponseService(vaultId);

      final selectedIds = selectedCredentialIds.toSet();
      final selectedCredentials = <({
        PDDescriptor descriptor,
        ParsedVerifiableCredential<dynamic> credential,
      })>[];

      for (final entry in matchResult.vcsGroups.entries) {
        final descriptor = entry.key;
        final group = entry.value;
        final requiredCount = group.minimumVCsCountToShare;
        final selectedForDescriptor = group.allAvailableVCs
            .map((item) => item.vc)
            .where((vc) => selectedIds.contains(vc.id.toString()))
            .take(requiredCount)
            .toList(growable: false);

        if (selectedForDescriptor.length < requiredCount) {
          throw AppException(
            message: 'Not enough credentials for descriptor ${descriptor.id}. '
                'Required: $requiredCount, selected: ${selectedForDescriptor.length}.',
            type: AppExceptionType.missingVerifiableCredentials,
          );
        }

        for (final vc in selectedForDescriptor) {
          selectedCredentials.add((
            descriptor: descriptor,
            credential: vc.toParsedCredential(),
          ));
        }
      }

      final definitionId =
          shareRequest.presentationDefinition['id']?.toString() ??
              'presentation_definition';

      final redirectUri = await responseService.submitShareResponse(
        state: shareRequest.request.state,
        nonce: shareRequest.request.nonce,
        clientId: shareRequest.request.clientId,
        definitionId: definitionId,
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
      final shareRequest = state.shareRequest;
      if (shareRequest == null) {
        throw AppException(
          message: 'Share request is not ready.',
          type: AppExceptionType.missingRequiredData,
        );
      }

      final vaultId = state.selectedVaultId;
      if (vaultId == null) {
        throw AppException(
          message: 'Vault is not selected.',
          type: AppExceptionType.missingVaultId,
        );
      }

      final responseService = _readResponseService(vaultId);
      final redirectUri = await responseService.rejectShareResponse(
        state: shareRequest.request.state,
      );
      if (redirectUri != null) {
        await launchUrl(redirectUri, mode: LaunchMode.externalApplication);
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
