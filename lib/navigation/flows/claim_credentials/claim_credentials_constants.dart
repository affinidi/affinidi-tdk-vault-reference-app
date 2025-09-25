abstract class ClaimCredentialsRoutePath {
  static const base = '/claim';
  static String claimCredentialWithId(String profileId) => '$base/$profileId';
}

abstract class ClaimCredentialsRouteName {
  static const base = 'claim';
}
