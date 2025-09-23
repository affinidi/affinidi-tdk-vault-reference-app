import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

class FileSettingsNotifier extends StateNotifier<AsyncValue<FileSetting?>> {
  FileSettingsNotifier({required this.profileId, required this.database}) : super(const AsyncValue.loading()) {
    _load();
  }

  final String profileId;
  final AppDatabase database;

  Future<void> _load() async {
    try {
      final settings = await database.getFileSettings(profileId);
      state = AsyncValue.data(settings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> update({int? maxFileSize, String? allowedExtensions}) async {
    state = const AsyncValue.loading();
    try {
      await database.upsertFileSettings(
        profileId: profileId,
        maxFileSize: maxFileSize,
        allowedExtensions: allowedExtensions,
      );
      await _load();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final fileSettingsProvider = StateNotifierProvider.family<FileSettingsNotifier, AsyncValue<FileSetting?>, String>(
  (ref, profileId) => FileSettingsNotifier(
    profileId: profileId,
    database: ref.read(databaseProvider),
  ),
);
