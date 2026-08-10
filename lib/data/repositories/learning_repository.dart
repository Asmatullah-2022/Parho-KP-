import '../content/content_importer.dart';
import '../database/app_database.dart';
import '../models/view_models.dart';

/// Central data access + progress computation for the learning content.
///
/// Wraps [AppDatabase] and adds the derived values the UI needs (subject/overall
/// progress, the "continue learning" target, offline states). All progress is
/// computed from `lesson_progress` + `quiz_attempts` — never hardcoded.
class LearningRepository {
  LearningRepository(this.db);
  final AppDatabase db;

  Future<Student?> currentStudent() => db.currentStudent();

  Future<int> createStudent({
    required String name,
    required int grade,
    required String languageCode,
  }) {
    return db.createStudent(
      name: name,
      grade: grade,
      languageCode: languageCode,
    );
  }

  /// Updates the current student's editable profile fields.
  Future<void> updateStudentProfile({
    required int studentId,
    required String name,
    required int grade,
    required String languageCode,
  }) async {
    final existing = await db.currentStudent();
    if (existing == null || existing.id != studentId) return;
    await db.updateStudent(
      existing.copyWith(name: name, grade: grade, languageCode: languageCode),
    );
  }

  Future<List<Subject>> subjectsForGrade(int grade) =>
      db.subjectsForGrade(grade);

  /// Imports an additional content package from JSON text (bundled asset,
  /// downloaded package, or future server response). Replaces that grade's
  /// content so re-import updates cleanly. Works fully offline.
  Future<void> importContentPackageFromJson(String jsonText) async {
    final importer = ContentImporter(db);
    // Parse first, then replace the grade in one go.
    await importer.importJson(jsonText);
  }

  /// All subjects for a grade, each paired with its lessons (for the Quiz hub).
  Future<List<({Subject subject, List<Lesson> lessons})>> lessonsBySubject(
      int grade) async {
    final subjects = await db.subjectsForGrade(grade);
    final result = <({Subject subject, List<Lesson> lessons})>[];
    for (final subject in subjects) {
      final lessons = await db.lessonsForSubject(subject.id);
      result.add((subject: subject, lessons: lessons));
    }
    return result;
  }

  Future<Subject?> subjectById(int id) => db.subjectById(id);

  Future<Lesson?> lessonById(int id) => db.lessonById(id);

  /// A lesson together with the subject it belongs to (for headers).
  Future<({Lesson lesson, Subject? subject})?> lessonWithSubject(
      int lessonId) async {
    final lesson = await db.lessonById(lessonId);
    if (lesson == null) return null;
    final unit = await db.unitById(lesson.unitId);
    final subject =
        unit == null ? null : await db.subjectById(unit.subjectId);
    return (lesson: lesson, subject: subject);
  }

  Future<List<Question>> questionsForLesson(int lessonId) =>
      db.questionsForLesson(lessonId);

  /// Percentage complete for one subject: fraction of its lessons the student
  /// has completed, averaged with in-progress percentages.
  Future<int> subjectPercent(int studentId, int subjectId) async {
    final lessons = await db.lessonsForSubject(subjectId);
    if (lessons.isEmpty) return 0;
    final progress = await db.progressForStudent(studentId);
    final byLesson = {for (final p in progress) p.lessonId: p};
    var sum = 0;
    for (final lesson in lessons) {
      sum += byLesson[lesson.id]?.percent ?? 0;
    }
    return (sum / lessons.length).round();
  }

  /// All subjects for the student's grade with their computed progress.
  Future<List<SubjectProgress>> subjectProgressList(Student student) async {
    final subjects = await db.subjectsForGrade(student.grade);
    final result = <SubjectProgress>[];
    for (final subject in subjects) {
      final percent = await subjectPercent(student.id, subject.id);
      result.add(SubjectProgress(subject: subject, percent: percent));
    }
    return result;
  }

  /// Overall progress across all subjects for the student's grade.
  Future<int> overallPercent(Student student) async {
    final list = await subjectProgressList(student);
    if (list.isEmpty) return 0;
    final sum = list.fold<int>(0, (a, b) => a + b.percent);
    return (sum / list.length).round();
  }

  /// Full subject detail (units + lessons + completion) for one subject.
  Future<SubjectDetail?> subjectDetail(int studentId, int subjectId) async {
    final subject = await db.subjectById(subjectId);
    if (subject == null) return null;
    final units = await db.unitsForSubject(subjectId);
    final progress = await db.progressForStudent(studentId);
    final completed = {
      for (final p in progress)
        if (p.completed) p.lessonId,
    };
    final unitViews = <UnitWithLessons>[];
    for (final unit in units) {
      final lessons = await db.lessonsForUnit(unit.id);
      unitViews.add(UnitWithLessons(
        unit: unit,
        lessons: lessons,
        completedLessonIds: completed,
      ));
    }
    final percent = await subjectPercent(studentId, subjectId);
    return SubjectDetail(subject: subject, units: unitViews, percent: percent);
  }

  /// The next lesson to continue.
  ///
  /// Prefers the student's **most recently started but not-completed** lesson
  /// (by `lesson_progress.updatedAt`). Falls back to the first not-completed
  /// lesson in course order, or the very first lesson if everything is done.
  Future<ContinueTarget?> continueTarget(Student student) async {
    final subjects = await db.subjectsForGrade(student.grade);
    final progress = await db.progressForStudent(student.id);
    final byLesson = {for (final p in progress) p.lessonId: p};

    // 1) Most recently updated incomplete progress row.
    final incomplete = progress.where((p) => !p.completed).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    for (final p in incomplete) {
      final ctx = await lessonWithSubject(p.lessonId);
      if (ctx?.subject != null) {
        return ContinueTarget(
          subject: ctx!.subject!,
          lesson: ctx.lesson,
          percent: p.percent,
        );
      }
    }

    // 2) First not-completed lesson in course order (nothing started yet).
    Lesson? firstEver;
    Subject? firstEverSubject;

    for (final subject in subjects) {
      final lessons = await db.lessonsForSubject(subject.id);
      for (final lesson in lessons) {
        firstEver ??= lesson;
        firstEverSubject ??= subject;
        final p = byLesson[lesson.id];
        if (p == null || !p.completed) {
          return ContinueTarget(
            subject: subject,
            lesson: lesson,
            percent: p?.percent ?? 0,
          );
        }
      }
    }
    if (firstEver != null && firstEverSubject != null) {
      return ContinueTarget(
        subject: firstEverSubject,
        lesson: firstEver,
        percent: byLesson[firstEver.id]?.percent ?? 100,
      );
    }
    return null;
  }

  /// Marks a lesson as opened (at least 50%) or completed (100%).
  Future<void> markLessonProgress(
    int studentId,
    int lessonId, {
    required bool completed,
  }) {
    return db.upsertLessonProgress(
      studentId: studentId,
      lessonId: lessonId,
      percent: completed ? 100 : 50,
      completed: completed,
    );
  }

  /// Persists a finished quiz and its answers, and marks the lesson completed
  /// if the student passed (>= 60%).
  Future<int> saveQuizResult({
    required int studentId,
    required int lessonId,
    required List<Question> questions,
    required List<int> selected, // selected index per question, -1 if skipped
  }) async {
    var score = 0;
    for (var i = 0; i < questions.length; i++) {
      if (selected[i] == questions[i].correctIndex) score++;
    }
    final attemptId = await db.insertQuizAttempt(
      studentId: studentId,
      lessonId: lessonId,
      score: score,
      total: questions.length,
    );
    for (var i = 0; i < questions.length; i++) {
      await db.insertQuizAnswer(
        attemptId: attemptId,
        questionId: questions[i].id,
        selectedIndex: selected[i],
        isCorrect: selected[i] == questions[i].correctIndex,
      );
    }
    final percent =
        questions.isEmpty ? 0 : ((score / questions.length) * 100).round();
    await db.upsertLessonProgress(
      studentId: studentId,
      lessonId: lessonId,
      percent: percent,
      completed: percent >= 60,
    );
    return attemptId;
  }

  Future<QuizAttempt?> attempt(int id) => db.quizAttemptById(id);

  /// The student's most recent quiz score (0-100) for a lesson, or null.
  Future<int?> latestQuizPercent(int studentId, int lessonId) async {
    final attempts = (await db.attemptsForStudent(studentId))
        .where((a) => a.lessonId == lessonId)
        .toList()
      ..sort((a, b) => b.id.compareTo(a.id));
    if (attempts.isEmpty) return null;
    final a = attempts.first;
    return a.total == 0 ? 0 : ((a.score / a.total) * 100).round();
  }

  /// Builds a full learning report for [student] from local data only.
  Future<StudentReport> buildStudentReport(Student student) async {
    final subjects = await subjectProgressList(student);
    final overall = subjects.isEmpty
        ? 0
        : (subjects.fold<int>(0, (a, b) => a + b.percent) / subjects.length)
            .round();

    final allLessons = <Lesson>[];
    for (final sp in subjects) {
      allLessons.addAll(await db.lessonsForSubject(sp.subject.id));
    }
    final progress = await db.progressForStudent(student.id);
    final completed = progress.where((p) => p.completed).map((p) => p.lessonId).toSet();
    final lessonIds = allLessons.map((l) => l.id).toSet();
    final lessonsCompleted =
        completed.where(lessonIds.contains).length;

    final attempts = await db.attemptsForStudent(student.id);
    final quizAvg = attempts.isEmpty
        ? 0
        : (attempts
                    .map((a) => a.total == 0 ? 0 : (a.score / a.total) * 100)
                    .fold<double>(0, (a, b) => a + b) /
                attempts.length)
            .round();

    final strong = subjects.where((s) => s.status == ProgressStatus.strong).toList()
      ..sort((a, b) => b.percent.compareTo(a.percent));
    final needs = subjects
        .where((s) => s.status == ProgressStatus.needsPractice)
        .toList()
      ..sort((a, b) => a.percent.compareTo(b.percent));

    // Recent activity from the latest quiz attempts.
    final byId = {for (final l in allLessons) l.id: l};
    final recent = attempts.toList()
      ..sort((a, b) => b.id.compareTo(a.id));
    final activity = <ActivityEntry>[];
    for (final a in recent.take(5)) {
      final lesson = byId[a.lessonId];
      final title = lesson?.titleEn ?? 'Quiz';
      final pct = a.total == 0 ? 0 : ((a.score / a.total) * 100).round();
      activity.add(ActivityEntry(
        title: title,
        detail: '${a.score}/${a.total} ($pct%)',
        when: a.finishedAt ?? a.startedAt,
      ));
    }

    final next = await continueTarget(student);

    return StudentReport(
      student: student,
      overallPercent: overall,
      subjects: subjects,
      lessonsCompleted: lessonsCompleted,
      totalLessons: allLessons.length,
      quizAveragePercent: quizAvg,
      quizzesTaken: attempts.length,
      strong: strong,
      needsPractice: needs,
      recentActivity: activity,
      nextLesson: next,
    );
  }

  // ---- offline downloads -------------------------------------------------

  Future<List<DownloadState>> downloadStates(int grade) async {
    final subjects = await db.subjectsForGrade(grade);
    final downloads = await db.allDownloads();
    final bySubject = {for (final d in downloads) d.subjectId: d};
    return subjects
        .map((s) => DownloadState(
              subject: s,
              isDownloaded: bySubject[s.id]?.isDownloaded ?? false,
              sizeBytes: bySubject[s.id]?.sizeBytes ?? 0,
            ))
        .toList();
  }

  Future<void> setDownloaded(int grade, int subjectId, bool value) {
    // Estimated size — content is text-only, so downloads are tiny.
    return db.setDownloaded(
      grade: grade,
      subjectId: subjectId,
      isDownloaded: value,
      sizeBytes: value ? 250 * 1024 : 0,
    );
  }

  // ---- favorites ---------------------------------------------------------

  Future<bool> isFavorite(int studentId, int lessonId) =>
      db.isFavorite(studentId, lessonId);

  Future<bool> toggleFavorite(int studentId, int lessonId) =>
      db.toggleFavorite(studentId, lessonId);

  /// Favorite lessons for a student, each paired with its subject (for display).
  Future<List<({Lesson lesson, Subject? subject})>> favoriteLessons(
      int studentId) async {
    final ids = await db.favoriteLessonIds(studentId);
    final lessonRows = await db.lessonsByIds(ids);
    final result = <({Lesson lesson, Subject? subject})>[];
    for (final lesson in lessonRows) {
      final unit = await db.unitById(lesson.unitId);
      final subject =
          unit == null ? null : await db.subjectById(unit.subjectId);
      result.add((lesson: lesson, subject: subject));
    }
    return result;
  }

  // ---- AI tutor: chat history --------------------------------------------

  Future<void> saveTutorMessage(int studentId, bool fromAi, String content) =>
      db.insertTutorMessage(
          studentId: studentId, fromAi: fromAi, content: content);

  Future<List<TutorMessage>> recentTutorMessages(int studentId) =>
      db.recentTutorMessages(studentId);

  Future<void> clearTutorMessages(int studentId) =>
      db.clearTutorMessages(studentId);

  // ---- AI tutor: understanding checks + adaptive learning ----------------

  Future<void> saveUnderstandingCheck(
    int studentId,
    int? lessonId,
    bool isCorrect,
  ) =>
      db.insertUnderstandingCheck(
          studentId: studentId, lessonId: lessonId, isCorrect: isCorrect);

  /// A simple local adaptive signal for a lesson, from understanding checks and
  /// the latest quiz score. Repeated mistakes → review; strong results → ready.
  Future<AdaptiveRecommendation> adaptiveRecommendation(
      int studentId, int lessonId) async {
    final checks = await db.understandingChecksForLesson(studentId, lessonId);
    var correct = checks.where((c) => c.isCorrect).length;
    var wrong = checks.length - correct;

    // Fold in the most recent quiz attempt for this lesson, if any.
    final attempts = (await db.attemptsForStudent(studentId))
        .where((a) => a.lessonId == lessonId)
        .toList()
      ..sort((a, b) => b.id.compareTo(a.id));
    if (attempts.isNotEmpty) {
      final a = attempts.first;
      correct += a.score;
      wrong += (a.total - a.score);
    }

    if (correct + wrong == 0) return AdaptiveRecommendation.keepGoing;
    if (wrong >= 2 && wrong >= correct) return AdaptiveRecommendation.review;
    if (correct >= 2 && correct > wrong) return AdaptiveRecommendation.ready;
    return AdaptiveRecommendation.keepGoing;
  }

  // ---- search ------------------------------------------------------------

  /// Offline search over all lessons in the student's grade. Matches the query
  /// against lesson title/objective and the subject name in any language.
  Future<List<({Lesson lesson, Subject? subject})>> searchLessons(
      int grade, String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    final subjects = await db.subjectsForGrade(grade);
    final results = <({Lesson lesson, Subject? subject})>[];
    for (final subject in subjects) {
      final subjectHay =
          '${subject.nameEn} ${subject.nameUr} ${subject.namePs}'.toLowerCase();
      final lessonRows = await db.lessonsForSubject(subject.id);
      for (final lesson in lessonRows) {
        final hay = '${lesson.titleEn} ${lesson.titleUr} ${lesson.titlePs} '
                '${lesson.objectiveEn} ${lesson.objectiveUr} ${lesson.objectivePs} '
                '$subjectHay'
            .toLowerCase();
        if (hay.contains(q)) {
          results.add((lesson: lesson, subject: subject));
        }
      }
    }
    return results;
  }
}
