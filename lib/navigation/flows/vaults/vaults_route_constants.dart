abstract class VaultsRoutePath {
  static const base = '/vaults';
  static const create = '/vaults/create-vault';
  static const open = '/vaults/open-vault';
  static const backup = '/vaults/backup-vault';
  static const restore = '/vaults/restore-vault';

  static String openVaultWithId(String vaultId) =>
      '/vaults/open-vault/$vaultId';
}

abstract class VaultsRouteName {
  static const base = 'vaults';
  static const create = 'vaults-create';
  static const open = 'vaults-open';
  static const backup = 'vaults-backup';
  static const restore = 'vaults-restore';
}
