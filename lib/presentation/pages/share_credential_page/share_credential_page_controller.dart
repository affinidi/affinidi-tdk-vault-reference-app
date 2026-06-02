import 'dart:developer';

import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ssi/ssi.dart';
import '../../../application/services/iota/iota_share_flow_service.dart';
import '../../../application/services/vault/vault_service.dart';
import '../../../application/services/vaults_manager/vaults_manager_service.dart';
import '../../../infrastructure/exceptions/app_exception.dart';
import '../../../infrastructure/extensions/claimed_credentials_result_extensions.dart';
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

const int _credentialFetchLimit = 100;

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

  String _descriptorSummary(PDDescriptor descriptor) {
    final raw = descriptor.toJson();
    final schema = raw['schema'];
    String schemaSummary = '';

    if (schema is List) {
      final uris = schema
          .whereType<Map>()
          .map((item) => item['uri'])
          .whereType<String>()
          .where((uri) => uri.trim().isNotEmpty)
          .toList(growable: false);
      if (uris.isNotEmpty) {
        schemaSummary = ' | schema=${uris.join(', ')}';
      }
    }

    final label = descriptor.name?.trim();
    if (label != null && label.isNotEmpty) {
      return '$label (id=${descriptor.id})$schemaSummary';
    }

    return 'id=${descriptor.id}$schemaSummary';
  }

  String _availableVcSummary(VerifiableCredential vc) {
    final types =
        vc.type.map((item) => item.toString()).toList(growable: false);
    final typeSummary = types.isEmpty ? 'unknown-type' : types.join(', ');
    final id = vc.id;
    final validUntil = vc.validUntil;
    final validUntilSummary =
        validUntil == null ? 'none' : validUntil.toUtc().toIso8601String();

    final vcJson = vc.toJson();
    final rawContext = vcJson['@context'];
    final contextSummary = rawContext is List
        ? rawContext.map((contextEntry) => contextEntry.toString()).join(', ')
        : rawContext?.toString() ?? 'none';

    String credentialSchemaId = 'none';
    final credentialSchema = vcJson['credentialSchema'];
    if (credentialSchema is Map && credentialSchema['id'] != null) {
      credentialSchemaId = credentialSchema['id'].toString();
    }

    return 'id=$id | type=$typeSummary | validUntil=$validUntilSummary '
        '| context=$contextSummary | credentialSchema.id=$credentialSchemaId';
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
      } on TdkException catch (e) {
        // 404 = verifier not registered in Affinidi login config; not an error.
        log(
          'clientMetadata: not found for clientId=${result.request.clientId} (${e.code})',
          name: 'ShareCredentialPageController',
        );
      }
      if (verifierMetadata != null) {
        log(
          'clientMetadata: name=${verifierMetadata.name} '
          '| origin=${verifierMetadata.origin} '
          '| logo=${verifierMetadata.logo} '
          '| domainVerified=${verifierMetadata.domainVerified}',
          name: 'ShareCredentialPageController',
        );
      }
      log('purpose     : ${result.purpose}',
          name: 'ShareCredentialPageController');
      log('presentationDefinition: ${result.presentationDefinition}',
          name: 'ShareCredentialPageController');

      state = state.copyWith(
        shareRequest: result,
        verifierMetadata: verifierMetadata,
      );
    } on TdkException catch (e, st) {
      log('validateRequest failed: $e', name: 'ShareCredentialPageController');
      log('$st', name: 'ShareCredentialPageController');
      final message = e.code == TdkExceptionType.invalidOrExpiredJwt.code
          ? 'The share request has expired or is invalid. Please ask the verifier to generate a new request.'
          : 'Failed to validate share request: ${e.message}';
      state = state.copyWith(requestError: message);
    } catch (e, st) {
      log('validateRequest failed: $e', name: 'ShareCredentialPageController');
      log('$st', name: 'ShareCredentialPageController');
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
      log('verifyPassphrase failed: $e', name: 'ShareCredentialPageController');
      log('$st', name: 'ShareCredentialPageController');

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
        log(
          'Profile VC store: <none> (defaultCredentialStorage is null)',
          name: 'ShareCredentialPageController',
        );
        state = state.copyWith(
          isMatchingCredentials: false,
          matchResult: const ClaimedCredentialsResult(vcsGroups: {}),
        );
        return;
      }

      final listResult = await storage.listCredentials(limit: _credentialFetchLimit);
      final allVCs = listResult.items
          .map((credential) => credential.verifiableCredential)
          .toList();

      final classifier = ref.read(iotaPdClassifierProvider);
      final requirements =
          classifier.classify(shareRequest.presentationDefinition);

      log('=== Requested vs Profile VCs ===',
          name: 'ShareCredentialPageController');
      log(
        'Reference time (UTC): ${DateTime.now().toUtc().toIso8601String()}',
        name: 'ShareCredentialPageController',
      );
      final requestedDescriptors = <PDDescriptor>[
        ...requirements.claimedDescriptors,
        ...requirements.zpdLinkedDescriptors,
        ...requirements.idvDescriptors,
      ];
      if (requestedDescriptors.isEmpty) {
        log('Requested VC: <none>', name: 'ShareCredentialPageController');
      } else {
        for (final descriptor in requestedDescriptors) {
          log(
            'Requested VC: ${_descriptorSummary(descriptor)}',
            name: 'ShareCredentialPageController',
          );
        }
      }

      log('Profile VC count: ${allVCs.length}',
          name: 'ShareCredentialPageController');

      if (allVCs.isEmpty) {
        log('Profile VC: <none>', name: 'ShareCredentialPageController');
      } else {
        for (final vc in allVCs) {
          log(
            'Profile VC: ${_availableVcSummary(vc)}',
            name: 'ShareCredentialPageController',
          );
        }
      }

      final matcher = ref.read(iotaShareRequirementsMatcherProvider);
      final matchResult = await matcher.match(requirements, allVCs);

      for (final entry in matchResult.vcsGroups.entries) {
        final descriptor = entry.key;
        final group = entry.value;
        final available = group.allAvailableVCs;
        final unavailable =
            group.matchedVCs.whereType<VcUnavailable>().toList();

        log(
          'Requested VC (descriptor match): ${_descriptorSummary(descriptor)}',
          name: 'ShareCredentialPageController',
        );

        if (available.isEmpty) {
          log('Matched VC: <none>', name: 'ShareCredentialPageController');
        } else {
          for (final item in available) {
            log(
              'Matched VC: ${_availableVcSummary(item.vc)}',
              name: 'ShareCredentialPageController',
            );
          }
        }

        for (final item in unavailable) {
          final bestMatch = item.bestMatchVc;
          final bestMatchSummary = bestMatch == null
              ? ''
              : ' | bestMatch=${_availableVcSummary(bestMatch)}';
          log(
            'Unavailable VC: reason=${item.reason.name}$bestMatchSummary',
            name: 'ShareCredentialPageController',
          );
        }
      }

      state = state.copyWith(
        isMatchingCredentials: false,
        matchResult: matchResult,
        selectedCredentialIds: matchResult.requiredMatchedVcs
            .map((vc) => vc.id.toString())
            .toSet(),
        isSubmitting: false,
        submitError: null,
      );

      log('=== Match result ===', name: 'ShareCredentialPageController');
      log('isEnoughVCsAvailableToShare: ${matchResult.isEnoughVCsAvailableToShare}',
          name: 'ShareCredentialPageController');
      log('availableCredentials: ${matchResult.availableCredentials.length}',
          name: 'ShareCredentialPageController');
    } catch (e, st) {
      log('matchCredentials failed: $e', name: 'ShareCredentialPageController');
      log('$st', name: 'ShareCredentialPageController');
      state = state.copyWith(
        isMatchingCredentials: false,
        matchError: 'Failed to load credentials. Please try again.',
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

    state = state.copyWith(isSubmitting: true, submitError: null);

    try {
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
            credential: parsedCredentialFromVc(vc),
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

      state = state.copyWith(isSubmitting: false);
      return redirectUri;
    } catch (e, st) {
      log('submitSelectedCredentials failed: $e',
          name: 'ShareCredentialPageController');
      log('$st', name: 'ShareCredentialPageController');
      state = state.copyWith(
        isSubmitting: false,
        submitError: _extractUserMessage(e),
      );
      rethrow;
    }
  }

  Future<Uri?> rejectShareRequest() async {
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

    state = state.copyWith(isSubmitting: true, submitError: null);

    try {
      final responseService = _readResponseService(vaultId);
      final redirectUri = await responseService.rejectShareResponse(
        state: shareRequest.request.state,
      );
      state = state.copyWith(isSubmitting: false);
      return redirectUri;
    } catch (e, st) {
      log('rejectShareRequest failed: $e',
          name: 'ShareCredentialPageController');
      log('$st', name: 'ShareCredentialPageController');
      state = state.copyWith(
        isSubmitting: false,
        submitError: _extractUserMessage(e),
      );
      rethrow;
    }
  }
}
