import 'package:affinidi_tdk_iota_client/affinidi_tdk_iota_client.dart';
import 'package:affinidi_tdk_vault_flutter_utils/storages/flutter_secure_vault_store.dart';
import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';
import 'package:ssi/ssi.dart';

import '../../../infrastructure/exceptions/app_exception.dart';

/// Flutter-specific [IotaShareResponseServiceInterface] implementation.
///
/// Reads the vault seed from [FlutterSecureVaultStore], derives the signing
/// key at the standard HD path for [accountIndex], and delegates VP building
/// and submission to [IotaShareResponseService] from the TDK package.
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
