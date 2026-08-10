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

  Future<List<Subject>> subjectsForGrade(int grade) =>
      db.subjectsForGrade(grade);

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

  /// The next lesson to continue — the first not-completed lesson found across
  /// the student's subjects, or the very first lesson if all are done.
  Future<ContinueTarget?> continueTarget(Student student) async {
    final subjects = await db.subjectsForGrade(student.grade);
    final progress = await db.progressForStudent(student.id);
    final byLesson = {for (final p in progress) p.lessonId: p};

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

  // ---- offline downloads -------------------------------------------------

  Future<List<DownloadState>> downloadStates(int grade) async {
    final subjects = await db.subjectsForGrade(grade);
    final downloads = await db.watchDownloads().first;
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
}
