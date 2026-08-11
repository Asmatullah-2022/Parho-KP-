import 'package:disk_space_plus/disk_space_plus.dart';

import 'content_package_download_service.dart' show StorageProbe;

/// Reads the device's free space, in **megabytes** (the unit `disk_space_plus`
/// reports). Injectable so tests never touch the platform channel.
typedef FreeMegabytesReader = Future<double?> Function();

/// Real free-space detection for the package download pre-check.
///
/// Backed by `disk_space_plus` (a `statfs`-style query on the app's storage —
/// no extra Android permission required). Converts the plugin's megabytes to
/// bytes and feeds the existing [StorageProbe] abstraction. If free-space
/// detection is unavailable on the platform (or throws), it returns null
/// ("unknown"), and the download pre-check is safely skipped rather than
/// guessing — the app never blocks a download on a bad reading.
class DeviceStorageProbe implements StorageProbe {
  DeviceStorageProbe({FreeMegabytesReader? reader})
      : _reader = reader ?? (() => DiskSpacePlus().getFreeDiskSpace);

  final FreeMegabytesReader _reader;

  @override
  Future<int?> freeBytes() async {
    try {
      final mb = await _reader();
      if (mb == null || mb < 0) return null;
      return (mb * 1024 * 1024).round();
    } catch (_) {
      // Plugin/platform unavailable → unknown (safe fallback).
      return null;
    }
  }
}
