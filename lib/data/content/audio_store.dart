import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Stores a package's offline audio files on disk and resolves a lesson's
/// stored `audioAsset` (a package-namespaced relative path such as
/// `grade5_math_ur_v1/audio/lesson_100.mp3`) to an absolute file path for
/// playback.
///
/// Behind an interface so the file-based production implementation stays out of
/// unit tests, which use the in-memory variant.
abstract class AudioStore {
  /// Persists all [files] (keyed by in-package path, e.g. `audio/x.mp3`) for
  /// [packageId]. Writes stream to disk — audio is never held in RAM long-term.
  Future<void> saveAll(String packageId, Map<String, List<int>> files);

  /// Resolves a stored `audioAsset` to a playable absolute path, or null if the
  /// file is not present.
  Future<String?> resolve(String audioAsset);

  /// Removes all stored audio for [packageId] (e.g. on uninstall).
  Future<void> clear(String packageId);
}

/// File-based audio store under the app's documents directory. Used in
/// production. Streams bytes to disk and never preloads audio into memory.
class FileAudioStore implements AudioStore {
  FileAudioStore({this.subdir = 'package_audio'});
  final String subdir;
  Directory? _root;

  Future<Directory> _rootDir() async {
    if (_root != null) return _root!;
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, subdir));
    if (!await dir.exists()) await dir.create(recursive: true);
    _root = dir;
    return dir;
  }

  @override
  Future<void> saveAll(
      String packageId, Map<String, List<int>> files) async {
    if (files.isEmpty) return;
    final root = await _rootDir();
    final safeId = _sanitizeSegment(packageId);
    for (final entry in files.entries) {
      final target =
          p.normalize(p.join(root.path, safeId, entry.key));
      // Defense-in-depth: never write outside the store root even if a path
      // slipped through validation.
      if (!p.isWithin(root.path, target)) continue;
      final file = File(target);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(entry.value, flush: true);
    }
  }

  @override
  Future<String?> resolve(String audioAsset) async {
    if (audioAsset.isEmpty) return null;
    final root = await _rootDir();
    final path = p.normalize(p.join(root.path, audioAsset));
    // Never resolve a path that escapes the store root.
    if (!p.isWithin(root.path, path)) return null;
    return await File(path).exists() ? path : null;
  }

  /// Removes path separators / `..` from a single path segment.
  String _sanitizeSegment(String s) =>
      s.replaceAll(RegExp(r'[^A-Za-z0-9_.-]'), '_');

  @override
  Future<void> clear(String packageId) async {
    final root = await _rootDir();
    final dir = Directory(p.join(root.path, packageId));
    if (await dir.exists()) await dir.delete(recursive: true);
  }
}

/// In-memory audio store for tests: records saved files and resolves to a
/// pseudo path so playback logic can be exercised without a filesystem.
class InMemoryAudioStore implements AudioStore {
  final Map<String, List<int>> _files = {}; // audioAsset -> bytes

  Map<String, List<int>> get files => Map.unmodifiable(_files);

  @override
  Future<void> saveAll(
      String packageId, Map<String, List<int>> files) async {
    for (final e in files.entries) {
      _files['$packageId/${e.key}'] = e.value;
    }
  }

  @override
  Future<String?> resolve(String audioAsset) async =>
      _files.containsKey(audioAsset) ? 'memory://$audioAsset' : null;

  @override
  Future<void> clear(String packageId) async {
    _files.removeWhere((k, _) => k.startsWith('$packageId/'));
  }
}
