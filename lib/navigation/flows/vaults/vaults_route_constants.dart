abstract class VaultsRoutePath {
  static const base = '/vaults';
  static const create = '/vaults/create-vault';
  static const open = '/vaults/open-vault';

  static String openVaultWithId(String vaultId) =>
      '/vaults/open-vault/$vaultId';
}

abstract class VaultsRouteName {
  static const base = 'vaults';
  static const create = 'vaults-create';
  static const open = 'vaults-open';
}
