import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<void> deleteEdgeDatabase(String databaseName) async {
  final directory = await getApplicationDocumentsDirectory();
  final databasePath = path.join(directory.path, databaseName);
  for (final suffix in ['', '-wal', '-shm', '-journal']) {
    final file = File('$databasePath$suffix');
    if (await file.exists()) {
      await file.delete();
    }
  }
}
