import 'dart:async';
import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'demo_package_builder.dart';
import 'download_http_client.dart';
import 'package_manifest.dart';

/// A source of the catalog manifest — the list of downloadable content
/// packages. Offline-first: the app never *requires* a catalog (installed
/// content always works); it is only consulted to discover new/updated content.
///
/// The same interface is used by the development [MockPackageManifestCatalog]
/// and the production [RemotePackageManifestCatalog], so the UI never changes
/// when switching between them.
abstract class PackageManifestCatalog {
  Future<ContentPackageManifest> fetchManifest();
}

/// Fetches a catalog manifest from a real HTTPS endpoint. This is the
/// PRODUCTION catalog — it talks to a server you operate. Not a mock.
class RemotePackageManifestCatalog implements PackageManifestCatalog {
  RemotePackageManifestCatalog({
    required this.catalogUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 20),
  }) : _client = client ?? http.Client();

  final String catalogUrl;
  final http.Client _client;
  final Duration timeout;

  @override
  Future<ContentPackageManifest> fetchManifest() async {
    final resp =
        await _client.get(Uri.parse(catalogUrl)).timeout(timeout);
    if (resp.statusCode != 200) {
      throw http.ClientException(
          'Catalog returned HTTP ${resp.statusCode}', Uri.parse(catalogUrl));
    }
    final decoded = jsonDecode(resp.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Catalog manifest is not an object.');
    }
    return ContentPackageManifest.fromJson(decoded);
  }
}

/// A DEVELOPMENT mock content host. It is **not** a production server — it is an
/// in-app stand-in that produces a real, signed demo package so the whole
/// download → verify → install pipeline can be exercised offline.
///
/// It generates a per-run Ed25519 development key pair, builds and signs the
/// demo package, and serves both the manifest and the package bytes. The
/// private key exists only in memory for this dev host and is never shipped as
/// app configuration. Production replaces this with a real server + a fixed
/// public key configured in `CatalogConfig`.
class MockContentHost {
  MockContentHost({this.builder = const DemoPackageBuilder()});

  final DemoPackageBuilder builder;
  final Ed25519 _algorithm = Ed25519();

  late final List<int> _packageBytes;
  late final String _sha256Hex;
  late final String _signatureB64;
  late final String _publicKeyB64;
  late final PackageMetadata _metadata;
  bool _ready = false;

  /// The dev public key (base64) that verifies this host's packages. In
  /// development the verifier uses this instead of a production key.
  String get publicKeyBase64 {
    _ensureReady();
    return _publicKeyB64;
  }

  /// The version the host currently offers (bumpable to simulate an update).
  String hostedVersion = DemoPackageBuilder.version;

  Future<void> _init() async {
    if (_ready) return;
    _packageBytes = builder.buildZipBytes(version: hostedVersion);
    _sha256Hex = sha256.convert(_packageBytes).toString();
    final keyPair = await _algorithm.newKeyPair();
    final sig = await _algorithm.sign(_packageBytes, keyPair: keyPair);
    final pub = await keyPair.extractPublicKey();
    _signatureB64 = base64Encode(sig.bytes);
    _publicKeyB64 = base64Encode(pub.bytes);
    _metadata = PackageMetadata(
      packageId: DemoPackageBuilder.packageId,
      grade: DemoPackageBuilder.grade,
      subject: 'math',
      language: 'ur',
      version: hostedVersion,
      contentVersion: int.tryParse(hostedVersion) ?? 1,
      sizeBytes: _packageBytes.length,
      downloadUrl: 'mock://${DemoPackageBuilder.packageId}',
      sha256: _sha256Hex,
      signature: _signatureB64,
      releaseDate: DateTime(2026, 1, 1),
      minimumAppVersion: '1.0.0',
      title: 'Grade 5 Mathematics (Demo)',
    );
    _ready = true;
  }

  void _ensureReady() {
    if (!_ready) {
      throw StateError('MockContentHost.prepare() must be awaited first.');
    }
  }

  /// Prepares the host (builds + signs the package). Await before use.
  Future<void> prepare() => _init();

  Future<ContentPackageManifest> fetchManifest() async {
    await _init();
    return ContentPackageManifest(
      manifestVersion: 1,
      generatedAt: DateTime(2026, 1, 1),
      packages: [_metadata],
    );
  }

  /// The signed package bytes for [url]. Throws if the url is unknown.
  Future<List<int>> download(String url) async {
    await _init();
    if (url != _metadata.downloadUrl) {
      throw ArgumentError('Unknown mock download url: $url');
    }
    return _packageBytes;
  }
}

/// Catalog backed by the development [MockContentHost].
class MockPackageManifestCatalog implements PackageManifestCatalog {
  MockPackageManifestCatalog(this.host);
  final MockContentHost host;
  @override
  Future<ContentPackageManifest> fetchManifest() => host.fetchManifest();
}

/// A [DownloadHttpClient] that serves bytes from a [MockContentHost] in fixed
/// chunks so progress reporting and resume can be exercised without a network.
class MockDownloadHttpClient implements DownloadHttpClient {
  MockDownloadHttpClient(this.host, {this.chunkSize = 8 * 1024});
  final MockContentHost host;
  final int chunkSize;

  @override
  Future<ByteStreamResponse> openStream(String url, {int fromByte = 0}) async {
    final bytes = await host.download(url);
    final start = fromByte.clamp(0, bytes.length);
    final remaining = bytes.sublist(start);

    Stream<List<int>> chunks() async* {
      for (var i = 0; i < remaining.length; i += chunkSize) {
        final end = (i + chunkSize).clamp(0, remaining.length);
        yield remaining.sublist(i, end);
      }
    }

    return ByteStreamResponse(
      statusCode: fromByte > 0 ? 206 : 200,
      totalBytes: bytes.length,
      acceptsRanges: true,
      stream: chunks(),
    );
  }
}
