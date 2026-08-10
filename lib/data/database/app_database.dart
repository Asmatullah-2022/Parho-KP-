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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  /// Test/alternate constructor allowing a custom executor (e.g. in-memory).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

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
  }) {
    return into(students).insert(
      StudentsCompanion.insert(
        name: name,
        grade: grade,
        languageCode: languageCode,
        avatarSeed: Value(avatarSeed),
      ),
    );
  }

  Future<void> updateStudent(Student student) {
    return update(students).replace(student);
  }
}
