import 'package:affinidi_tdk_vault_iota/affinidi_tdk_vault_iota.dart';

abstract interface class IotaShareResponseServiceInterface {
  Future<Uri?> submit({
    required Oid4vpShareRequest shareRequest,
    required ClaimedCredentialsResult matchResult,
    required List<String> selectedCredentialIds,
    required String vaultId,
    required int accountIndex,
  });

  Future<Uri?> reject({
    required Oid4vpShareRequest shareRequest,
    required String vaultId,
    required int accountIndex,
  });
}
