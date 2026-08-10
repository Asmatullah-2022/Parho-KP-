import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/providers/app_settings.dart';
import 'database/app_database.dart';
import 'models/view_models.dart';
import 'repositories/learning_repository.dart';

/// Holds the singleton [AppDatabase]. Overridden in `main()` with the instance
/// created (and seeded) during bootstrap.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final learningRepositoryProvider = Provider<LearningRepository>((ref) {
  return LearningRepository(ref.watch(databaseProvider));
});

/// The current (single) student profile, or null if setup is incomplete.
final currentStudentProvider = FutureProvider<Student?>((ref) async {
  return ref.watch(learningRepositoryProvider).currentStudent();
});

/// Convenience: the active content language code (follows Settings).
final languageCodeProvider = Provider<String>((ref) {
  return ref.watch(settingsControllerProvider).language.code;
});

/// Subjects for the current student's grade, with computed progress.
final subjectProgressListProvider =
    FutureProvider<List<SubjectProgress>>((ref) async {
  final repo = ref.watch(learningRepositoryProvider);
  final student = await ref.watch(currentStudentProvider.future);
  if (student == null) return [];
  return repo.subjectProgressList(student);
});

final overallPercentProvider = FutureProvider<int>((ref) async {
  final repo = ref.watch(learningRepositoryProvider);
  final student = await ref.watch(currentStudentProvider.future);
  if (student == null) return 0;
  return repo.overallPercent(student);
});

final continueTargetProvider = FutureProvider<ContinueTarget?>((ref) async {
  final repo = ref.watch(learningRepositoryProvider);
  final student = await ref.watch(currentStudentProvider.future);
  if (student == null) return null;
  return repo.continueTarget(student);
});

final subjectDetailProvider =
    FutureProvider.family<SubjectDetail?, int>((ref, subjectId) async {
  final repo = ref.watch(learningRepositoryProvider);
  final student = await ref.watch(currentStudentProvider.future);
  if (student == null) return null;
  return repo.subjectDetail(student.id, subjectId);
});

final lessonProvider =
    FutureProvider.family<Lesson?, int>((ref, lessonId) async {
  return ref.watch(learningRepositoryProvider).lessonById(lessonId);
});

final lessonWithSubjectProvider =
    FutureProvider.family<({Lesson lesson, Subject? subject})?, int>(
        (ref, lessonId) async {
  return ref.watch(learningRepositoryProvider).lessonWithSubject(lessonId);
});

final lessonQuestionsProvider =
    FutureProvider.family<List<Question>, int>((ref, lessonId) async {
  return ref.watch(learningRepositoryProvider).questionsForLesson(lessonId);
});

final lessonsBySubjectProvider = FutureProvider<
    List<({Subject subject, List<Lesson> lessons})>>((ref) async {
  final repo = ref.watch(learningRepositoryProvider);
  final student = await ref.watch(currentStudentProvider.future);
  if (student == null) return [];
  return repo.lessonsBySubject(student.grade);
});

final quizAttemptProvider =
    FutureProvider.family<QuizAttempt?, int>((ref, attemptId) async {
  return ref.watch(learningRepositoryProvider).attempt(attemptId);
});

final downloadStatesProvider =
    FutureProvider<List<DownloadState>>((ref) async {
  final repo = ref.watch(learningRepositoryProvider);
  final student = await ref.watch(currentStudentProvider.future);
  if (student == null) return [];
  return repo.downloadStates(student.grade);
});

/// Whether a given lesson is favorited by the current student.
final isFavoriteProvider =
    FutureProvider.family<bool, int>((ref, lessonId) async {
  final repo = ref.watch(learningRepositoryProvider);
  final student = await ref.watch(currentStudentProvider.future);
  if (student == null) return false;
  return repo.isFavorite(student.id, lessonId);
});

/// The current student's favorite lessons (with their subjects).
final favoriteLessonsProvider =
    FutureProvider<List<({Lesson lesson, Subject? subject})>>((ref) async {
  final repo = ref.watch(learningRepositoryProvider);
  final student = await ref.watch(currentStudentProvider.future);
  if (student == null) return [];
  return repo.favoriteLessons(student.id);
});

/// The current search query (offline lesson search).
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Search results for [searchQueryProvider] over the student's grade.
final searchResultsProvider =
    FutureProvider<List<({Lesson lesson, Subject? subject})>>((ref) async {
  final repo = ref.watch(learningRepositoryProvider);
  final student = await ref.watch(currentStudentProvider.future);
  final query = ref.watch(searchQueryProvider);
  if (student == null) return [];
  return repo.searchLessons(student.grade, query);
});

/// Full learning report for the current student.
final studentReportProvider = FutureProvider<StudentReport?>((ref) async {
  final repo = ref.watch(learningRepositoryProvider);
  final student = await ref.watch(currentStudentProvider.future);
  if (student == null) return null;
  return repo.buildStudentReport(student);
});

/// Bumped to force dependent providers to refetch after a write.
final refreshTickProvider = StateProvider<int>((ref) => 0);
