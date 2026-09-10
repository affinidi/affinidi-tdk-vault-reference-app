import 'package:drift/wasm.dart';

Future<void> deleteEdgeDatabase(String databaseName) async {
  final storage = await WasmDatabase.probe(
    sqlite3Uri: Uri.parse('sqlite3.wasm'),
    driftWorkerUri: Uri.parse('drift_worker.js'),
    databaseName: databaseName,
  );
  for (final database in storage.existingDatabases) {
    if (database.$2 == databaseName) {
      await storage.deleteDatabase(database);
    }
  }
}
