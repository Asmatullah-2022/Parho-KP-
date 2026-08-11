import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'content_package_download_service.dart';

/// A [PartialDownloadStore] that keeps in-progress downloads in a TEMPORARY
/// directory on disk (not in RAM). This is the production store: partial bytes
/// are streamed to a `.part` file so a resumed download continues from disk,
/// and large packages never sit entirely in memory on a low-end device.
///
/// The verified package is only imported into the installed location (the
/// SQLite DB + audio dir) after checks pass; the temp file is deleted on
/// success or on a rejected/corrupt download.
class FilePartialDownloadStore implements PartialDownloadStore {
  FilePartialDownloadStore({this.subdir = 'package_downloads'});
  final String subdir;
  Directory? _dir;

  Future<Directory> _tempDir() async {
    if (_dir != null) return _dir!;
    final tmp = await getTemporaryDirectory();
    final dir = Directory(p.join(tmp.path, subdir));
    if (!await dir.exists()) await dir.create(recursive: true);
    _dir = dir;
    return dir;
  }

  Future<File> _partFile(String packageId) async {
    final dir = await _tempDir();
    // Sanitize the id so it is safe as a filename.
    final safe = packageId.replaceAll(RegExp(r'[^A-Za-z0-9_.-]'), '_');
    return File(p.join(dir.path, '$safe.part'));
  }

  @override
  Future<List<int>> read(String packageId) async {
    final file = await _partFile(packageId);
    return await file.exists() ? file.readAsBytes() : const [];
  }

  @override
  Future<void> write(String packageId, List<int> bytes) async {
    final file = await _partFile(packageId);
    await file.writeAsBytes(bytes, flush: true);
  }

  @override
  Future<void> clear(String packageId) async {
    final file = await _partFile(packageId);
    if (await file.exists()) await file.delete();
  }
}
