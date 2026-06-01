import 'dart:convert';

import 'package:affinidi_tdk_cryptography/affinidi_tdk_cryptography.dart';
import 'package:affinidi_tdk_iota_client/affinidi_tdk_iota_client.dart';
import 'package:affinidi_tdk_vault_flutter_utils/storages/flutter_secure_vault_store.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ssi/ssi.dart';

import '../../../infrastructure/exceptions/app_exception.dart';

part 'iota_share_flow_service.g.dart';

const String _affinidiApiBaseUrl = 'https://apse1.api.affinidi.io';

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
    baseUrl: _affinidiApiBaseUrl,
  );
}

/// Factory function type for creating [IotaShareResponseServiceInterface]
/// instances.
///
/// Separating creation into a factory provider makes the response service
/// injectable in tests without requiring a vault-specific provider override.
typedef IotaShareResponseServiceFactory = IotaShareResponseServiceInterface
    Function({
  required String vaultId,
  required int accountIndex,
});

@riverpod
IotaShareResponseServiceFactory iotaShareResponseServiceFactory(Ref ref) {
  return ({required String vaultId, required int accountIndex}) =>
      AppIotaShareResponseService(
        vaultId: vaultId,
        accountIndex: accountIndex,
      );
}

@riverpod
IotaShareResponseServiceInterface iotaShareResponseService(
  Ref ref, {
  required String vaultId,
  required int accountIndex,
}) {
  return ref.watch(iotaShareResponseServiceFactoryProvider)(
    vaultId: vaultId,
    accountIndex: accountIndex,
  );
}

/// Parses a [VerifiableCredential] into a [ParsedVerifiableCredential].
///
/// Tries the LD VC Data Model v1 suite first, then v2.
/// Throws if the credential cannot be parsed by either suite.
ParsedVerifiableCredential<dynamic> parsedCredentialFromVc(
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

const _hdPathTemplate = "m/44'/60'/%ACCOUNT%'/0'/0'";

/// Derives a [DidSigner] from the vault's HD seed for the given [accountIndex].
Future<DidSigner> buildVaultDidSigner({
  required String vaultId,
  required int accountIndex,
}) async {
  final secureStore = FlutterSecureVaultStore(vaultId);
  final seed = await secureStore.getSeed();
  if (seed == null) {
    throw AppException(
      message: 'No seed found in secure storage.',
      type: AppExceptionType.seedNotFound,
    );
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

class AppIotaShareResponseService implements IotaShareResponseServiceInterface {
  final String _vaultId;
  final int _accountIndex;

  AppIotaShareResponseService({
    required String vaultId,
    required int accountIndex,
  })  : _vaultId = vaultId,
        _accountIndex = accountIndex;

  Future<DidSigner> _buildDidSigner() =>
      buildVaultDidSigner(vaultId: _vaultId, accountIndex: _accountIndex);

  @override
  Future<Uri?> submitShareResponse({
    required String state,
    required String nonce,
    required String clientId,
    required String definitionId,
    required List<
            ({
              PDDescriptor descriptor,
              ParsedVerifiableCredential<dynamic> credential,
            })>
        selectedCredentials,
  }) async {
    final signer = await _buildDidSigner();
    final callbackApi = AffinidiTdkIotaClient().getCallbackApi();
    final service = IotaShareResponseService(
      approveCallbackApi: callbackApi,
      rejectCallbackApi: callbackApi,
      signer: signer,
    );
    return service.submitShareResponse(
      state: state,
      nonce: nonce,
      clientId: clientId,
      definitionId: definitionId,
      selectedCredentials: selectedCredentials,
    );
  }

  @override
  Future<Uri?> rejectShareResponse({required String state}) async {
    final signer = await _buildDidSigner();
    final callbackApi = AffinidiTdkIotaClient().getCallbackApi();
    final service = IotaShareResponseService(
      approveCallbackApi: callbackApi,
      rejectCallbackApi: callbackApi,
      signer: signer,
    );
    return service.rejectShareResponse(state: state);
  }
}
