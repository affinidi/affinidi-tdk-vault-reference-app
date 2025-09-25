import 'package:affinidi_tdk_claim_verifiable_credential/oid4vci_claim_verifiable_credential.dart';
import 'package:affinidi_tdk_vault_flutter_utils/storages/flutter_secure_vault_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ssi/ssi.dart';

import '../../../infrastructure/exceptions/app_exception.dart';

import 'claim_credential_repository.dart';

part 'claim_credential_repository_impl.g.dart';

@riverpod
Future<ClaimCredentialRepository> claimCredentialRepository(
  Ref ref,
  String vaultId,
  int accountIndex,
) async {
  final secureStore = FlutterSecureVaultStore(vaultId);
  final seed = await secureStore.getSeed();
  if (seed == null) {
    throw AppException(
      message: 'No seed found in secure storage',
      type: AppExceptionType.seedNotFound,
    );
  }
  final wallet = Bip32Wallet.fromSeed(seed);

  final keyPair = await wallet.generateKey(
    keyId: "m/44'/60'/$accountIndex'/0'/0'",
    keyType: KeyType.secp256k1,
  );
  final didDocument = DidKey.generateDocument(keyPair.publicKey);
  final didSigner = DidSigner(
    did: didDocument.id,
    didKeyId: didDocument.verificationMethod.first.id,
    keyPair: keyPair,
    signatureScheme: SignatureScheme.ecdsa_secp256k1_sha256,
  );

  return ClaimCredentialRepositoryImpl(
    credentialsClient: OID4VCIClaimVerifiableCredentialService(
      didSigner: didSigner,
    ),
  );
}

class ClaimCredentialRepositoryImpl implements ClaimCredentialRepository {
  ClaimCredentialRepositoryImpl({
    required this.credentialsClient,
  });
  final OID4VCIClaimVerifiableCredentialService credentialsClient;

  @override
  Future<OID4VCIClaimContext> getOID4VCIClaimContext(Uri offerUri) async {
    return await credentialsClient.loadCredentialOffer(offerUri);
  }

  @override
  Future<VerifiableCredential> claimCredentials({
    required OID4VCIClaimContext claimContext,
  }) {
    return credentialsClient.claimCredential(
      claimContext: claimContext,
    );
  }
}
