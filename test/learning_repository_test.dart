import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parho_kp/data/database/app_database.dart';
import 'package:parho_kp/data/models/view_models.dart';
import 'package:parho_kp/data/repositories/learning_repository.dart';
import 'package:parho_kp/data/seed/demo_content.dart';

void main() {
  late AppDatabase db;
  late LearningRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = LearningRepository(db);
    await seedDemoContentIfNeeded(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('demo content seeds Grade 5 subjects', () async {
    final subjects = await repo.subjectsForGrade(demoGrade);
    expect(subjects.length, 6);
    final codes = subjects.map((s) => s.code).toSet();
    expect(
      codes,
      containsAll(['urdu', 'english', 'math', 'science', 'islamiat', 'gk']),
    );
  });

  test('seeding is idempotent', () async {
    await seedDemoContentIfNeeded(db); // run again
    final subjects = await repo.subjectsForGrade(demoGrade);
    expect(subjects.length, 6, reason: 'must not duplicate on second seed');
  });

  test('every lesson is marked as demo content', () async {
    final subjects = await repo.subjectsForGrade(demoGrade);
    for (final s in subjects) {
      final lessons = await db.lessonsForSubject(s.id);
      for (final l in lessons) {
        expect(l.isDemo, isTrue);
      }
    }
  });

  test('quiz scoring persists an attempt and computes the score', () async {
    final student =
        await repo.createStudent(name: 'Ahmad', grade: 5, languageCode: 'en');

    final math = (await repo.subjectsForGrade(5))
        .firstWhere((s) => s.code == 'math');
    final lessons = await db.lessonsForSubject(math.id);
    final fractions = lessons.firstWhere(
        (l) => l.titleEn.toLowerCase().contains('fraction'));
    final questions = await repo.questionsForLesson(fractions.id);
    expect(questions, isNotEmpty);

    // Answer every question correctly.
    final selected = questions.map((q) => q.correctIndex).toList();
    final attemptId = await repo.saveQuizResult(
      studentId: student,
      lessonId: fractions.id,
      questions: questions,
      selected: selected,
    );

    final attempt = await repo.attempt(attemptId);
    expect(attempt, isNotNull);
    expect(attempt!.score, questions.length);
    expect(attempt.total, questions.length);
  });

  test('progress is computed from completed lessons, not hardcoded', () async {
    final student =
        await repo.createStudent(name: 'Sana', grade: 5, languageCode: 'en');
    final studentRow = await repo.currentStudent();
    expect(studentRow, isNotNull);

    // Initially zero.
    final before = await repo.overallPercent(studentRow!);
    expect(before, 0);

    // Complete one lesson fully.
    final science = (await repo.subjectsForGrade(5))
        .firstWhere((s) => s.code == 'science');
    final lesson = (await db.lessonsForSubject(science.id)).first;
    await repo.markLessonProgress(student, lesson.id, completed: true);

    final sciencePercent = await repo.subjectPercent(student, science.id);
    expect(sciencePercent, greaterThan(0));

    final after = await repo.overallPercent(studentRow);
    expect(after, greaterThan(before));
  });

  test('opening a lesson then finishing its quiz does not crash (regression)',
      () async {
    // Reproduces a UNIQUE(studentId, lessonId) conflict: opening a lesson
    // writes a progress row, then the quiz updates the same row.
    final student =
        await repo.createStudent(name: 'Zoya', grade: 5, languageCode: 'en');
    final math = (await repo.subjectsForGrade(5))
        .firstWhere((s) => s.code == 'math');
    final lesson = (await db.lessonsForSubject(math.id)).first;

    // Open the lesson (creates lesson_progress at 50%).
    await repo.markLessonProgress(student, lesson.id, completed: false);
    // Finish its quiz (must UPDATE the same row, not insert a duplicate).
    final questions = await repo.questionsForLesson(lesson.id);
    await repo.saveQuizResult(
      studentId: student,
      lessonId: lesson.id,
      questions: questions,
      selected: questions.map((q) => q.correctIndex).toList(),
    );

    // Exactly one progress row for this student+lesson, marked completed.
    final progress = await db.progressForStudent(student);
    final rows = progress.where((p) => p.lessonId == lesson.id).toList();
    expect(rows.length, 1);
    expect(rows.first.completed, isTrue);
  });

  test('toggling a download twice does not crash (regression)', () async {
    final science = (await repo.subjectsForGrade(5))
        .firstWhere((s) => s.code == 'science');
    // Download, then delete, then download again — each is an upsert on the
    // UNIQUE(subjectId) index.
    await repo.setDownloaded(5, science.id, true);
    await repo.setDownloaded(5, science.id, false);
    await repo.setDownloaded(5, science.id, true);

    final states = await repo.downloadStates(5);
    final row = states.firstWhere((d) => d.subject.id == science.id);
    expect(row.isDownloaded, isTrue);
    // Only one downloads row exists for the subject.
    final all = await db.allDownloads();
    expect(all.where((d) => d.subjectId == science.id).length, 1);
  });

  test('status buckets map percentages correctly', () {
    expect(statusFromPercent(80), ProgressStatus.strong);
    expect(statusFromPercent(50), ProgressStatus.improving);
    expect(statusFromPercent(10), ProgressStatus.needsPractice);
  });

  test('continue target points to a not-completed lesson', () async {
    final student =
        await repo.createStudent(name: 'Bilal', grade: 5, languageCode: 'en');
    final studentRow = await repo.currentStudent();
    final target = await repo.continueTarget(studentRow!);
    expect(target, isNotNull);
    // With no progress yet, the first lesson should be offered.
    expect(target!.percent, 0);
    expect(student, isPositive);
  });
}
