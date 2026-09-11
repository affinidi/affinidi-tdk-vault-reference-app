import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';

abstract interface class ShareVaultSession {
  bool isOpen(String vaultId);

  Future<void> unlock({required String vaultId, required String password});

  Future<List<Profile>> loadProfiles(String vaultId);

  List<Profile> get profiles;
}
