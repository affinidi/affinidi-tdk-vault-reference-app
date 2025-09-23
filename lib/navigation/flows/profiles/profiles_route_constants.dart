abstract class ProfilesRoutePath {
  static const base = '/vaults/profiles';
  static const profileId = '/:id';
  static const profileSharingTest = '/vaults/profiles/profiles-sharing-test';
  static const sharing = 'sharing';
  static const settings = 'settings';
  static const myFiles = 'files';
  static const myCredentials = 'my_credentials';
  static const shared = 'shared';
  static const preview = 'preview';
  static const sharedProfileId = ':sharedProfileId';
  static const sharedProfilePath = 'shared/$sharedProfileId';
  static const sharedProfileFiles = 'files';
  static const sharedProfileCredentials = 'credentials';

  static String profileDetail(String id) => '$base/$id';
  static String profileSettings(String id) => '$base/$id/$settings';
  static String profileMyFiles(String id) => '$base/$id/$myFiles';
  static String profileMyCredentials(String id) => '$base/$id/$myCredentials';
  static String profileShared(String id) => '$base/$id/$shared';
  static String profileSharing(String id) => '$base/$id/$sharing';
  static String profileFilePreview(String id, String nodeId) => '$base/$id/$myFiles/$preview/$nodeId';
  static String sharedProfileFilePreview(String id, String nodeId) => '$base/$id/$shared/$myFiles/$preview/$nodeId';
  static String profileSharedProfileDetailsFiles(String profileId, String sharedProfileId) =>
      '$base/$profileId/$shared/$sharedProfileId/files';
  static String profileSharedProfileDetailsFolderPath(String profileId, String sharedProfileId, String folderId) =>
      '$base/$profileId/$shared/$sharedProfileId/files?folder=$folderId';
}

abstract class ProfilesRouteName {
  static const base = 'profiles';
  static const profileDetail = 'profile-detail';
  static const profileSharingTest = 'profile-sharing-test';
  static const profileSharing = 'profile-sharing';

  static const profileMyFiles = 'profile-my-files';
  static const profileMyCredentials = 'profile-my-credentials';
  static const profileShared = 'profile-shared';
  static const profileSettings = 'profile-settings';

  static const sharedProfileDetails = 'shared-profile-details';
  static const sharedProfileFiles = 'shared-profile-files';
}

abstract class ProfilesRouteParams {
  static const id = 'id';
  static const sharedProfileId = 'sharedProfileId';
  static const nodeId = 'nodeId';
  static const profileId = 'profileId';
  static const vaultId = 'vaultId';
}
