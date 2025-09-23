import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import '../../../infrastructure/db/app_database.dart';
import '../../../infrastructure/providers/file_settings_provider.dart';
import '../../../l10n/app_localizations.dart';
import 'storage_service.dart';

part 'file_upload_service.g.dart';

final filePickerProvider = Provider<FilePicker>((ref) {
  return FilePicker.platform;
});

/// Service for handling file upload operations with consistent validation and settings.
@riverpod
class FileUploadService extends _$FileUploadService {
  @override
  void build() {}

  /// Picks files and uploads them with consistent validation.
  ///
  /// [parentNodeId] - The parent node ID for the storage service
  /// [profileId] - The profile ID for the storage service
  /// [localizations] - Localizations for error messages
  /// [isSharedProfile] - Whether uploading to shared profile storage
  ///
  /// Returns a list of picked files that passed validation, or empty list if cancelled.
  Future<List<XFile>> pickAndValidateFiles({
    required String? parentNodeId,
    required String profileId,
    required AppLocalizations localizations,
    bool isSharedProfile = false,
  }) async {
    final settings = ref.read(fileSettingsProvider(profileId)).value;
    final filePicker = ref.read(filePickerProvider);

    // Use settings if available, otherwise fall back to TDK defaults
    final allowedExtensions = _getAllowedExtensions(settings);

    final result = await filePicker.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (result == null || result.xFiles.isEmpty) {
      return [];
    }

    // Validate files
    final validationResult = await _validateFiles(
      result.xFiles,
      settings,
      allowedExtensions,
      localizations,
    );

    if (validationResult.invalidFiles.isNotEmpty ||
        validationResult.oversizedFiles.isNotEmpty) {
      String msg = '';
      if (validationResult.invalidFiles.isNotEmpty) {
        msg +=
            '${localizations.invalidFormat}: ${validationResult.invalidFiles.join(', ')}. ';
      }
      if (validationResult.oversizedFiles.isNotEmpty) {
        msg +=
            '${localizations.fileTooLarge}: ${validationResult.oversizedFiles.join(', ')}.';
      }
      throw Exception(msg);
    }

    return validationResult.validFiles;
  }

  /// Uploads files using the provided storage service.
  Future<void> uploadFiles({
    required List<XFile> files,
    required String? parentNodeId,
    required String profileId,
    bool isSharedProfile = false,
  }) async {
    final storageService = ref.read(
        storageServiceProvider(parentNodeId: parentNodeId, profileId: profileId)
            .notifier);
    await storageService.uploadFiles(
      files: files,
      isSharedProfile: isSharedProfile,
    );
  }

  /// Gets the allowed file extensions from settings or TDK defaults.
  List<String> _getAllowedExtensions(FileSetting? settings) {
    if (settings?.allowedExtensions != null &&
        settings!.allowedExtensions!.isNotEmpty) {
      return settings.allowedExtensions!
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .toList();
    }

    // Fall back to TDK defaults
    return [
      'jpg',
      'jpeg',
      'pdf',
      'png',
      'txt',
      'gif',
      'doc',
      'docx',
      'xls',
      'xlsx',
      'json',
      'xml',
      'html',
      'css',
      'js',
      'md',
    ];
  }

  /// Validates files for size and extension.
  Future<_FileValidationResult> _validateFiles(
    List<XFile> files,
    FileSetting? settings,
    List<String> allowedExtensions,
    AppLocalizations localizations,
  ) async {
    final invalidFiles = <String>[];
    final oversizedFiles = <String>[];
    final validFiles = <XFile>[];

    for (final file in files) {
      final ext = file.name.split('.').last.toLowerCase();

      if (!allowedExtensions.contains(ext)) {
        invalidFiles.add(file.name);
        continue;
      }

      if (settings?.maxFileSize != null &&
          await file.length() > settings!.maxFileSize!) {
        oversizedFiles.add(file.name);
        continue;
      }

      validFiles.add(file);
    }

    return _FileValidationResult(
      validFiles: validFiles,
      invalidFiles: invalidFiles,
      oversizedFiles: oversizedFiles,
    );
  }
}

/// Result of file validation.
class _FileValidationResult {
  final List<XFile> validFiles;
  final List<String> invalidFiles;
  final List<String> oversizedFiles;

  _FileValidationResult({
    required this.validFiles,
    required this.invalidFiles,
    required this.oversizedFiles,
  });
}
