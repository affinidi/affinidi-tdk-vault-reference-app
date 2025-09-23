import 'dart:io' as io;
import 'dart:math';

import 'package:affinidi_tdk_vault_edge_drift_provider/affinidi_tdk_vault_edge_drift_provider.dart';
import 'package:cross_file/cross_file.dart';
import 'package:drift/drift.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHolder {
  static final Map<String, Database> _instances = {};

  static Database get(String name, QueryExecutor executor) {
    return _instances.putIfAbsent(name, () => Database(executor));
  }

  static Future<void> closeAll() async {
    for (final db in _instances.values) {
      await db.close();
    }
    _instances.clear();
  }
}

class TestUtils {
  static Future<void> clearAll() async {
    // Clear secure storage
    const secureStorage = FlutterSecureStorage();
    await secureStorage.deleteAll();

    // Close all active Drift databases
    await DatabaseHolder.closeAll();

    // Optionally delete the DB files too
    final dir = await getApplicationDocumentsDirectory();
    for (var file in dir.listSync()) {
      if (file.path.endsWith('.db')) {
        await file.delete();
      }
    }
  }

  static String randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();

    return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  static Future<XFile> createTempXFile(String name, String mimeType) async {
    final dir = await getTemporaryDirectory(); // from path_provider
    final tempFile = io.File('${dir.path}/$name');
    await tempFile.writeAsBytes(Uint8List.fromList([1, 2, 3, 4]));

    return XFile(tempFile.path, name: name, mimeType: mimeType);
  }
}
