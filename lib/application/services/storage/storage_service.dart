import 'package:affinidi_tdk_vault/affinidi_tdk_vault.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../infrastructure/exceptions/app_exception.dart';
import '../../../infrastructure/exceptions/file_upload_exception.dart';
import '../vault/vault_service.dart';
import 'base_storage_repository.dart';
import 'file_storage_adapter.dart';
import 'shared_storage_adapter.dart';
import 'storage_service_state.dart';

part 'storage_service.g.dart';

/// Service responsible for managing file storage operations within a vault profile.
///
/// This service provides functionality to:
/// - List files and folders in a directory
/// - Create, rename, and delete folders
/// - Upload and delete files
/// - Access file content
/// - Manage shared storage
///
/// The service supports both VFS (cloud-based) and Edge (local) storage types,
/// automatically handling the differences between storage implementations.
@riverpod
class StorageService extends _$StorageService {
  StorageService() : super();

  FileStorage? _storageRepository;
  SharedStorage? _sharedStorageRepository;
  String? _currentParentNodeId;

  @override
  StorageServiceState build({required String? parentNodeId, required String profileId}) {
    _currentParentNodeId = parentNodeId;
    return StorageServiceState();
  }

  /// Lists all items (files and folders) in the current directory.
  ///
  /// Throws [AppException] if the storage repository cannot be accessed.
  Future<void> listItems({bool isSharedProfile = false}) async {
    try {
      final storageRepository = await _getUnifiedRepository(isSharedProfile: isSharedProfile);
      final folderId = _getFolderId(storageRepository);
      final paginatedList = await storageRepository.getFolder(folderId: folderId);
      state = state.copyWith(items: paginatedList.items);
    } catch (e, st) {
      _handleStorageError(e, st, 'Failed to list items');
    }
  }

  /// Renames a file.
  ///
  /// [itemId] - The ID of the file to rename
  /// [newName] - The new name for the file
  /// [isSharedProfile] - Boolean value to determine if the file is from another profile
  ///
  /// Throws [AppException] if:
  /// - The file cannot be found
  /// - A file with the new name already exists
  /// - The operation fails for other reasons
  Future<void> renameFile({
    required String itemId,
    required String newName,
    bool isSharedProfile = false,
  }) async {
    final storageRepository = await _getUnifiedRepository(isSharedProfile: isSharedProfile);

    try {
      await storageRepository.renameFile(fileId: itemId, newName: newName);
      await listItems(isSharedProfile: isSharedProfile);
    } catch (e, st) {
      _handleStorageError(e, st, 'Failed to rename file');
    }
  }

  /// Creates a new folder in the current directory.
  ///
  /// [folderName] - The name of the folder to create
  ///
  /// Throws [AppException] if:
  /// - A folder with the same name already exists
  /// - The operation fails for other reasons
  Future<void> createFolder({required String folderName, bool isSharedProfile = false}) async {
    final storageRepository = await _getUnifiedRepository(isSharedProfile: isSharedProfile);

    try {
      final parentFolderId = _getParentFolderId(storageRepository);
      await storageRepository.createFolder(parentFolderId: parentFolderId, folderName: folderName);
      await listItems(isSharedProfile: isSharedProfile);
    } catch (e, st) {
      _handleStorageError(e, st, 'Failed to create folder');
    }
  }

  /// Deletes a folder.
  ///
  /// [folderId] - The ID of the folder to delete
  ///
  /// Throws [AppException] if:
  /// - The folder is not empty
  /// - The folder cannot be found
  /// - The operation fails for other reasons
  Future<void> deleteFolder({required String folderId}) async {
    final storageRepository = await _getUnifiedRepository(isSharedProfile: false);

    try {
      await storageRepository.deleteFolder(folderId: folderId);
      await listItems(isSharedProfile: false);
    } catch (e, st) {
      _handleStorageError(e, st, 'Failed to delete folder');
    }
  }

  /// Uploads multiple files to the current directory.
  ///
  /// [files] - List of files to upload
  ///
  /// Throws [FileUploadException] if any files fail to upload.
  /// Throws [AppException] if the upload operation fails completely.
  Future<void> uploadFiles({required List<XFile> files, bool isSharedProfile = false}) async {
    final storageRepository = await _getUnifiedRepository(isSharedProfile: isSharedProfile);
    final parentFolderId = _getParentFolderId(storageRepository);

    try {
      final errors = <String, String>{};

      for (final file in files) {
        try {
          final bytes = await file.readAsBytes();
          await storageRepository.createFile(
            fileName: file.name,
            parentFolderId: parentFolderId,
            data: bytes,
          );
        } catch (e) {
          errors[file.name] = e.toString();
        }
      }

      if (errors.isNotEmpty) {
        throw FileUploadException(
          filesWithErrors: errors,
          total: files.length,
          completed: files.length - errors.length,
        );
      }

      await listItems(isSharedProfile: isSharedProfile);
    } catch (e, st) {
      if (e is FileUploadException) {
        rethrow;
      }
      _handleStorageError(e, st, 'Failed to upload files');
    }
  }

  /// Deletes a file.
  ///
  /// [fileId] - The ID of the file to delete
  /// [itemId] - The item ID (unused parameter, kept for compatibility)
  ///
  /// Throws [AppException] if the file cannot be deleted.
  Future<void> deleteFile({required String fileId, required String itemId}) async {
    final storageRepository = await _getUnifiedRepository(isSharedProfile: false);

    try {
      await storageRepository.deleteFile(fileId: fileId);
      await listItems();
    } catch (e, st) {
      _handleStorageError(e, st, 'Failed to delete file');
    }
  }

  /// Retrieves the content of a file as bytes.
  ///
  /// [fileId] - The ID of the file to retrieve
  /// [isSharedProfile] - Boolean value to determine if the file is from another profile
  ///
  /// Throws [AppException] if the file content cannot be retrieved.
  Future<void> getFileContent({
    required String fileId,
    bool isSharedProfile = false,
  }) async {
    try {
      state = state.copyWith(fileData: null);
      final storageRepository = await _getUnifiedRepository(isSharedProfile: isSharedProfile);
      final data = await storageRepository.getFileContent(fileId: fileId);
      state = state.copyWith(fileData: Uint8List.fromList(data));
    } catch (e, st) {
      _handleStorageError(e, st, 'Failed to retrieve file content');
    }
  }

  /// Renames a folder.
  ///
  /// [folderId] - The ID of the folder to rename
  /// [newName] - The new name for the folder
  ///
  /// Throws [AppException] if:
  /// - A folder with the new name already exists
  /// - The folder cannot be found
  /// - The operation fails for other reasons
  Future<void> renameFolder({
    required String folderId,
    required String newName,
    bool isSharedProfile = false,
  }) async {
    final storageRepository = await _getUnifiedRepository(isSharedProfile: isSharedProfile);

    try {
      await storageRepository.renameFolder(folderId: folderId, newName: newName);
      await listItems(isSharedProfile: isSharedProfile);
    } catch (e, st) {
      _handleStorageError(e, st, 'Failed to rename folder');
    }
  }

  // Private helper methods

  /// Gets the storage repository for the current profile or shared profile
  ///
  Future<BaseStorageRepository> _getUnifiedRepository({required bool isSharedProfile}) async {
    if (isSharedProfile) {
      _sharedStorageRepository ??= await ref.read(_vaultSharedStorageServiceProvider(profileId).future);
      return SharedStorageAdapter(_sharedStorageRepository!);
    } else {
      _storageRepository ??= await ref.read(_vaultStorageServiceProvider(profileId).future);
      return FileStorageAdapter(_storageRepository!);
    }
  }

  /// Determines the appropriate folder ID based on storage type.
  ///
  String? _getFolderId(BaseStorageRepository repository) {
    if (repository.isVFSFileStorage) {
      return _currentParentNodeId ?? profileId;
    } else {
      return _currentParentNodeId;
    }
  }

  /// Determines the appropriate parent folder ID based on storage type.
  String _getParentFolderId(BaseStorageRepository repository) {
    if (repository.isVFSFileStorage) {
      // VFS requires a folderId, use profile ID for root
      return _currentParentNodeId ?? profileId;
    } else {
      // Edge storage can use empty string for root
      return _currentParentNodeId ?? '';
    }
  }

  /// Handles storage-related errors and converts them to AppExceptions.
  void _handleStorageError(dynamic error, StackTrace stackTrace, String operation) {
    if (error is TdkException) {
      Error.throwWithStackTrace(error, stackTrace);
    }

    Error.throwWithStackTrace(
      _makeAppExceptionFromError(error, operation),
      stackTrace,
    );
  }

  /// Converts various error types to AppException.
  AppException _makeAppExceptionFromError(dynamic error, String operation) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return AppException.fromDioException(error);
    }

    return AppException(
      message: '$operation: ${error.toString()}',
      type: AppExceptionType.other,
    );
  }
}

/// Provider that creates a FileStorage instance for a given profile.
final _vaultStorageServiceProvider = FutureProvider.family<FileStorage, String>((ref, profileId) async {
  final vaultServiceState = ref.read(vaultServiceProvider);
  final vault = vaultServiceState.currentVault;

  if (vault == null) {
    throw AppException(
      message: 'Vault not initialized',
      type: AppExceptionType.other,
    );
  }

  final profiles = await vault.listProfiles();
  final profile = profiles.firstWhereOrNull((p) => p.id == profileId);

  if (profile == null) {
    throw AppException(
      message: 'Profile not found in vault',
      type: AppExceptionType.other,
    );
  }

  final fileStorage = profile.defaultFileStorage;
  if (fileStorage == null) {
    throw AppException(
      message: 'File storage not available for profile',
      type: AppExceptionType.other,
    );
  }

  return fileStorage;
}, name: 'vaultStorageServiceProvider');

/// Provider that creates a FileStorage instance for a given profile.
final _vaultSharedStorageServiceProvider = FutureProvider.family<SharedStorage, String>((ref, profileId) async {
  final vaultServiceState = ref.read(vaultServiceProvider);
  final vault = vaultServiceState.currentVault;

  if (vault == null) {
    throw AppException(
      message: 'Vault not initialized',
      type: AppExceptionType.other,
    );
  }

  final profiles = await vault.listProfiles();

  for (final profile in profiles) {
    try {
      final sharedStorage = profile.sharedStorages.firstWhere((s) => s.id == profileId);
      return sharedStorage;
    } catch (e) {
      // Continue to next profile if shared storage not found
      continue;
    }
  }

  throw AppException(
    message: 'Cannot find shared storage',
    type: AppExceptionType.other,
  );
}, name: 'vaultSharedStorageServiceProvider');

/// Provider that returns all shared storages for a given profile.
@riverpod
Future<List<SharedStorage>> sharedStorages(Ref ref, String profileId) async {
  final vaultServiceState = ref.read(vaultServiceProvider);
  final vault = vaultServiceState.currentVault;

  if (vault == null) {
    throw AppException(
      message: 'Vault not initialized',
      type: AppExceptionType.other,
    );
  }

  await vault.ensureInitialized();
  final profiles = await vault.listProfiles();

  final profile = profiles.firstWhere(
    (p) => p.id == profileId,
    orElse: () => throw AppException(
      message: 'Profile not found',
      type: AppExceptionType.other,
    ),
  );

  return profile.sharedStorages;
}

/// Provider that returns a specific shared storage by ID.
@riverpod
Future<SharedStorage> sharedStorageById(Ref ref, String storageId) async {
  final vaultServiceState = ref.read(vaultServiceProvider);
  final vault = vaultServiceState.currentVault;

  if (vault == null) {
    throw AppException(
      message: 'Vault not initialized',
      type: AppExceptionType.other,
    );
  }

  await vault.ensureInitialized();
  final profiles = await vault.listProfiles();

  for (final profile in profiles) {
    try {
      final sharedStorage = profile.sharedStorages.firstWhere((s) => s.id == storageId);
      return sharedStorage;
    } catch (e) {
      // Continue to next profile if shared storage not found
      continue;
    }
  }

  throw AppException(
    message: 'Shared storage not found',
    type: AppExceptionType.other,
  );
}

/// Provider that returns files from a shared storage.
@riverpod
Future<List<dynamic>> sharedStorageFiles(Ref ref, String storageId) async {
  final sharedStorage = await ref.watch(sharedStorageByIdProvider(storageId).future);
  final items = await sharedStorage.getFolder();
  return items.items;
}
