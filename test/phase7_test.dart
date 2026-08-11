import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parho_kp/core/config/catalog_config.dart';
import 'package:parho_kp/data/content/audio_store.dart';
import 'package:parho_kp/data/content/connectivity.dart';
import 'package:parho_kp/data/content/content_package_download_service.dart';
import 'package:parho_kp/data/content/demo_package_builder.dart';
import 'package:parho_kp/data/content/download_http_client.dart';
import 'package:parho_kp/data/content/package_catalog.dart';
import 'package:parho_kp/data/content/package_manifest.dart';
import 'package:parho_kp/data/content/package_zip_reader.dart';
import 'package:parho_kp/data/database/app_database.dart';
import 'package:parho_kp/shared/services/lesson_audio_service.dart';
import 'package:parho_kp/shared/services/tts_service.dart';

/// Serves fixed bytes in small chunks so mid-stream connectivity checks fire.
class _ChunkedClient implements DownloadHttpClient {
  _ChunkedClient(this.bytes, {this.chunk = 64});
  final List<int> bytes;
  final int chunk;
  @override
  Future<ByteStreamResponse> openStream(String url, {int fromByte = 0}) async {
    final rem = bytes.sublist(fromByte.clamp(0, bytes.length));
    Stream<List<int>> s() async* {
      for (var i = 0; i < rem.length; i += chunk) {
        yield rem.sublist(i, (i + chunk).clamp(0, rem.length));
      }
    }

    return ByteStreamResponse(
      statusCode: fromByte > 0 ? 206 : 200,
      totalBytes: bytes.length,
      acceptsRanges: true,
      stream: s(),
    );
  }
}

/// Connectivity that returns scripted statuses per call, then a fallback.
class _ScriptedConnectivity implements Connectivity {
  _ScriptedConnectivity(this.script,
      {this.fallback = ConnectivityStatus.wifi});
  final List<ConnectivityStatus> script;
  final ConnectivityStatus fallback;
  int _i = 0;
  @override
  Future<ConnectivityStatus> status() async {
    if (_i < script.length) return script[_i++];
    return fallback;
  }
}

class _FakeTts implements TextToSpeechService {
  final List<String> spoken = [];
  @override
  Future<bool> isLanguageAvailable(String languageCode) async => true;
  @override
  Future<void> speak(String text, {String languageCode = 'en'}) async =>
      spoken.add(text);
  @override
  Future<void> stop() async {}
}

class _RecordingPlayer implements BundledAudioPlayer {
  final List<String> played = [];
  @override
  bool get isAvailable => true;
  @override
  Future<bool> playAsset(String assetPath) async {
    played.add(assetPath);
    return true;
  }
}

Future<({MockContentHost host, PackageMetadata meta})> _host() async {
  final host = MockContentHost();
  await host.prepare();
  final m = await host.fetchManifest();
  return (host: host, meta: m.packages.single);
}

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('production configuration', () {
    test('dev uses the mock host; production does not', () {
      expect(CatalogConfig.dev.useMockHost, isTrue);
      expect(CatalogConfig.production.useMockHost, isFalse);
    });

    test('safe download defaults: Wi-Fi only ON, mobile OFF', () {
      const d = DownloadConfig();
      expect(d.wifiOnlyByDefault, isTrue);
      expect(d.allowMobileDataByDefault, isFalse);
      const f = FeatureFlags();
      expect(f.offlineAudio, isTrue);
    });
  });

  group('offline audio pipeline', () {
    test('demo package ships audio files and lesson audio refs', () {
      final bytes = const DemoPackageBuilder().buildZipBytes();
      final read = const PackageZipReader().read(bytes);
      expect(read.hasAudio, isTrue);
      expect(read.audioFiles.keys, contains('audio/lesson_100.mp3'));
      final lessonAudios = read.package.subjects
          .expand((s) => s.units)
          .expand((u) => u.lessons)
          .map((l) => l.audio)
          .whereType<String>()
          .toList();
      expect(lessonAudios, isNotEmpty);
    });

    test('install stores audio and sets a resolvable lesson audioAsset',
        () async {
      final r = await _host();
      final audioStore = InMemoryAudioStore();
      final service = ContentPackageDownloadService(
        db,
        httpClient: MockDownloadHttpClient(r.host),
        publicKeyProvider: FixedPublicKey(r.host.publicKeyBase64),
        connectivity: ManualConnectivity(ConnectivityStatus.wifi),
        audioStore: audioStore,
        retryDelay: Duration.zero,
      );
      final outcome = await service.downloadAndInstall(
        r.meta,
        wifiOnly: false,
        allowMobileData: true,
      );
      expect(outcome.installed, isTrue);

      // Audio persisted, namespaced by package id.
      expect(audioStore.files.keys,
          contains('${DemoPackageBuilder.packageId}/audio/lesson_100.mp3'));

      // A lesson row carries a resolvable audio asset.
      final math = (await db.subjectsForGrade(5))
          .firstWhere((s) => s.code == 'math');
      final lessons = await db.lessonsForSubject(math.id);
      final withAudio =
          lessons.where((l) => l.audioAsset != null).toList();
      expect(withAudio, isNotEmpty);
      final resolved = await audioStore.resolve(withAudio.first.audioAsset!);
      expect(resolved, isNotNull);
    });

    test('LessonAudioService plays a resolved file, else falls back to TTS',
        () async {
      final tts = _FakeTts();
      final player = _RecordingPlayer();
      final audio = LessonAudioService(tts: tts, filePlayer: player);

      // Resolved absolute path → plays the file.
      final r1 = await audio.play(
          text: 'hi', audioAsset: '/data/pkg/audio/lesson_100.mp3');
      expect(r1.source, AudioSource.bundledFile);
      expect(player.played, isNotEmpty);

      // No audio asset → TTS.
      final r2 = await audio.play(text: 'hello');
      expect(r2.source, AudioSource.tts);
      expect(tts.spoken, contains('hello'));
    });
  });

  group('connectivity: pause on Wi-Fi loss then resume', () {
    test('pauses mid-download when Wi-Fi drops, then resumes to installed',
        () async {
      final r = await _host();
      final bytes = await r.host.download(r.meta.downloadUrl);
      final store = InMemoryPartialStore();

      // Pre-check sees Wi-Fi; the first mid-stream check sees offline → pause.
      final paused = ContentPackageDownloadService(
        db,
        httpClient: _ChunkedClient(bytes, chunk: 64),
        publicKeyProvider: FixedPublicKey(r.host.publicKeyBase64),
        connectivity: _ScriptedConnectivity(
          [ConnectivityStatus.wifi, ConnectivityStatus.offline],
          fallback: ConnectivityStatus.offline,
        ),
        partialStore: store,
        connectivityCheckEveryChunks: 1,
        retryDelay: Duration.zero,
      );
      final p = await paused.downloadAndInstall(
        r.meta,
        wifiOnly: true,
        allowMobileData: false,
      );
      expect(p.phase, DownloadPhase.paused);
      // A partial was saved for resume, and nothing was installed.
      expect((await store.read(r.meta.packageId)).isNotEmpty, isTrue);
      expect(await db.allInstalledPackages(), isEmpty);

      // Wi-Fi returns → resume from the saved partial and finish.
      final resumed = ContentPackageDownloadService(
        db,
        httpClient: _ChunkedClient(bytes, chunk: 64),
        publicKeyProvider: FixedPublicKey(r.host.publicKeyBase64),
        connectivity: ManualConnectivity(ConnectivityStatus.wifi),
        partialStore: store,
        connectivityCheckEveryChunks: 0, // no interruption this time
        retryDelay: Duration.zero,
      );
      final done = await resumed.downloadAndInstall(
        r.meta,
        wifiOnly: true,
        allowMobileData: false,
      );
      expect(done.installed, isTrue);
      expect(await db.subjectsForGrade(5), isNotEmpty);
    });
  });
}
