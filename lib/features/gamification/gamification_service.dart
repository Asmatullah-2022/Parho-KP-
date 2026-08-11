import '../../data/database/app_database.dart';

/// A single achievement the student can unlock. Definitions are stable (their
/// [code] is stored in the DB); the UI resolves localized titles from the code.
class AchievementDef {
  const AchievementDef({
    required this.code,
    required this.emoji,
    required this.points,
    required this.titleEn,
  });

  final String code;
  final String emoji;
  final int points;

  /// English fallback title (the UI prefers a localized string keyed by code).
  final String titleEn;
}

/// The fixed achievement catalog. Deliberately encouraging and finite — points
/// reward learning milestones with **no gambling or addictive mechanics**
/// (no random rewards, no streak-loss punishment, no timers pushing usage).
class AchievementCatalog {
  static const firstLesson = AchievementDef(
    code: 'first_lesson',
    emoji: '📖',
    points: 10,
    titleEn: 'First Lesson',
  );
  static const firstQuiz = AchievementDef(
    code: 'first_quiz',
    emoji: '📝',
    points: 10,
    titleEn: 'First Quiz',
  );
  static const perfectScore = AchievementDef(
    code: 'perfect_score',
    emoji: '⭐',
    points: 25,
    titleEn: 'Perfect Score',
  );
  static const fiveLessons = AchievementDef(
    code: 'five_lessons',
    emoji: '🏅',
    points: 20,
    titleEn: '5 Lessons Completed',
  );
  static const tenLessons = AchievementDef(
    code: 'ten_lessons',
    emoji: '🏆',
    points: 40,
    titleEn: '10 Lessons Completed',
  );
  static const sevenDayStreak = AchievementDef(
    code: 'seven_day_streak',
    emoji: '🔥',
    points: 50,
    titleEn: '7-Day Streak',
  );

  static const all = <AchievementDef>[
    firstLesson,
    firstQuiz,
    perfectScore,
    fiveLessons,
    tenLessons,
    sevenDayStreak,
  ];

  static AchievementDef? byCode(String code) {
    for (final a in all) {
      if (a.code == code) return a;
    }
    return null;
  }
}

/// Computes the longest run of consecutive calendar days in [days] (which may
/// contain duplicates and be unsorted). Pure and deterministic.
int longestDailyStreak(Iterable<DateTime> days) {
  final set = <int>{}; // days since epoch
  for (final d in days) {
    final utc = DateTime.utc(d.year, d.month, d.day);
    set.add(utc.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay);
  }
  if (set.isEmpty) return 0;
  final sorted = set.toList()..sort();
  var best = 1;
  var run = 1;
  for (var i = 1; i < sorted.length; i++) {
    if (sorted[i] == sorted[i - 1] + 1) {
      run++;
      if (run > best) best = run;
    } else {
      run = 1;
    }
  }
  return best;
}

/// Evaluates and unlocks achievements from local learning data. Deterministic
/// and offline. Newly unlocked achievements are returned so the UI can
/// celebrate them.
class GamificationService {
  GamificationService(this.db);
  final AppDatabase db;

  Future<List<Achievement>> unlocked(int studentId) =>
      db.achievementsForStudent(studentId);

  /// Total points from unlocked achievements.
  Future<int> totalPoints(int studentId) async {
    final rows = await db.achievementsForStudent(studentId);
    return rows.fold<int>(0, (a, b) => a + b.points);
  }

  /// Re-evaluates all achievements for [studentId] against current data,
  /// unlocking any newly earned. Returns the defs that were newly unlocked.
  Future<List<AchievementDef>> evaluate(int studentId) async {
    final progress = await db.progressForStudent(studentId);
    final completed = progress.where((p) => p.completed).length;
    final attempts = await db.attemptsForStudent(studentId);
    final hasPerfect =
        attempts.any((a) => a.total > 0 && a.score == a.total);

    // Activity days for the streak: quiz attempts + progress updates.
    final activityDays = <DateTime>[
      for (final a in attempts) a.finishedAt ?? a.startedAt,
      for (final p in progress) p.updatedAt,
    ];
    final streak = longestDailyStreak(activityDays);

    final toUnlock = <AchievementDef>[];
    void consider(bool earned, AchievementDef def) {
      if (earned) toUnlock.add(def);
    }

    consider(completed >= 1, AchievementCatalog.firstLesson);
    consider(attempts.isNotEmpty, AchievementCatalog.firstQuiz);
    consider(hasPerfect, AchievementCatalog.perfectScore);
    consider(completed >= 5, AchievementCatalog.fiveLessons);
    consider(completed >= 10, AchievementCatalog.tenLessons);
    consider(streak >= 7, AchievementCatalog.sevenDayStreak);

    final newlyUnlocked = <AchievementDef>[];
    for (final def in toUnlock) {
      final isNew = await db.unlockAchievement(
        studentId: studentId,
        code: def.code,
        points: def.points,
      );
      if (isNew) newlyUnlocked.add(def);
    }
    return newlyUnlocked;
  }
}
