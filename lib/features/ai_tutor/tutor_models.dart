/// Immutable pieces of context passed to the tutor so its answers can be
/// tailored to the student's class, language and current lesson.
class TutorContext {
  const TutorContext({
    this.studentName = '',
    this.grade = 5,
    this.languageCode = 'en',
    this.subjectName,
    this.unitName,
    this.lessonId,
    this.lessonTitle,
    this.objective,
    this.topic,
  });

  final String studentName;
  final int grade;
  final String languageCode;
  final String? subjectName;
  final String? unitName;
  final int? lessonId;
  final String? lessonTitle;
  final String? objective;
  final String? topic;

  /// A short label of the current lesson/topic, if any.
  String? get focus => topic ?? lessonTitle;

  TutorContext copyWith({String? languageCode}) => TutorContext(
        studentName: studentName,
        grade: grade,
        languageCode: languageCode ?? this.languageCode,
        subjectName: subjectName,
        unitName: unitName,
        lessonId: lessonId,
        lessonTitle: lessonTitle,
        objective: objective,
        topic: topic,
      );
}

/// The kinds of help the tutor can give. Actions on the UI map to these.
enum TutorIntent {
  freeText,
  explainLesson,
  iDontUnderstand,
  explainSimply,
  explainForClass,
  giveExample,
  askQuestion,
  testUnderstanding,
  explainAnother,
  translate,
}

/// A single request to a [TutorService].
class TutorRequest {
  const TutorRequest({
    required this.context,
    this.message = '',
    this.intent = TutorIntent.freeText,
    this.translateTo,
  });

  final TutorContext context;
  final String message;
  final TutorIntent intent;

  /// Target language code for [TutorIntent.translate].
  final String? translateTo;
}

/// A simple multiple-choice question the tutor can pose. Strings are already
/// localized for the active language.
class TutorQuestion {
  const TutorQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
}

/// The tutor's answer: text, and optionally an interactive question. When
/// [graded] is true, the student's answer should be recorded as a learning
/// signal (Test My Understanding).
class TutorReply {
  const TutorReply({
    required this.text,
    this.question,
    this.graded = false,
  });

  final String text;
  final TutorQuestion? question;
  final bool graded;
}
