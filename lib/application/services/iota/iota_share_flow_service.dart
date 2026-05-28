import 'dart:convert';

import 'package:affinidi_tdk_cryptography/affinidi_tdk_cryptography.dart';
import 'package:affinidi_tdk_iota_client/affinidi_tdk_iota_client.dart';
import 'package:affinidi_tdk_vault_flutter_utils/storages/flutter_secure_vault_store.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ssi/ssi.dart';

import 'iota_share_response_service_interface.dart';

part 'iota_share_flow_service.g.dart';

@riverpod
ShareFlowServiceInterface iotaShareFlowService(Ref ref) {
  return ShareFlowService(cryptography: CryptographyService());
}

@riverpod
PDClassifier iotaPdClassifier(Ref ref) {
  // validIdvIssuers: trusted IDV issuer DIDs — empty for now (no IDV routing).
  return PDClassifier(validIdvIssuers: []);
}

@riverpod
ShareRequirementsMatcher iotaShareRequirementsMatcher(Ref ref) {
  // No revocation verifier for now — credentials are assumed non-revoked.
  return ShareRequirementsMatcher();
}

@riverpod
VerifierMetadataService iotaVerifierMetadataService(Ref ref) {
  return VerifierMetadataService(
    baseUrl: 'https://apse1.api.affinidi.io',
  );
}

@riverpod
IotaShareResponseServiceInterface iotaShareResponseService(Ref ref) {
  return AppIotaShareResponseService();
}

class AppIotaShareResponseService implements IotaShareResponseServiceInterface {
  static const _hdPathTemplate = "m/44'/60'/%ACCOUNT%'/0'/0'";

  Future<DidSigner> _buildDidSigner({
    required String vaultId,
    required int accountIndex,
  }) async {
    final secureStore = FlutterSecureVaultStore(vaultId);
    final seed = await secureStore.getSeed();
    if (seed == null) {
      throw Exception('No seed found in secure storage.');
    }

    final wallet = Bip32Wallet.fromSeed(seed);
    final keyPath = _hdPathTemplate.replaceFirst('%ACCOUNT%', '$accountIndex');
    final keyPair = await wallet.generateKey(
      keyId: keyPath,
      keyType: KeyType.secp256k1,
    );
    final didDocument = DidKey.generateDocument(keyPair.publicKey);

    return DidSigner(
      did: didDocument.id,
      didKeyId: didDocument.verificationMethod.first.id,
      keyPair: keyPair,
      signatureScheme: SignatureScheme.ecdsa_secp256k1_sha256,
    );
  }

  ParsedVerifiableCredential<dynamic> _toParsedCredential(
    VerifiableCredential vc,
  ) {
    if (vc is ParsedVerifiableCredential<dynamic>) {
      return vc;
    }

    final serialized = jsonEncode(vc.toJson());
    final v1Parsed = LdVcDm1Suite().tryParse(serialized);
    if (v1Parsed != null) {
      return v1Parsed;
    }

    final v2Parsed = LdVcDm2Suite().tryParse(serialized);
    if (v2Parsed != null) {
      return v2Parsed;
    }

    throw Exception(
      'Credential ${vc.id} could not be parsed as linked-data VC data model v1 or v2.',
    );
  }

  @override
  Future<Uri?> submit({
    required Oid4vpShareRequest shareRequest,
    required ClaimedCredentialsResult matchResult,
    required List<String> selectedCredentialIds,
    required String vaultId,
    required int accountIndex,
  }) async {
    final signer = await _buildDidSigner(
      vaultId: vaultId,
      accountIndex: accountIndex,
    );
    final iotaClient = AffinidiTdkIotaClient();
    final callbackApi = iotaClient.getCallbackApi();
    final service = IotaShareResponseService(
      approveCallbackApi: callbackApi,
      rejectCallbackApi: callbackApi,
      signer: signer,
    );

    final selectedIds = selectedCredentialIds.toSet();
    final selectedCredentials = <({
      PDDescriptor descriptor,
      ParsedVerifiableCredential<dynamic> credential
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
        throw Exception(
          'Not enough selected credentials for descriptor ${descriptor.id}. '
          'Required: $requiredCount, selected: ${selectedForDescriptor.length}.',
        );
      }

      for (final vc in selectedForDescriptor) {
        selectedCredentials.add((
          descriptor: descriptor,
          credential: _toParsedCredential(vc),
        ));
      }
    }

    final definitionId =
        shareRequest.presentationDefinition['id']?.toString() ??
            'presentation_definition';

    return service.submitShareResponse(
      state: shareRequest.request.state,
      nonce: shareRequest.request.nonce,
      clientId: shareRequest.request.clientId,
      definitionId: definitionId,
      selectedCredentials: selectedCredentials,
      dataModel: VpDataModel.v1,
    );
  }

  @override
  Future<Uri?> reject({
    required Oid4vpShareRequest shareRequest,
    required String vaultId,
    required int accountIndex,
  }) async {
    final signer = await _buildDidSigner(
      vaultId: vaultId,
      accountIndex: accountIndex,
    );
    final iotaClient = AffinidiTdkIotaClient();
    final callbackApi = iotaClient.getCallbackApi();
    final service = IotaShareResponseService(
      approveCallbackApi: callbackApi,
      rejectCallbackApi: callbackApi,
      signer: signer,
    );

    return service.rejectShareResponse(
      state: shareRequest.request.state,
    );
  }
}
