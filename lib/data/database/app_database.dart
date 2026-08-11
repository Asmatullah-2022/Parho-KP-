import 'package:drift/drift.dart';

import 'connection/connection.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

/// The student using the app (single-device, no account required).
class Students extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  IntColumn get grade => integer()();
  TextColumn get languageCode => text().withLength(max: 4)();
  IntColumn get avatarSeed => integer().withDefault(const Constant(0))();

  /// Optional school and class labels. These are the ONLY organisational
  /// fields collected — the app never stores CNIC, address, GPS location,
  /// phone number or family details.
  TextColumn get school => text().nullable()();
  TextColumn get className => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// A school subject for a given grade (e.g. Mathematics for Grade 5).
class Subjects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().withLength(max: 32)();
  IntColumn get grade => integer()();
  TextColumn get nameEn => text()();
  TextColumn get nameUr => text()();
  TextColumn get namePs => text()();
  TextColumn get emoji => text().withLength(max: 8)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// A unit (chapter) inside a subject.
class Units extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get subjectId =>
      integer().references(Subjects, #id, onDelete: KeyAction.cascade)();
  TextColumn get titleEn => text()();
  TextColumn get titleUr => text()();
  TextColumn get titlePs => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// A single lesson inside a unit. Content is stored per language.
class Lessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get unitId =>
      integer().references(Units, #id, onDelete: KeyAction.cascade)();
  TextColumn get titleEn => text()();
  TextColumn get titleUr => text()();
  TextColumn get titlePs => text()();
  TextColumn get objectiveEn => text()();
  TextColumn get objectiveUr => text()();
  TextColumn get objectivePs => text()();
  TextColumn get explanationEn => text()();
  TextColumn get explanationUr => text()();
  TextColumn get explanationPs => text()();
  TextColumn get exampleEn => text()();
  TextColumn get exampleUr => text()();
  TextColumn get examplePs => text()();
  TextColumn get illustration => text().withLength(max: 8)();

  /// Optional relative path to a compressed offline audio file bundled with a
  /// downloaded content package. When null the app falls back to on-device TTS.
  TextColumn get audioAsset => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isDemo => boolean().withDefault(const Constant(true))();
}

/// A multiple-choice question belonging to a lesson. Options are stored as a
/// JSON array of strings per language.
class Questions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lessonId =>
      integer().references(Lessons, #id, onDelete: KeyAction.cascade)();
  TextColumn get promptEn => text()();
  TextColumn get promptUr => text()();
  TextColumn get promptPs => text()();
  TextColumn get optionsEn => text()(); // JSON array
  TextColumn get optionsUr => text()();
  TextColumn get optionsPs => text()();
  IntColumn get correctIndex => integer()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// One completed (or in-progress) quiz for a lesson.
class QuizAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId =>
      integer().references(Students, #id, onDelete: KeyAction.cascade)();
  IntColumn get lessonId =>
      integer().references(Lessons, #id, onDelete: KeyAction.cascade)();
  IntColumn get score => integer()();
  IntColumn get total => integer()();
  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get finishedAt => dateTime().nullable()();
}

/// A single answer within a quiz attempt.
class QuizAnswers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get attemptId =>
      integer().references(QuizAttempts, #id, onDelete: KeyAction.cascade)();
  IntColumn get questionId =>
      integer().references(Questions, #id, onDelete: KeyAction.cascade)();
  IntColumn get selectedIndex => integer()();
  BoolColumn get isCorrect => boolean()();
}

/// Per-student, per-lesson progress (0-100). Recomputed from lessons opened and
/// quizzes taken — never hardcoded.
class LessonProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId =>
      integer().references(Students, #id, onDelete: KeyAction.cascade)();
  IntColumn get lessonId =>
      integer().references(Lessons, #id, onDelete: KeyAction.cascade)();
  IntColumn get percent => integer().withDefault(const Constant(0))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {studentId, lessonId},
      ];
}

/// Tracks which subjects (for a grade) are downloaded for offline use.
class Downloads extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get grade => integer()();
  IntColumn get subjectId =>
      integer().references(Subjects, #id, onDelete: KeyAction.cascade)();
  BoolColumn get isDownloaded => boolean().withDefault(const Constant(false))();
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {subjectId},
      ];
}

/// Lessons a student has marked as favourite.
class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId =>
      integer().references(Students, #id, onDelete: KeyAction.cascade)();
  IntColumn get lessonId =>
      integer().references(Lessons, #id, onDelete: KeyAction.cascade)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {studentId, lessonId},
      ];
}

/// Generic key/value store for domain-level flags (e.g. seed version).
class AppSettingsRows extends Table {
  TextColumn get settingKey => text()();
  TextColumn get settingValue => text()();

  @override
  Set<Column> get primaryKey => {settingKey};
}

/// Recent AI Tutor conversation messages (chat history), stored on-device.
class TutorMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer()();
  BoolColumn get fromAi => boolean()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Results of "Test My Understanding" checks — a local adaptive-learning signal.
class UnderstandingChecks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer()();
  IntColumn get lessonId => integer().nullable()();
  BoolColumn get isCorrect => boolean()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// A versioned content package known to the device. Tracks metadata so the app
/// can show Installed / Update-available status and re-import cleanly offline.
class InstalledPackages extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Stable identifier for the package, e.g. "kp-grade-5".
  TextColumn get packageId => text()();
  IntColumn get grade => integer()();
  TextColumn get title => text()();

  /// Semantic version string, e.g. "1.2.0". Compared to decide updates.
  TextColumn get version => text()();
  TextColumn get province =>
      text().withDefault(const Constant('Khyber Pakhtunkhwa'))();
  BoolColumn get isDemo => boolean().withDefault(const Constant(true))();
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();
  DateTimeColumn get installedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {packageId},
      ];
}

/// Low-bandwidth outbound sync queue. Only anonymous learning signals
/// (progress, quiz results, achievements) are ever queued — never personal
/// data. Rows are retried until synced and are never dropped on failure.
class SyncQueueRows extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// 'progress' | 'quiz' | 'achievement'.
  TextColumn get kind => text()();

  /// Compact JSON payload (small, anonymous — no name/school/personal fields).
  TextColumn get payload => text()();

  /// 'pending' | 'synced' | 'failed'.
  TextColumn get syncStatus =>
      text().withDefault(const Constant('pending'))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
}

/// Achievements a student has unlocked (gamification). Deterministic, with no
/// gambling or addictive mechanics — one row per unlocked achievement.
class Achievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get studentId => integer()();

  /// Stable achievement code, e.g. 'first_lesson'.
  TextColumn get code => text()();
  IntColumn get points => integer().withDefault(const Constant(0))();
  DateTimeColumn get unlockedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {studentId, code},
      ];
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

@DriftDatabase(
  tables: [
    Students,
    Subjects,
    Units,
    Lessons,
    Questions,
    QuizAttempts,
    QuizAnswers,
    LessonProgress,
    Downloads,
    Favorites,
    AppSettingsRows,
    TutorMessages,
    UnderstandingChecks,
    InstalledPackages,
    SyncQueueRows,
    Achievements,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  /// Test/alternate constructor allowing a custom executor (e.g. in-memory).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(tutorMessages);
            await m.createTable(understandingChecks);
          }
          if (from < 3) {
            await m.createTable(installedPackages);
            await m.createTable(syncQueueRows);
            await m.createTable(achievements);
            await m.addColumn(students, students.school);
            await m.addColumn(students, students.className);
            await m.addColumn(lessons, lessons.audioAsset);
          }
        },
      );

  // ---- key/value helpers -------------------------------------------------

  Future<String?> getSetting(String key) async {
    final row = await (select(appSettingsRows)
          ..where((t) => t.settingKey.equals(key)))
        .getSingleOrNull();
    return row?.settingValue;
  }

  Future<void> putSetting(String key, String value) async {
    await into(appSettingsRows).insertOnConflictUpdate(
      AppSettingsRowsCompanion.insert(settingKey: key, settingValue: value),
    );
  }

  // ---- catalog queries ---------------------------------------------------

  Future<List<Subject>> subjectsForGrade(int grade) {
    return (select(subjects)
          ..where((t) => t.grade.equals(grade))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  Future<List<Unit>> unitsForSubject(int subjectId) {
    return (select(units)
          ..where((t) => t.subjectId.equals(subjectId))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  Future<List<Lesson>> lessonsForUnit(int unitId) {
    return (select(lessons)
          ..where((t) => t.unitId.equals(unitId))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  Future<List<Lesson>> lessonsForSubject(int subjectId) async {
    final unitRows = await unitsForSubject(subjectId);
    final ids = unitRows.map((u) => u.id).toList();
    if (ids.isEmpty) return [];
    return (select(lessons)
          ..where((t) => t.unitId.isIn(ids))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  Future<List<Lesson>> allLessons() => select(lessons).get();

  /// Removes all content (and dependent rows) for one grade. Foreign-key
  /// cascades are not relied upon, so child rows are deleted explicitly.
  Future<void> deleteGradeContent(int grade) async {
    final subjectRows = await (select(subjects)
          ..where((t) => t.grade.equals(grade)))
        .get();
    final subjectIds = subjectRows.map((s) => s.id).toList();
    if (subjectIds.isEmpty) return;
    final unitRows =
        await (select(units)..where((t) => t.subjectId.isIn(subjectIds))).get();
    final unitIds = unitRows.map((u) => u.id).toList();
    final lessonRows = unitIds.isEmpty
        ? <Lesson>[]
        : await (select(lessons)..where((t) => t.unitId.isIn(unitIds))).get();
    final lessonIds = lessonRows.map((l) => l.id).toList();
    final questionRows = lessonIds.isEmpty
        ? <Question>[]
        : await (select(questions)..where((t) => t.lessonId.isIn(lessonIds)))
            .get();
    final questionIds = questionRows.map((q) => q.id).toList();

    await transaction(() async {
      if (questionIds.isNotEmpty) {
        await (delete(quizAnswers)
              ..where((t) => t.questionId.isIn(questionIds)))
            .go();
      }
      if (lessonIds.isNotEmpty) {
        await (delete(quizAttempts)..where((t) => t.lessonId.isIn(lessonIds)))
            .go();
        await (delete(lessonProgress)
              ..where((t) => t.lessonId.isIn(lessonIds)))
            .go();
        await (delete(favorites)..where((t) => t.lessonId.isIn(lessonIds)))
            .go();
        await (delete(understandingChecks)
              ..where((t) => t.lessonId.isIn(lessonIds)))
            .go();
        await (delete(questions)..where((t) => t.lessonId.isIn(lessonIds)))
            .go();
        await (delete(lessons)..where((t) => t.id.isIn(lessonIds))).go();
      }
      if (unitIds.isNotEmpty) {
        await (delete(units)..where((t) => t.id.isIn(unitIds))).go();
      }
      await (delete(downloads)..where((t) => t.subjectId.isIn(subjectIds)))
          .go();
      await (delete(subjects)..where((t) => t.id.isIn(subjectIds))).go();
    });
  }

  Future<List<Lesson>> lessonsByIds(List<int> ids) {
    if (ids.isEmpty) return Future.value([]);
    return (select(lessons)..where((t) => t.id.isIn(ids))).get();
  }

  Future<Lesson?> lessonById(int id) {
    return (select(lessons)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<Subject?> subjectById(int id) {
    return (select(subjects)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<Unit?> unitById(int id) {
    return (select(units)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<Question>> questionsForLesson(int lessonId) {
    return (select(questions)
          ..where((t) => t.lessonId.equals(lessonId))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .get();
  }

  // ---- progress ----------------------------------------------------------

  /// Marks a lesson as at least [percent] complete for a student (never
  /// lowers an existing value).
  Future<void> upsertLessonProgress({
    required int studentId,
    required int lessonId,
    required int percent,
    required bool completed,
  }) async {
    final existing = await (select(lessonProgress)
          ..where((t) =>
              t.studentId.equals(studentId) & t.lessonId.equals(lessonId)))
        .getSingleOrNull();

    final newPercent =
        existing == null ? percent : (percent > existing.percent ? percent : existing.percent);
    final newCompleted = (existing?.completed ?? false) || completed;

    if (existing == null) {
      await into(lessonProgress).insert(
        LessonProgressCompanion.insert(
          studentId: studentId,
          lessonId: lessonId,
          percent: Value(newPercent),
          completed: Value(newCompleted),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      // Update the existing row by its primary key. Using insertOnConflictUpdate
      // would not resolve the UNIQUE(studentId, lessonId) index conflict.
      await (update(lessonProgress)..where((t) => t.id.equals(existing.id)))
          .write(
        LessonProgressCompanion(
          percent: Value(newPercent),
          completed: Value(newCompleted),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<List<LessonProgressData>> progressForStudent(int studentId) {
    return (select(lessonProgress)
          ..where((t) => t.studentId.equals(studentId)))
        .get();
  }

  // ---- quizzes -----------------------------------------------------------

  Future<int> insertQuizAttempt({
    required int studentId,
    required int lessonId,
    required int score,
    required int total,
  }) {
    return into(quizAttempts).insert(
      QuizAttemptsCompanion.insert(
        studentId: studentId,
        lessonId: lessonId,
        score: score,
        total: total,
        finishedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> insertQuizAnswer({
    required int attemptId,
    required int questionId,
    required int selectedIndex,
    required bool isCorrect,
  }) {
    return into(quizAnswers).insert(
      QuizAnswersCompanion.insert(
        attemptId: attemptId,
        questionId: questionId,
        selectedIndex: selectedIndex,
        isCorrect: isCorrect,
      ),
    );
  }

  Future<QuizAttempt?> quizAttemptById(int id) {
    return (select(quizAttempts)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<QuizAttempt>> attemptsForStudent(int studentId) {
    return (select(quizAttempts)
          ..where((t) => t.studentId.equals(studentId)))
        .get();
  }

  // ---- downloads ---------------------------------------------------------

  Stream<List<Download>> watchDownloads() {
    return (select(downloads)).watch();
  }

  Future<List<Download>> allDownloads() {
    return (select(downloads)).get();
  }

  Future<void> setDownloaded({
    required int grade,
    required int subjectId,
    required bool isDownloaded,
    required int sizeBytes,
  }) async {
    final existing = await (select(downloads)
          ..where((t) => t.subjectId.equals(subjectId)))
        .getSingleOrNull();
    if (existing == null) {
      await into(downloads).insert(
        DownloadsCompanion.insert(
          grade: grade,
          subjectId: subjectId,
          isDownloaded: Value(isDownloaded),
          sizeBytes: Value(isDownloaded ? sizeBytes : 0),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      // Update by primary key — insertOnConflictUpdate would not resolve the
      // UNIQUE(subjectId) index conflict.
      await (update(downloads)..where((t) => t.id.equals(existing.id))).write(
        DownloadsCompanion(
          grade: Value(grade),
          isDownloaded: Value(isDownloaded),
          sizeBytes: Value(isDownloaded ? sizeBytes : 0),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  // ---- favorites ---------------------------------------------------------

  Future<bool> isFavorite(int studentId, int lessonId) async {
    final row = await (select(favorites)
          ..where((t) =>
              t.studentId.equals(studentId) & t.lessonId.equals(lessonId)))
        .getSingleOrNull();
    return row != null;
  }

  Future<List<int>> favoriteLessonIds(int studentId) async {
    final rows = await (select(favorites)
          ..where((t) => t.studentId.equals(studentId)))
        .get();
    return rows.map((r) => r.lessonId).toList();
  }

  /// Toggles a favorite and returns the new state (true = now favorited).
  Future<bool> toggleFavorite(int studentId, int lessonId) async {
    final existing = await (select(favorites)
          ..where((t) =>
              t.studentId.equals(studentId) & t.lessonId.equals(lessonId)))
        .getSingleOrNull();
    if (existing != null) {
      await (delete(favorites)..where((t) => t.id.equals(existing.id))).go();
      return false;
    }
    await into(favorites).insert(
      FavoritesCompanion.insert(studentId: studentId, lessonId: lessonId),
    );
    return true;
  }

  // ---- tutor chat history ------------------------------------------------

  Future<void> insertTutorMessage({
    required int studentId,
    required bool fromAi,
    required String content,
  }) {
    return into(tutorMessages).insert(
      TutorMessagesCompanion.insert(
        studentId: studentId,
        fromAi: fromAi,
        content: content,
      ),
    );
  }

  Future<List<TutorMessage>> recentTutorMessages(int studentId,
      {int limit = 100}) async {
    final rows = await (select(tutorMessages)
          ..where((t) => t.studentId.equals(studentId))
          ..orderBy([(t) => OrderingTerm(expression: t.id)])
          ..limit(limit))
        .get();
    return rows;
  }

  Future<void> clearTutorMessages(int studentId) {
    return (delete(tutorMessages)..where((t) => t.studentId.equals(studentId)))
        .go();
  }

  // ---- understanding checks (adaptive signals) ---------------------------

  Future<void> insertUnderstandingCheck({
    required int studentId,
    int? lessonId,
    required bool isCorrect,
  }) {
    return into(understandingChecks).insert(
      UnderstandingChecksCompanion.insert(
        studentId: studentId,
        lessonId: Value(lessonId),
        isCorrect: isCorrect,
      ),
    );
  }

  Future<List<UnderstandingCheck>> understandingChecksForLesson(
      int studentId, int lessonId) {
    return (select(understandingChecks)
          ..where((t) =>
              t.studentId.equals(studentId) & t.lessonId.equals(lessonId)))
        .get();
  }

  // ---- content packages --------------------------------------------------

  Future<List<InstalledPackage>> allInstalledPackages() =>
      select(installedPackages).get();

  Future<InstalledPackage?> installedPackageById(String packageId) {
    return (select(installedPackages)
          ..where((t) => t.packageId.equals(packageId)))
        .getSingleOrNull();
  }

  /// Records (or updates) installed-package metadata by its stable [packageId].
  Future<void> upsertInstalledPackage({
    required String packageId,
    required int grade,
    required String title,
    required String version,
    required String province,
    required bool isDemo,
    required int sizeBytes,
  }) async {
    final existing = await installedPackageById(packageId);
    if (existing == null) {
      await into(installedPackages).insert(
        InstalledPackagesCompanion.insert(
          packageId: packageId,
          grade: grade,
          title: title,
          version: version,
          province: Value(province),
          isDemo: Value(isDemo),
          sizeBytes: Value(sizeBytes),
        ),
      );
    } else {
      await (update(installedPackages)..where((t) => t.id.equals(existing.id)))
          .write(
        InstalledPackagesCompanion(
          grade: Value(grade),
          title: Value(title),
          version: Value(version),
          province: Value(province),
          isDemo: Value(isDemo),
          sizeBytes: Value(sizeBytes),
          installedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<void> deleteInstalledPackage(String packageId) {
    return (delete(installedPackages)
          ..where((t) => t.packageId.equals(packageId)))
        .go();
  }

  // ---- sync queue --------------------------------------------------------

  Future<int> enqueueSync({required String kind, required String payload}) {
    return into(syncQueueRows).insert(
      SyncQueueRowsCompanion.insert(kind: kind, payload: payload),
    );
  }

  Future<List<SyncQueueRow>> syncRowsByStatus(String status) {
    return (select(syncQueueRows)
          ..where((t) => t.syncStatus.equals(status))
          ..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .get();
  }

  Future<List<SyncQueueRow>> pendingSyncRows() => syncRowsByStatus('pending');

  Future<List<SyncQueueRow>> allSyncRows() => select(syncQueueRows).get();

  Future<void> markSyncRow(
    int id, {
    required String status,
    required int attempts,
    bool synced = false,
  }) {
    return (update(syncQueueRows)..where((t) => t.id.equals(id))).write(
      SyncQueueRowsCompanion(
        syncStatus: Value(status),
        attempts: Value(attempts),
        updatedAt: Value(DateTime.now()),
        lastSyncedAt: synced ? Value(DateTime.now()) : const Value.absent(),
      ),
    );
  }

  /// Re-queues failed rows for another attempt. Data is never dropped.
  Future<void> retryFailedSyncRows() {
    return (update(syncQueueRows)
          ..where((t) => t.syncStatus.equals('failed')))
        .write(const SyncQueueRowsCompanion(syncStatus: Value('pending')));
  }

  // ---- achievements ------------------------------------------------------

  Future<List<Achievement>> achievementsForStudent(int studentId) {
    return (select(achievements)
          ..where((t) => t.studentId.equals(studentId))
          ..orderBy([(t) => OrderingTerm(expression: t.unlockedAt)]))
        .get();
  }

  /// Unlocks an achievement if not already unlocked. Returns true when newly
  /// unlocked (so the UI can celebrate), false if it already existed.
  Future<bool> unlockAchievement({
    required int studentId,
    required String code,
    required int points,
  }) async {
    final existing = await (select(achievements)
          ..where((t) =>
              t.studentId.equals(studentId) & t.code.equals(code)))
        .getSingleOrNull();
    if (existing != null) return false;
    await into(achievements).insert(
      AchievementsCompanion.insert(
        studentId: studentId,
        code: code,
        points: Value(points),
      ),
    );
    return true;
  }

  // ---- student -----------------------------------------------------------

  Future<Student?> currentStudent() {
    return (select(students)
          ..orderBy([(t) => OrderingTerm(expression: t.id)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> createStudent({
    required String name,
    required int grade,
    required String languageCode,
    int avatarSeed = 0,
    String? school,
    String? className,
  }) {
    return into(students).insert(
      StudentsCompanion.insert(
        name: name,
        grade: grade,
        languageCode: languageCode,
        avatarSeed: Value(avatarSeed),
        school: Value(school),
        className: Value(className),
      ),
    );
  }

  Future<void> updateStudent(Student student) {
    return update(students).replace(student);
  }
}
