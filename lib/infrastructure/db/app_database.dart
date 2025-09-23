import 'package:affinidi_tdk_vault_edge_drift_provider/affinidi_tdk_vault_edge_drift_provider.dart';
import 'package:drift/drift.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class DatabaseConstants {
  static const int globalFileSettingsId = 1;
}

class SharedProfileAccess extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get receiverDid => text()();
  TextColumn get profileId => text()();
  TextColumn get accessLevel => text()();
}

class FileSettings extends Table {
  IntColumn get id => integer().withDefault(Constant(DatabaseConstants.globalFileSettingsId))();
  IntColumn get maxFileSize => integer().nullable()();
  TextColumn get allowedExtensions => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [SharedProfileAccess, FileSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());
  static AppDatabase? _instance;
  factory AppDatabase() => _instance ??= AppDatabase._internal();

  @override
  int get schemaVersion => 1;

  Future<List<SharedProfileAccessData>> getAllAccesses() => select(sharedProfileAccess).get();
  Future<int> addAccess(SharedProfileAccessCompanion entry) => into(sharedProfileAccess).insert(entry);
  Future<int> deleteAccess(int id) => (delete(sharedProfileAccess)..where((tbl) => tbl.id.equals(id))).go();
  Future<void> clearAll() => delete(sharedProfileAccess).go();

  Stream<List<SharedProfileAccessData>> watchAllAccesses() => select(sharedProfileAccess).watch();

  Future<FileSetting?> getFileSettings(String profileId) async {
    final globalSettings = await select(fileSettings).getSingleOrNull();
    if (globalSettings?.allowedExtensions == null) return null;

    try {
      final profileSettingsMap = jsonDecode(globalSettings!.allowedExtensions!) as Map<String, dynamic>;
      final profileSettings = profileSettingsMap[profileId];

      if (profileSettings != null) {
        return FileSetting(
          id: globalSettings.id,
          maxFileSize: profileSettings['maxFileSize'] as int?,
          allowedExtensions: profileSettings['allowedExtensions'] as String?,
        );
      }
    } catch (e) {
      debugPrint('FileSettings: JSON parsing failed for profile $profileId: $e');
    }

    return null;
  }

  Future<void> upsertFileSettings({
    required String profileId,
    int? maxFileSize,
    String? allowedExtensions,
  }) async {
    final existingSettings = await select(fileSettings).getSingleOrNull();
    Map<String, dynamic> profileSettingsMap = {};

    if (existingSettings?.allowedExtensions != null) {
      try {
        profileSettingsMap = jsonDecode(existingSettings!.allowedExtensions!) as Map<String, dynamic>;
      } catch (e) {
        profileSettingsMap = {};
      }
    }

    profileSettingsMap[profileId] = {
      'maxFileSize': maxFileSize,
      'allowedExtensions': allowedExtensions,
    };

    final newAllowedExtensions = jsonEncode(profileSettingsMap);

    if (existingSettings != null) {
      await (update(fileSettings)..where((tbl) => tbl.id.equals(DatabaseConstants.globalFileSettingsId))).write(
        FileSettingsCompanion(
          maxFileSize: Value(existingSettings.maxFileSize),
          allowedExtensions: Value(newAllowedExtensions),
        ),
      );
    } else {
      await into(fileSettings).insert(
        FileSettingsCompanion(
          id: Value(DatabaseConstants.globalFileSettingsId),
          maxFileSize: Value(maxFileSize),
          allowedExtensions: Value(newAllowedExtensions),
        ),
      );
    }
  }

  Future<void> deleteFileSettings(String profileId) async {
    final existingSettings = await select(fileSettings).getSingleOrNull();
    if (existingSettings?.allowedExtensions == null) return;

    try {
      final profileSettingsMap = jsonDecode(existingSettings!.allowedExtensions!) as Map<String, dynamic>;
      profileSettingsMap.remove(profileId);

      final newAllowedExtensions = profileSettingsMap.isEmpty ? null : jsonEncode(profileSettingsMap);

      await (update(fileSettings)..where((tbl) => tbl.id.equals(DatabaseConstants.globalFileSettingsId))).write(
        FileSettingsCompanion(
          maxFileSize: Value(existingSettings.maxFileSize),
          allowedExtensions: Value(newAllowedExtensions),
        ),
      );
    } catch (e) {
      debugPrint('FileSettings: JSON parsing failed for profile $profileId: $e');
    }
  }

  Future<void> closeDb() => close();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (kIsWeb) {
      final database = await DatabaseConfig.createDatabase(
        databaseName: 'app_database',
      );
      return database.executor;
    } else {
      final documentsDir = await getApplicationDocumentsDirectory();
      final database = await DatabaseConfig.createDatabase(
        databaseName: 'app_database',
        directory: documentsDir.path,
      );
      return database.executor;
    }
  });
}
