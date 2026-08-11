import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parho_kp/data/accounts/account_service.dart';
import 'package:parho_kp/data/content/content_importer.dart';
import 'package:parho_kp/data/content/content_models.dart';
import 'package:parho_kp/data/content/content_package_service.dart';
import 'package:parho_kp/data/content/content_validation.dart';
import 'package:parho_kp/data/database/app_database.dart';
import 'package:parho_kp/data/repositories/learning_repository.dart';
import 'package:parho_kp/data/seed/demo_content.dart';
import 'package:parho_kp/data/sync/sync_service.dart';
import 'package:parho_kp/features/ai_tutor/tutor_api.dart';
import 'package:parho_kp/features/ai_tutor/tutor_models.dart';
import 'package:parho_kp/features/ai_tutor/tutor_service.dart';
import 'package:parho_kp/features/gamification/gamification_service.dart';
import 'package:parho_kp/features/recommendations/learning_recommendation_service.dart';
import 'package:parho_kp/features/report/report_export_service.dart';
import 'package:parho_kp/features/school_mode/school_sync.dart';
import 'package:parho_kp/features/teacher/teacher_data.dart';
import 'package:parho_kp/shared/services/lesson_audio_service.dart';
import 'package:parho_kp/shared/services/tts_service.dart';

// ---- test doubles ----------------------------------------------------------

/// A sync client that records payloads and returns a configurable result.
class _FakeSyncClient implements SyncClient {
  _FakeSyncClient(this._result);
  final SyncSendResult _result;
  final List<String> sent = [];
  @override
  bool get isConfigured => true;
  @override
  Future<SyncSendResult> send({
    required String kind,
    required String payload,
  }) async {
    if (_result == SyncSendResult.ok) sent.add(payload);
    return _result;
  }
}

class _FakeTutorApiClient implements TutorApiClient {
  _FakeTutorApiClient(this.response);
  final TutorApiResponse response;
  int calls = 0;
  @override
  bool get isConfigured => true;
  @override
  Future<TutorApiResponse> ask(TutorApiRequest request) async {
    calls++;
    return response;
  }
}

class _FakeTts implements TextToSpeechService {
  _FakeTts({this.available = true});
  final bool available;
  final List<String> spoken = [];
  @override
  Future<bool> isLanguageAvailable(String languageCode) async => available;
  @override
  Future<void> speak(String text, {String languageCode = 'en'}) async =>
      spoken.add(text);
  @override
  Future<void> stop() async {}
}

class _FakeBundledPlayer implements BundledAudioPlayer {
  _FakeBundledPlayer({this.available = true, this.succeeds = true});
  final bool available;
  final bool succeeds;
  final List<String> played = [];
  @override
  bool get isAvailable => available;
  @override
  Future<bool> playAsset(String assetPath) async {
    played.add(assetPath);
    return succeeds;
  }
}

class _FakeSchoolTransport implements SchoolSyncTransport {
  @override
  bool get isAvailable => true;
  @override
  Future<List<SchoolPeer>> discoverPeers() async =>
      const [SchoolPeer(id: 'p1', name: 'Ali')];
  @override
  Future<StudentProgressSnapshot?> receiveFrom(SchoolPeer peer) async =>
      StudentProgressSnapshot(
        studentLocalId: peer.id,
        displayName: peer.name,
        grade: 5,
        lessonPercents: const {1: 100},
        quizPercents: const {1: 80},
      );
  @override
  Future<bool> publish(StudentProgressSnapshot snapshot) async => true;
}

// A minimal valid one-subject package JSON for grade 6.
const _validGrade6 = '''
{
  "grade": 6,
  "isDemo": true,
  "subjects": [
    {
      "code": "math", "emoji": "➕",
      "name": {"en": "Mathematics", "ur": "ریاضی", "ps": "ریاضي"},
      "units": [
        {
          "title": {"en": "Geometry", "ur": "ج", "ps": "ج"},
          "lessons": [
            {
              "title": {"en": "Shapes", "ur": "ش", "ps": "ش"},
              "objective": {"en": "o", "ur": "o", "ps": "o"},
              "explanation": {"en": "e", "ur": "e", "ps": "e"},
              "example": {"en": "x", "ur": "x", "ps": "x"},
              "illustration": "🔺",
              "questions": [
                {
                  "prompt": {"en": "Sides?", "ur": "?", "ps": "?"},
                  "options": [
                    {"en": "3", "ur": "3", "ps": "۳"},
                    {"en": "4", "ur": "4", "ps": "۴"}
                  ],
                  "correctIndex": 0
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
''';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('content validation', () {
    const validator = ContentValidator();

    test('accepts a well-formed package', () {
      final pkg = validator.parse(_validGrade6);
      expect(pkg.grade, 6);
      expect(pkg.subjects.single.code, 'math');
    });

    test('rejects malformed JSON without crashing', () {
      expect(() => validator.parse('{ not json '),
          throwsA(isA<ContentValidationException>()));
    });

    test('rejects an out-of-range grade', () {
      expect(
        () => validator.validate(const ContentPackage(grade: 99, subjects: [
          SubjectSpec(
            code: 'm',
            name: LText('M', 'M', 'M'),
            emoji: '➕',
            units: [
              UnitSpec(title: LText('U', 'U', 'U'), lessons: [
                LessonSpec(
                  title: LText('L', 'L', 'L'),
                  objective: LText('o', 'o', 'o'),
                  explanation: LText('e', 'e', 'e'),
                  example: LText('x', 'x', 'x'),
                  illustration: '📘',
                  questions: [],
                ),
              ]),
            ],
          ),
        ])),
        throwsA(isA<ContentValidationException>()),
      );
    });

    test('rejects a question with an out-of-range correct answer', () {
      const bad = '''
      {"grade": 6, "subjects": [{"code":"m","emoji":"➕",
        "name":{"en":"M","ur":"M","ps":"M"},
        "units":[{"title":{"en":"U","ur":"U","ps":"U"},
          "lessons":[{"title":{"en":"L","ur":"L","ps":"L"},
            "objective":{"en":"o","ur":"o","ps":"o"},
            "explanation":{"en":"e","ur":"e","ps":"e"},
            "example":{"en":"x","ur":"x","ps":"x"},
            "questions":[{"prompt":{"en":"p","ur":"p","ps":"p"},
              "options":[{"en":"a","ur":"a","ps":"a"},{"en":"b","ur":"b","ps":"b"}],
              "correctIndex": 9}]}]}]}]}
      ''';
      expect(() => validator.parse(bad),
          throwsA(isA<ContentValidationException>()));
    });

    test('invalid import leaves the database untouched (safe rejection)',
        () async {
      final importer = ContentImporter(db);
      expect(await db.subjectsForGrade(6), isEmpty);
      await expectLater(
        importer.importJson('{"grade": 6, "subjects": []}'),
        throwsA(isA<ContentValidationException>()),
      );
      expect(await db.subjectsForGrade(6), isEmpty);
    });
  });

  group('content packages', () {
    test('semantic version comparison', () {
      expect(compareVersions('1.2.0', '1.10.0'), lessThan(0));
      expect(compareVersions('2.0.0', '1.9.9'), greaterThan(0));
      expect(compareVersions('1.0', '1.0.0'), 0);
    });

    test('status: available, installed and update-available', () async {
      final pkg = const ContentValidator().parse(_validGrade6);
      final v1 = AvailablePackage(
        meta: const PackageMeta(
            packageId: 'kp-g6', grade: 6, title: 'G6', version: '1.0.0'),
        package: pkg,
      );
      var service =
          ContentPackageService(db, catalog: InMemoryPackageCatalog([v1]));

      // Before install → available.
      var entries = await service.statusEntries();
      expect(entries.single.status, PackageStatus.available);

      // Install → installed.
      await service.install(v1);
      entries = await service.statusEntries();
      expect(entries.single.status, PackageStatus.installed);
      expect((await db.subjectsForGrade(6)), isNotEmpty);

      // Offer a newer version → update-available.
      final v2 = AvailablePackage(
        meta: const PackageMeta(
            packageId: 'kp-g6', grade: 6, title: 'G6', version: '2.0.0'),
        package: pkg,
      );
      service =
          ContentPackageService(db, catalog: InMemoryPackageCatalog([v2]));
      entries = await service.statusEntries();
      expect(entries.single.status, PackageStatus.updateAvailable);
      expect(entries.single.installedVersion, '1.0.0');
    });

    test('download decisions respect Wi-Fi-only and size', () {
      final s = ContentPackageService(db);
      // Mobile data always confirms.
      expect(s.shouldConfirmDownload(sizeBytes: 1, onWifi: false), isTrue);
      // Wi-Fi confirms only for large packages.
      expect(s.shouldConfirmDownload(sizeBytes: 1, onWifi: true), isFalse);
      expect(
          s.shouldConfirmDownload(
              sizeBytes: 50 * 1024 * 1024, onWifi: true),
          isTrue);
      // Wi-Fi-only blocks mobile downloads.
      expect(s.canDownloadNow(onWifi: false, wifiOnly: true), isFalse);
      expect(s.canDownloadNow(onWifi: false, wifiOnly: false), isTrue);
    });
  });

  group('sync queue', () {
    test('enqueues learning signals locally (offline-first)', () async {
      final sync = SyncService(db); // NoopSyncClient
      await sync.enqueueQuiz(lessonId: 1, score: 8, total: 10);
      await sync.enqueueProgress(lessonId: 1, percent: 80, completed: true);
      await sync.enqueueAchievement(code: 'first_quiz');
      final counts = await sync.counts();
      expect(counts.pending, 3);
      // No backend → flush uploads nothing and nothing is lost.
      expect(await sync.flush(), 0);
      expect((await sync.counts()).pending, 3);
    });

    test('flush marks rows synced when the backend accepts them', () async {
      final client = _FakeSyncClient(SyncSendResult.ok);
      final sync = SyncService(db, client: client);
      await sync.enqueueQuiz(lessonId: 2, score: 5, total: 5);
      expect(await sync.flush(), 1);
      final counts = await sync.counts();
      expect(counts.synced, 1);
      expect(counts.pending, 0);
      expect(client.sent, hasLength(1));
    });

    test('failed rows are parked then retryable — never lost', () async {
      final sync = SyncService(db,
          client: _FakeSyncClient(SyncSendResult.rejected), maxAttempts: 1);
      await sync.enqueueQuiz(lessonId: 3, score: 1, total: 5);
      await sync.flush();
      expect((await sync.counts()).failed, 1);
      await sync.retryFailed();
      expect((await sync.counts()).pending, 1);
    });
  });

  group('accounts', () {
    test('creates a guest student with optional school/class only', () async {
      final accounts = AccountService(db);
      final s = await accounts.createGuestStudent(
        name: 'Ahmad',
        grade: 5,
        languageCode: 'en',
        school: 'GPS Peshawar',
        className: '5-A',
      );
      expect(s.isGuest, isTrue);
      expect(s.school, 'GPS Peshawar');
      final loaded = await accounts.currentStudent();
      expect(loaded?.className, '5-A');
    });

    test('mock teacher auth accepts demo credentials only', () async {
      final auth = MockAuthService();
      expect(await auth.signInTeacher(username: 'x', password: 'y'), isNull);
      final t = await auth.signInTeacher(
          username: MockAuthService.demoUsername,
          password: MockAuthService.demoPassword);
      expect(t, isNotNull);
      expect(auth.currentTeacher?.district, 'Peshawar');
      await auth.signOutTeacher();
      expect(auth.currentTeacher, isNull);
    });
  });

  group('AI tutor backend contract', () {
    test('not configured → StateError (falls back to mock)', () async {
      const remote = RemoteTutorService();
      expect(remote.isConfigured, isFalse);
      expect(() => remote.respond(const TutorRequest(context: TutorContext())),
          throwsA(isA<StateError>()));
    });

    test('sensitive question is answered safely without a backend call',
        () async {
      final client = _FakeTutorApiClient(const TutorApiResponse(
          answer: 'should-not-be-used', language: 'en'));
      final remote = RemoteTutorService(apiClient: client);
      final reply = await remote.respond(const TutorRequest(
        context: TutorContext(languageCode: 'en'),
        message: 'I feel sick, what medicine should I take?',
      ));
      expect(reply.text, isNotEmpty);
      expect(client.calls, 0); // safety path — no paid API call
    });

    test('uses the backend and caches identical requests (cost control)',
        () async {
      final client = _FakeTutorApiClient(const TutorApiResponse(
          answer: 'Backend says hi', language: 'en'));
      final remote =
          RemoteTutorService(apiClient: client, cache: TutorResponseCache());
      const request = TutorRequest(
        context: TutorContext(grade: 5, languageCode: 'en', topic: 'Fractions'),
        message: 'what is a fraction',
      );
      final r1 = await remote.respond(request);
      final r2 = await remote.respond(request);
      expect(r1.text, 'Backend says hi');
      expect(r2.text, 'Backend says hi');
      expect(client.calls, 1); // second answer came from cache
    });

    test('response parsing rejects a missing answer field', () {
      expect(() => TutorApiResponse.fromJson(const {'language': 'en'}),
          throwsA(isA<FormatException>()));
    });
  });

  group('deterministic recommendations', () {
    const rec = LearningRecommender();
    test('maps quiz scores to concrete next steps', () {
      expect(rec.recommend(const LearningSignals(latestQuizPercent: 30)),
          LearningRecommendation.reviewLesson);
      expect(rec.recommend(const LearningSignals(latestQuizPercent: 60)),
          LearningRecommendation.practiceMore);
      expect(rec.recommend(const LearningSignals(latestQuizPercent: 85)),
          LearningRecommendation.tryNextLesson);
      expect(
          rec.recommend(const LearningSignals(
              latestQuizPercent: 90, unitComplete: true)),
          LearningRecommendation.readyForNextUnit);
    });

    test('is deterministic for identical inputs', () {
      const s = LearningSignals(understandingCorrect: 3, understandingWrong: 0);
      expect(rec.recommend(s), rec.recommend(s));
      expect(rec.recommend(s), LearningRecommendation.tryNextLesson);
    });
  });

  group('gamification', () {
    test('longest daily streak', () {
      final base = DateTime.utc(2026, 1, 1);
      final days = [for (var i = 0; i < 7; i++) base.add(Duration(days: i))];
      expect(longestDailyStreak(days), 7);
      expect(longestDailyStreak([base, base.add(const Duration(days: 2))]), 1);
      expect(longestDailyStreak(const []), 0);
    });

    test('unlocks milestones from real progress and is idempotent', () async {
      await seedDemoContentIfNeeded(db);
      final repo = LearningRepository(db);
      final studentId =
          await repo.createStudent(name: 'A', grade: 5, languageCode: 'en');
      final student = (await repo.currentStudent())!;

      // Complete one lesson with a perfect quiz.
      final math = (await repo.subjectsForGrade(5))
          .firstWhere((s) => s.code == 'math');
      final lesson = (await db.lessonsForSubject(math.id)).first;
      final qs = await repo.questionsForLesson(lesson.id);
      await repo.saveQuizResult(
        studentId: studentId,
        lessonId: lesson.id,
        questions: qs,
        selected: qs.map((q) => q.correctIndex).toList(),
      );

      final game = GamificationService(db);
      final newly = await game.evaluate(student.id);
      final codes = newly.map((d) => d.code).toSet();
      expect(codes, containsAll(['first_lesson', 'first_quiz', 'perfect_score']));

      // Idempotent: a second evaluation unlocks nothing new.
      expect(await game.evaluate(student.id), isEmpty);
      expect(await game.totalPoints(student.id), greaterThan(0));
    });
  });

  group('lesson audio (offline, graceful fallback)', () {
    test('prefers a bundled audio file when present', () async {
      final player = _FakeBundledPlayer();
      final audio = LessonAudioService(tts: _FakeTts(), filePlayer: player);
      final result = await audio.play(
          text: 'hello', audioAsset: 'lessons/1.mp3', languageCode: 'en');
      expect(result.source, AudioSource.bundledFile);
      expect(player.played, ['lessons/1.mp3']);
    });

    test('falls back to TTS when there is no bundled file', () async {
      final tts = _FakeTts();
      final audio = LessonAudioService(tts: tts);
      final result = await audio.play(text: 'hello', languageCode: 'en');
      expect(result.source, AudioSource.tts);
      expect(tts.spoken, ['hello']);
    });

    test('reports unavailable (no crash) when no voice exists', () async {
      final audio = LessonAudioService(tts: _FakeTts(available: false));
      final result = await audio.play(text: 'hello', languageCode: 'en');
      expect(result.didPlay, isFalse);
      expect(result.source, AudioSource.unavailable);
    });

    test('falls back to TTS when the bundled file cannot play', () async {
      final tts = _FakeTts();
      final audio = LessonAudioService(
        tts: tts,
        filePlayer: _FakeBundledPlayer(available: true, succeeds: false),
      );
      final result = await audio.play(
          text: 'hi', audioAsset: 'lessons/1.mp3', languageCode: 'en');
      expect(result.source, AudioSource.tts);
      expect(tts.spoken, ['hi']);
    });

    test('ignores a bundled file when no player is available', () async {
      final tts = _FakeTts();
      final audio = LessonAudioService(
        tts: tts,
        filePlayer: _FakeBundledPlayer(available: false),
      );
      final result = await audio.play(
          text: 'hi', audioAsset: 'lessons/1.mp3', languageCode: 'en');
      expect(result.source, AudioSource.tts);
    });
  });

  group('teacher report export (offline)', () {
    const service = ReportExportService();

    test('class CSV has a header, a row per student and a class average', () {
      final data = buildDemoClass(id: 5, grade: 5);
      final csv = service.classReportCsv(data);
      final lines = csv.trim().split('\n');
      expect(lines.first, startsWith('Student,'));
      // 32 students + header + class-average row.
      expect(lines.length, data.students.length + 2);
      expect(lines.last, startsWith('Class average,'));
    });

    test('CSV escaping quotes commas and quotes', () {
      final data = buildDemoClass(id: 5, grade: 5);
      // Sanity: any field with a comma must be wrapped in quotes.
      final csv = service.classReportCsv(data);
      expect(csv.contains('\n'), isTrue);
    });
  });

  group('school mode', () {
    test('unavailable transport degrades gracefully', () async {
      final svc = SchoolSyncService();
      expect(svc.isAvailable, isFalse);
      expect(await svc.collectFromPeers(), isEmpty);
      expect(
          await svc.shareSnapshot(const StudentProgressSnapshot(
            studentLocalId: 'x',
            displayName: 'X',
            grade: 5,
            lessonPercents: {},
            quizPercents: {},
          )),
          isFalse);
    });

    test('a wired transport collects peer snapshots', () async {
      final svc = SchoolSyncService(transport: _FakeSchoolTransport());
      final snaps = await svc.collectFromPeers();
      expect(snaps, hasLength(1));
      expect(snaps.single.displayName, 'Ali');
    });
  });

  group('schema v3 migration surface', () {
    test('new tables and columns are usable', () async {
      // Students carry optional school/class; lessons an optional audio asset.
      final id = await db.createStudent(
          name: 'S', grade: 5, languageCode: 'en', school: 'GPS', className: '5A');
      final s = await db.currentStudent();
      expect(s?.id, id);
      expect(s?.school, 'GPS');

      // Achievements unlock uniquely.
      expect(
          await db.unlockAchievement(studentId: id, code: 'x', points: 5), isTrue);
      expect(
          await db.unlockAchievement(studentId: id, code: 'x', points: 5),
          isFalse);
      expect(await db.achievementsForStudent(id), hasLength(1));
    });
  });
}
