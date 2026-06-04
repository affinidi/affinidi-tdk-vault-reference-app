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
import 'share_credential_page_state.dart';

part 'share_credential_page_controller.g.dart';

String _extractUserMessage(Object e) {
  if (e is TdkException) return e.message;
  if (e is AppException) return e.message;
  final text = e.toString();
  final match = RegExp(r'- Message: (.+)').firstMatch(text);
  if (match != null) return match.group(1)!.trim();
  return text;
}

@riverpod
class ShareCredentialPageController extends _$ShareCredentialPageController {
  String? _selectedVaultId;
  bool _hasValidated = false;

  int _resolveSelectedAccountIndex() {
    final profileId = state.selectedProfileId;
    if (profileId == null) {
      throw AppException(
        message: 'Profile is not selected.',
        type: AppExceptionType.missingProfile,
      );
    }

    final profiles = state.profiles;
    if (profiles == null || profiles.isEmpty) {
      throw AppException(
        message: 'Profiles are not loaded.',
        type: AppExceptionType.missingProfile,
      );
    }

    final profile = profiles.firstWhere(
      (profile) => profile.id == profileId,
      orElse: () => throw AppException(
        message: 'Selected profile was not found in current vault.',
        type: AppExceptionType.missingProfile,
      ),
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
      passphraseError: null,
      isVerifyingPassphrase: false,
      matchResult: null,
      matchError: null,
      isMatchingCredentials: false,
      selectedCredentialIds: const <String>{},
      submitError: null,
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
      } on TdkException catch (_) {
        // 404 = verifier not registered in Affinidi login config; not an error.
      }

      state = state.copyWith(
        shareRequest: result,
        verifierMetadata: verifierMetadata,
      );
    } on TdkException catch (e, st) {
      ErrorLoggingHandler.instance
          .logError(e, st, reason: 'validateRequest failed');
      final message = e.code == TdkExceptionType.invalidOrExpiredJwt.code
          ? 'The share request has expired or is invalid. Please ask the verifier to generate a new request.'
          : 'Failed to validate share request: ${e.message}';
      state = state.copyWith(requestError: message);
    } catch (e, st) {
      ErrorLoggingHandler.instance
          .logError(e, st, reason: 'validateRequest failed');
      state = state.copyWith(requestError: 'Failed to validate share request.');
    }
  }

  Future<void> verifyPassphrase(String passphrase) async {
    final vaultId = state.selectedVaultId;
    if (vaultId == null) return;

    state = state.copyWith(
      isVerifyingPassphrase: true,
      passphraseError: null,
    );

    try {
      await ref.read(vaultServiceProvider.notifier).open(
            vaultId: vaultId,
            password: passphrase,
          );

      final vault = ref.read(vaultServiceProvider).currentVault;
      final profiles = vault != null ? await vault.listProfiles() : <Profile>[];

      state = state.copyWith(
        isVerifyingPassphrase: false,
        profiles: profiles,
        selectedProfileId: profiles.isNotEmpty ? profiles.first.id : null,
      );

      if (profiles.isNotEmpty) {
        Future.microtask(() => matchCredentials(profiles.first.id));
      }
    } catch (e, st) {
      ErrorLoggingHandler.instance
          .logError(e, st, reason: 'verifyPassphrase failed');

      String errorMessage = 'An error occurred';
      if (e is AppException && e.type == AppExceptionType.invalidPassword) {
        errorMessage = 'Wrong passphrase.';
      }

      state = state.copyWith(
        isVerifyingPassphrase: false,
        passphraseError: errorMessage,
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

  Future<void> matchCredentials(String profileId) async {
    final shareRequest = state.shareRequest;
    if (shareRequest == null) return;

    final vaultId = state.selectedVaultId;
    if (vaultId == null) return;

    state = state.copyWith(
        isMatchingCredentials: true, matchResult: null, matchError: null);

    try {
      final vault = ref.read(vaultServiceProvider).currentVault;
      if (vault == null) return;

      final profile = await vault.getProfileById(profileId);
      final storage = profile.defaultCredentialStorage;
      if (storage == null) {
        state = state.copyWith(
          isMatchingCredentials: false,
          matchResult: const ClaimedCredentialsResult(vcsGroups: {}),
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
        isMatchingCredentials: false,
        matchResult: matchResult,
        selectedCredentialIds: matchResult.requiredMatchedVcs
            .map((vc) => vc.id.toString())
            .toSet(),
        isSubmitting: false,
        submitError: null,
      );
    } catch (e, st) {
      ErrorLoggingHandler.instance
          .logError(e, st, reason: 'matchCredentials failed');
      state = state.copyWith(
        isMatchingCredentials: false,
        matchError: 'Failed to load credentials. Please try again.',
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
    state = state.copyWith(selectedCredentialIds: updated, submitError: null);
  }

  void setAutoAllowConsent(bool value) {
    state = state.copyWith(autoAllowConsent: value);
  }

  void selectCredentialForGroup(List<String> groupVcIds, String selectedId) {
    final updated = Set<String>.from(state.selectedCredentialIds);
    updated.removeAll(groupVcIds);
    updated.add(selectedId);
    state = state.copyWith(selectedCredentialIds: updated, submitError: null);
  }

  Future<Uri?> submitSelectedCredentials() async {
    state = state.copyWith(isSubmitting: true, submitError: null);

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

      if (redirectUri != null) {
        await launchUrl(redirectUri, mode: LaunchMode.externalApplication);
      }
      state = state.copyWith(
        isSubmitting: false,
        shouldDismiss: true,
        showShareSuccessToast: redirectUri == null,
      );
      return redirectUri;
    } catch (e, st) {
      ErrorLoggingHandler.instance
          .logError(e, st, reason: 'submitSelectedCredentials failed');
      state = state.copyWith(
        isSubmitting: false,
        submitError: _extractUserMessage(e),
      );
      return null;
    }
  }

  Future<Uri?> rejectShareRequest() async {
    state = state.copyWith(isSubmitting: true, submitError: null);

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
      state = state.copyWith(isSubmitting: false, shouldDismiss: true);
      return redirectUri;
    } catch (e, st) {
      ErrorLoggingHandler.instance
          .logError(e, st, reason: 'rejectShareRequest failed');
      state = state.copyWith(
        isSubmitting: false,
        submitError: _extractUserMessage(e),
      );
      return null;
    }
  }
}
