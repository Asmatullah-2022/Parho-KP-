import 'dart:async';

import '../database/app_database.dart';
import 'content_importer.dart';
import 'content_validation.dart';
import 'connectivity.dart';
import 'download_http_client.dart';
import 'package_manifest.dart';
import 'package_verifier.dart';
import 'package_zip_reader.dart';

/// Cooperative cancellation for an in-flight download.
class CancelToken {
  bool _canceled = false;
  bool get isCanceled => _canceled;
  void cancel() => _canceled = true;
}

/// Keeps partially-downloaded bytes so a paused/failed download can resume
/// instead of restarting. Behind an interface so the app can persist to disk
/// while tests keep it in memory.
abstract class PartialDownloadStore {
  Future<List<int>> read(String packageId);
  Future<void> write(String packageId, List<int> bytes);
  Future<void> clear(String packageId);
}

/// Default in-memory partial store.
class InMemoryPartialStore implements PartialDownloadStore {
  final Map<String, List<int>> _partials = {};
  @override
  Future<List<int>> read(String packageId) async =>
      _partials[packageId] ?? const [];
  @override
  Future<void> write(String packageId, List<int> bytes) async =>
      _partials[packageId] = bytes;
  @override
  Future<void> clear(String packageId) async => _partials.remove(packageId);
}

/// Reports available storage where practical. Returning null means "unknown" —
/// the storage pre-check is then skipped rather than guessed.
abstract class StorageProbe {
  Future<int?> freeBytes();
}

/// Default probe: storage size unknown (skips the pre-check). A production build
/// can implement this against the platform.
class UnknownStorageProbe implements StorageProbe {
  const UnknownStorageProbe();
  @override
  Future<int?> freeBytes() async => null;
}

/// Supplies the public key used to verify package signatures. In development
/// this comes from the mock host; in production from `CatalogConfig`.
abstract class PublicKeyProvider {
  Future<String> publicKeyBase64();
}

/// A fixed public key (production: value from CatalogConfig).
class FixedPublicKey implements PublicKeyProvider {
  const FixedPublicKey(this.value);
  final String value;
  @override
  Future<String> publicKeyBase64() async => value;
}

/// The result of a download + install attempt.
class PackageInstallOutcome {
  const PackageInstallOutcome({required this.phase, this.error = DownloadError.none});
  final DownloadPhase phase;
  final DownloadError error;

  bool get installed => phase == DownloadPhase.installed;
}

/// Downloads, verifies, and installs a content package — safely and offline
/// after the bytes arrive. Enforces the full pipeline:
///
///   check app version → connectivity/Wi-Fi → storage → download (resumable,
///   retry, cancel) → verify checksum → verify signature → validate structure →
///   import into the local DB → mark installed → delete temp.
///
/// A working installed package is NEVER replaced by a corrupt or unverified
/// download — verification and structural validation both happen before the DB
/// import, and the import itself is transactional.
class ContentPackageDownloadService {
  ContentPackageDownloadService(
    this.db, {
    required this.httpClient,
    required this.publicKeyProvider,
    PackageVerifier? verifier,
    this.reader = const PackageZipReader(),
    Connectivity? connectivity,
    this.storageProbe = const UnknownStorageProbe(),
    PartialDownloadStore? partialStore,
    this.appVersion = '1.0.0',
    this.maxRetries = 3,
    this.retryDelay = const Duration(milliseconds: 200),
  })  : partialStore = partialStore ?? InMemoryPartialStore(),
        verifier = verifier ?? PackageVerifier(),
        connectivity = connectivity ?? ManualConnectivity();

  final AppDatabase db;
  final DownloadHttpClient httpClient;
  final PublicKeyProvider publicKeyProvider;
  final PackageVerifier verifier;
  final PackageZipReader reader;
  final Connectivity connectivity;
  final StorageProbe storageProbe;
  final PartialDownloadStore partialStore;
  final String appVersion;
  final int maxRetries;
  final Duration retryDelay;

  /// Downloads and installs [meta]. Emits progress via [onProgress]. Returns the
  /// final outcome. Never throws for the expected failure cases — they are
  /// reported as [DownloadError]s so the UI can show a friendly message.
  Future<PackageInstallOutcome> downloadAndInstall(
    PackageMetadata meta, {
    required bool wifiOnly,
    required bool allowMobileData,
    void Function(PackageDownload)? onProgress,
    CancelToken? cancelToken,
  }) async {
    var state = PackageDownload(packageId: meta.packageId);
    void emit(PackageDownload s) {
      state = s;
      onProgress?.call(s);
    }

    PackageInstallOutcome fail(DownloadError error) {
      emit(state.copyWith(phase: DownloadPhase.failed, error: error));
      return PackageInstallOutcome(phase: DownloadPhase.failed, error: error);
    }

    // 1) App-version gate.
    if (!meta.isSupportedBy(appVersion)) {
      return fail(DownloadError.unsupportedAppVersion);
    }

    // 2) Connectivity + Wi-Fi-only.
    final net = await connectivity.status();
    if (net == ConnectivityStatus.offline) {
      return fail(DownloadError.noInternet);
    }
    if (net == ConnectivityStatus.mobile && (wifiOnly || !allowMobileData)) {
      emit(state.copyWith(phase: DownloadPhase.waitingForWifi));
      return fail(DownloadError.wifiRequired);
    }

    // 3) Storage pre-check (best effort).
    final free = await storageProbe.freeBytes();
    if (free != null && free < meta.sizeBytes) {
      return fail(DownloadError.insufficientStorage);
    }

    // 4) Download (resumable + retry + cancel).
    List<int> bytes;
    try {
      bytes = await _download(meta, emit, cancelToken);
    } on _CanceledException {
      emit(state.copyWith(phase: DownloadPhase.canceled));
      return const PackageInstallOutcome(
          phase: DownloadPhase.canceled, error: DownloadError.none);
    } on _DownloadFailure catch (e) {
      return fail(e.error);
    }

    // 5) Verify checksum + signature BEFORE trusting the bytes.
    emit(state.copyWith(phase: DownloadPhase.verifying));
    final publicKey = await publicKeyProvider.publicKeyBase64();
    final result = await verifier.verify(
      bytes: bytes,
      expectedSha256: meta.sha256,
      signatureBase64: meta.signature,
      publicKeyBase64: publicKey,
    );
    if (result != PackageVerificationResult.ok) {
      // Delete the bad/corrupt download safely; keep any installed version.
      await partialStore.clear(meta.packageId);
      return fail(result == PackageVerificationResult.checksumFailed
          ? DownloadError.invalidChecksum
          : DownloadError.invalidSignature);
    }

    // 6) Validate structure + 7) import.
    emit(state.copyWith(phase: DownloadPhase.validating));
    final ReadPackage read;
    try {
      read = reader.read(bytes);
    } on PackageFormatException {
      await partialStore.clear(meta.packageId);
      return fail(DownloadError.corruptPackage);
    } on ContentValidationException {
      await partialStore.clear(meta.packageId);
      return fail(DownloadError.corruptPackage);
    }

    emit(state.copyWith(phase: DownloadPhase.installing));
    try {
      final importer = ContentImporter(db);
      // Transactional replace — a failure rolls back, keeping the old version.
      await importer.importPackage(read.package, replaceGrade: true);
      await db.upsertInstalledPackage(
        packageId: read.packageId,
        grade: read.grade,
        title: meta.title.isNotEmpty ? meta.title : 'Grade ${read.grade}',
        version: read.version,
        province: read.package.province,
        isDemo: read.package.isDemo,
        sizeBytes: meta.sizeBytes,
      );
    } catch (_) {
      return fail(DownloadError.corruptPackage);
    }

    // 8) Delete the temporary download; mark installed.
    await partialStore.clear(meta.packageId);
    emit(state.copyWith(
        phase: DownloadPhase.installed,
        bytesReceived: bytes.length,
        totalBytes: bytes.length));
    return const PackageInstallOutcome(phase: DownloadPhase.installed);
  }

  /// Streams the archive, resuming from any saved partial and retrying transient
  /// failures. Throws [_CanceledException] or [_DownloadFailure].
  Future<List<int>> _download(
    PackageMetadata meta,
    void Function(PackageDownload) emit,
    CancelToken? cancelToken,
  ) async {
    var attempt = 0;
    while (true) {
      attempt++;
      final existing = List<int>.from(await partialStore.read(meta.packageId));
      final buffer = <int>[...existing];
      try {
        final resp = await httpClient.openStream(
          meta.downloadUrl,
          fromByte: existing.isNotEmpty ? existing.length : 0,
        );
        if (!resp.isOk) {
          throw _DownloadFailure(DownloadError.httpError);
        }
        // If we asked to resume but the server ignored ranges, restart clean.
        if (existing.isNotEmpty && resp.statusCode == 200) {
          buffer.clear();
        }
        final total = resp.totalBytes ?? meta.sizeBytes;
        emit(PackageDownload(
          packageId: meta.packageId,
          phase: DownloadPhase.downloading,
          bytesReceived: buffer.length,
          totalBytes: total,
        ));
        await for (final chunk in resp.stream) {
          if (cancelToken?.isCanceled ?? false) {
            await partialStore.write(meta.packageId, buffer);
            throw const _CanceledException();
          }
          buffer.addAll(chunk);
          emit(PackageDownload(
            packageId: meta.packageId,
            phase: DownloadPhase.downloading,
            bytesReceived: buffer.length,
            totalBytes: total,
          ));
        }
        // Sanity: incomplete stream vs. declared size → treat as interrupted.
        if (resp.totalBytes != null && buffer.length < resp.totalBytes!) {
          throw _DownloadFailure(DownloadError.interrupted);
        }
        return buffer;
      } on _CanceledException {
        rethrow;
      } on _DownloadFailure {
        await partialStore.write(meta.packageId, buffer);
        if (attempt > maxRetries) rethrow;
        await Future<void>.delayed(retryDelay);
      } catch (_) {
        // Network/timeout/other → save partial and retry with backoff.
        await partialStore.write(meta.packageId, buffer);
        if (attempt > maxRetries) {
          throw _DownloadFailure(DownloadError.timeout);
        }
        await Future<void>.delayed(retryDelay);
      }
    }
  }
}

class _CanceledException implements Exception {
  const _CanceledException();
}

class _DownloadFailure implements Exception {
  _DownloadFailure(this.error);
  final DownloadError error;
}
