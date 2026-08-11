import '../../data/database/app_database.dart';

/// A concrete, deterministic next step for a learner.
enum LearningRecommendation {
  /// Struggling — revisit the lesson content.
  reviewLesson,

  /// Getting there — do more practice questions on the same lesson.
  practiceMore,

  /// Doing well — move on to the next lesson.
  tryNextLesson,

  /// Mastered the unit — ready to start the next unit.
  readyForNextUnit,
}

/// Signals fed into the recommender. Kept as a plain value object so the
/// decision is a pure, deterministic function that is trivial to test.
class LearningSignals {
  const LearningSignals({
    this.latestQuizPercent,
    this.understandingCorrect = 0,
    this.understandingWrong = 0,
    this.unitComplete = false,
  });

  final int? latestQuizPercent;
  final int understandingCorrect;
  final int understandingWrong;
  final bool unitComplete;
}

/// Deterministic learning recommender.
///
/// Given local signals only (no AI, no network), it always returns the same
/// recommendation for the same inputs — safe, explainable, and offline.
class LearningRecommender {
  const LearningRecommender();

  static const int reviewBelow = 50;
  static const int practiceBelow = 75;
  static const int masteryAtLeast = 80;

  LearningRecommendation recommend(LearningSignals s) {
    final quiz = s.latestQuizPercent;

    if (quiz != null) {
      if (quiz < reviewBelow) return LearningRecommendation.reviewLesson;
      if (quiz < practiceBelow) return LearningRecommendation.practiceMore;
      // quiz is strong.
      if (s.unitComplete && quiz >= masteryAtLeast) {
        return LearningRecommendation.readyForNextUnit;
      }
      return LearningRecommendation.tryNextLesson;
    }

    // No quiz yet — lean on understanding checks.
    final correct = s.understandingCorrect;
    final wrong = s.understandingWrong;
    if (correct + wrong == 0) return LearningRecommendation.practiceMore;
    if (wrong >= 2 && wrong >= correct) {
      return LearningRecommendation.reviewLesson;
    }
    if (correct >= 2 && correct > wrong) {
      if (s.unitComplete) return LearningRecommendation.readyForNextUnit;
      return LearningRecommendation.tryNextLesson;
    }
    return LearningRecommendation.practiceMore;
  }
}

/// Builds [LearningSignals] from local data and applies the deterministic
/// [LearningRecommender]. Offline-only.
class LearningRecommendationService {
  LearningRecommendationService(
    this.db, {
    this.recommender = const LearningRecommender(),
  });

  final AppDatabase db;
  final LearningRecommender recommender;

  Future<LearningRecommendation> recommendForLesson(
    int studentId,
    int lessonId,
  ) async {
    final signals = await signalsForLesson(studentId, lessonId);
    return recommender.recommend(signals);
  }

  /// Gathers the deterministic signals for one lesson from local tables.
  Future<LearningSignals> signalsForLesson(int studentId, int lessonId) async {
    // Latest quiz percent for this lesson.
    final attempts = (await db.attemptsForStudent(studentId))
        .where((a) => a.lessonId == lessonId)
        .toList()
      ..sort((a, b) => b.id.compareTo(a.id));
    int? latestQuiz;
    if (attempts.isNotEmpty) {
      final a = attempts.first;
      latestQuiz = a.total == 0 ? 0 : ((a.score / a.total) * 100).round();
    }

    // Understanding checks for this lesson.
    final checks = await db.understandingChecksForLesson(studentId, lessonId);
    final correct = checks.where((c) => c.isCorrect).length;
    final wrong = checks.length - correct;

    // Is the rest of the lesson's unit complete?
    final unitComplete = await _isUnitComplete(studentId, lessonId);

    return LearningSignals(
      latestQuizPercent: latestQuiz,
      understandingCorrect: correct,
      understandingWrong: wrong,
      unitComplete: unitComplete,
    );
  }

  Future<bool> _isUnitComplete(int studentId, int lessonId) async {
    final lesson = await db.lessonById(lessonId);
    if (lesson == null) return false;
    final unitLessons = await db.lessonsForUnit(lesson.unitId);
    if (unitLessons.isEmpty) return false;
    final progress = await db.progressForStudent(studentId);
    final completed = {
      for (final p in progress)
        if (p.completed) p.lessonId,
    };
    return unitLessons.every((l) => completed.contains(l.id));
  }
}
