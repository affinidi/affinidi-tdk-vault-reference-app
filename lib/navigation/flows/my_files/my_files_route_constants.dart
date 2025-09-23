abstract class MyFilesRoutePath {
  static String profileFiles(String profileId) => '/vaults/profiles/$profileId/files';
  static String filePreview(String profileId, String nodeId) => '/vaults/profiles/$profileId/files/preview/$nodeId';
  static String folderPath(String profileId, String folderId) => '/vaults/profiles/$profileId/files?folder=$folderId';
}

abstract class MyFilesRouteName {
  static const base = 'profile-my-files';
  static const folder = 'profile-my-files-folder';
  static const preview = 'profile-files-preview';
  static const previewInFolder = 'profile-files-preview-in-folder';
}
