import '../database/app_database.dart';

/// Learning strength buckets derived from a percentage.
enum ProgressStatus { strong, improving, needsPractice }

/// Local adaptive-learning recommendation for the current lesson.
enum AdaptiveRecommendation { review, ready, keepGoing }

ProgressStatus statusFromPercent(int percent) {
  if (percent >= 75) return ProgressStatus.strong;
  if (percent >= 40) return ProgressStatus.improving;
  return ProgressStatus.needsPractice;
}

/// A subject together with its computed progress for the current student.
class SubjectProgress {
  const SubjectProgress({required this.subject, required this.percent});
  final Subject subject;
  final int percent;
  ProgressStatus get status => statusFromPercent(percent);
}

/// A unit together with the lessons it contains and their completion.
class UnitWithLessons {
  const UnitWithLessons({
    required this.unit,
    required this.lessons,
    required this.completedLessonIds,
  });
  final Unit unit;
  final List<Lesson> lessons;
  final Set<int> completedLessonIds;

  int get percent {
    if (lessons.isEmpty) return 0;
    final done = lessons.where((l) => completedLessonIds.contains(l.id)).length;
    return ((done / lessons.length) * 100).round();
  }
}

/// A subject with its units expanded (used on the subject-detail screen).
class SubjectDetail {
  const SubjectDetail({
    required this.subject,
    required this.units,
    required this.percent,
  });
  final Subject subject;
  final List<UnitWithLessons> units;
  final int percent;
}

/// The lesson the student should continue with next.
class ContinueTarget {
  const ContinueTarget({
    required this.subject,
    required this.lesson,
    required this.percent,
  });
  final Subject subject;
  final Lesson lesson;
  final int percent;
}

/// A subject's offline-download state.
class DownloadState {
  const DownloadState({
    required this.subject,
    required this.isDownloaded,
    required this.sizeBytes,
  });
  final Subject subject;
  final bool isDownloaded;
  final int sizeBytes;
}
