import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:flutter/foundation.dart';

abstract class BaseStorageRepository {
  bool get isVFSFileStorage;

  Future<void> renameFile({required String fileId, required String newName});
  Future<void> renameFolder(
      {required String folderId, required String newName});
  Future<void> deleteFile({required String fileId});
  Future<void> deleteFolder({required String folderId});
  Future<void> createFile({
    required String fileName,
    required Uint8List data,
    String? parentFolderId,
    void Function(int, int)? onSendProgress,
  });
  Future<void> createFolder(
      {required String parentFolderId, required String folderName});
  Future<List<int>> getFileContent({required String fileId});
  Future<PaginatedList<Item>> getFolder({
    String? folderId,
    int? limit,
    String? exclusiveStartItemId,
    VaultCancelToken? cancelToken,
  });
}
