import 'dart:typed_data';

import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:affinidi_tdk_vault_data_manager/affinidi_tdk_vault_data_manager.dart';
import 'base_storage_repository.dart';

class FileStorageAdapter implements BaseStorageRepository {
  final FileStorage storage;

  FileStorageAdapter(this.storage);

  @override
  bool get isVFSFileStorage => storage is VFSFileStorage;

  @override
  Future<void> renameFile({required String fileId, required String newName}) =>
      storage.renameFile(fileId: fileId, newName: newName);

  @override
  Future<void> renameFolder({required String folderId, required String newName}) =>
      storage.renameFolder(folderId: folderId, newName: newName);

  @override
  Future<void> deleteFile({required String fileId}) => storage.deleteFile(fileId: fileId);

  @override
  Future<void> deleteFolder({required String folderId}) => storage.deleteFolder(folderId: folderId);

  @override
  Future<void> createFolder({required String parentFolderId, required String folderName}) =>
      storage.createFolder(parentFolderId: parentFolderId, folderName: folderName);

  @override
  Future<List<int>> getFileContent({required String fileId}) => storage.getFileContent(fileId: fileId);

  @override
  Future<void> createFile({
    required String fileName,
    required Uint8List data,
    String? parentFolderId,
    void Function(int p1, int p2)? onSendProgress,
  }) =>
      storage.createFile(
        fileName: fileName,
        data: data,
        parentFolderId: parentFolderId,
      );

  @override
  Future<PaginatedList<Item>> getFolder({
    String? folderId,
    int? limit,
    String? exclusiveStartItemId,
    VaultCancelToken? cancelToken,
  }) =>
      storage.getFolder(
        folderId: folderId,
        limit: limit,
        exclusiveStartItemId: exclusiveStartItemId,
        cancelToken: cancelToken,
      );
}
