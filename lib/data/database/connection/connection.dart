import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Opens the on-device SQLite database used for all offline data.
///
/// The database file lives in the app's documents directory so it persists
/// across launches and is available fully offline.
LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'parho_kp.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
