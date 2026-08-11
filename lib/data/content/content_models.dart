// Content model layer for Parho KP.
//
// These plain models describe a curriculum content package independently of
// how it is stored. A package can come from:
//   * the in-app demo catalog (original demo content),
//   * a bundled/downloaded JSON content package, or
//   * (in future) a secure content server.
//
// ContentImporter writes a ContentPackage into the local database, so the rest
// of the app only ever reads from SQLite and keeps working fully offline.

/// A trilingual string (English / Urdu / Pashto).
class LText {
  const LText(this.en, this.ur, this.ps);

  factory LText.fromJson(Map<String, dynamic> json) => LText(
        (json['en'] ?? '') as String,
        (json['ur'] ?? json['en'] ?? '') as String,
        (json['ps'] ?? json['en'] ?? '') as String,
      );

  final String en;
  final String ur;
  final String ps;
}

class QuestionSpec {
  const QuestionSpec({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });

  factory QuestionSpec.fromJson(Map<String, dynamic> json) => QuestionSpec(
        prompt: LText.fromJson(json['prompt'] as Map<String, dynamic>),
        options: (json['options'] as List)
            .map((o) => LText.fromJson(o as Map<String, dynamic>))
            .toList(),
        correctIndex: (json['correctIndex'] as num).toInt(),
      );

  final LText prompt;
  final List<LText> options;
  final int correctIndex;
}

class LessonSpec {
  const LessonSpec({
    required this.title,
    required this.objective,
    required this.explanation,
    required this.example,
    required this.illustration,
    required this.questions,
    this.audio,
  });

  factory LessonSpec.fromJson(Map<String, dynamic> json) => LessonSpec(
        title: LText.fromJson(json['title'] as Map<String, dynamic>),
        objective: LText.fromJson(json['objective'] as Map<String, dynamic>),
        explanation:
            LText.fromJson(json['explanation'] as Map<String, dynamic>),
        example: LText.fromJson(json['example'] as Map<String, dynamic>),
        illustration: (json['illustration'] ?? '📘') as String,
        audio: json['audio'] as String?,
        questions: (json['questions'] as List? ?? [])
            .map((q) => QuestionSpec.fromJson(q as Map<String, dynamic>))
            .toList(),
      );

  final LText title;
  final LText objective;
  final LText explanation;
  final LText example;
  final String illustration;

  /// Optional relative path (within the package) to a compressed offline audio
  /// file for this lesson, e.g. `audio/lesson_100.mp3`. Null means "use TTS".
  final String? audio;
  final List<QuestionSpec> questions;
}

class UnitSpec {
  const UnitSpec({required this.title, required this.lessons});

  factory UnitSpec.fromJson(Map<String, dynamic> json) => UnitSpec(
        title: LText.fromJson(json['title'] as Map<String, dynamic>),
        lessons: (json['lessons'] as List)
            .map((l) => LessonSpec.fromJson(l as Map<String, dynamic>))
            .toList(),
      );

  final LText title;
  final List<LessonSpec> lessons;
}

class SubjectSpec {
  const SubjectSpec({
    required this.code,
    required this.name,
    required this.emoji,
    required this.units,
  });

  factory SubjectSpec.fromJson(Map<String, dynamic> json) => SubjectSpec(
        code: json['code'] as String,
        name: LText.fromJson(json['name'] as Map<String, dynamic>),
        emoji: (json['emoji'] ?? '📚') as String,
        units: (json['units'] as List)
            .map((u) => UnitSpec.fromJson(u as Map<String, dynamic>))
            .toList(),
      );

  final String code;
  final LText name;
  final String emoji;
  final List<UnitSpec> units;
}

/// A full content package for one grade (optionally scoped to a province).
class ContentPackage {
  const ContentPackage({
    required this.grade,
    required this.subjects,
    this.province = 'Khyber Pakhtunkhwa',
    this.isDemo = true,
  });

  factory ContentPackage.fromJson(Map<String, dynamic> json) => ContentPackage(
        province: (json['province'] ?? 'Khyber Pakhtunkhwa') as String,
        grade: (json['grade'] as num).toInt(),
        isDemo: (json['isDemo'] ?? true) as bool,
        subjects: (json['subjects'] as List)
            .map((s) => SubjectSpec.fromJson(s as Map<String, dynamic>))
            .toList(),
      );

  final String province;
  final int grade;
  final bool isDemo;
  final List<SubjectSpec> subjects;
}
