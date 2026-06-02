import 'dart:convert';

import 'package:affinidi_tdk_cryptography/affinidi_tdk_cryptography.dart';
import 'package:affinidi_tdk_iota_client/affinidi_tdk_iota_client.dart';
import 'package:affinidi_tdk_vault_flutter_utils/storages/flutter_secure_vault_store.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';

import '../../../infrastructure/exceptions/app_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ssi/ssi.dart';

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

class AppIotaShareResponseService implements IotaShareResponseServiceInterface {
  static const _hdPathTemplate = "m/44'/60'/%ACCOUNT%'/0'/0'";

  final int _accountIndex;
  final FlutterSecureVaultStore _vaultStore;
  final CallbackApi _callbackApi;

  AppIotaShareResponseService({
    required String vaultId,
    required int accountIndex,
    FlutterSecureVaultStore? vaultStore,
    CallbackApi? callbackApi,
  })  : _accountIndex = accountIndex,
        _vaultStore = vaultStore ?? FlutterSecureVaultStore(vaultId),
        _callbackApi = callbackApi ?? AffinidiTdkIotaClient().getCallbackApi();

  Future<IotaShareResponseService> _buildService() async {
    final seed = await _vaultStore.getSeed();
    if (seed == null) {
      throw AppException(
        message: 'No seed found in secure storage.',
        type: AppExceptionType.seedNotFound,
      );
    }

    final wallet = Bip32Wallet.fromSeed(seed);
    final keyPath = _hdPathTemplate.replaceFirst('%ACCOUNT%', '$_accountIndex');
    final keyPair = await wallet.generateKey(
      keyId: keyPath,
      keyType: KeyType.secp256k1,
    );
    final didDocument = DidKey.generateDocument(keyPair.publicKey);
    final signer = DidSigner(
      did: didDocument.id,
      didKeyId: didDocument.verificationMethod.first.id,
      keyPair: keyPair,
      signatureScheme: SignatureScheme.ecdsa_secp256k1_sha256,
    );

    return IotaShareResponseService(
      approveCallbackApi: _callbackApi,
      rejectCallbackApi: _callbackApi,
      signer: signer,
    );
  }

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
    final service = await _buildService();
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
    final service = await _buildService();
    return service.rejectShareResponse(state: state);
  }
}
