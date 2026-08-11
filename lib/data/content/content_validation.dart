import 'dart:convert';

import 'content_models.dart';

/// Thrown when a content package fails validation. Carries a human-readable
/// [message] and a machine-friendly [code] so importers can reject bad content
/// safely (and show a helpful error) instead of crashing.
class ContentValidationException implements Exception {
  const ContentValidationException(this.message, {this.code = 'invalid'});

  final String message;
  final String code;

  @override
  String toString() => 'ContentValidationException($code): $message';
}

/// Validates untrusted content packages (bundled JSON, downloaded packages, or
/// future server responses) before they are written to the database.
///
/// The importer runs this first so an invalid or malicious package is rejected
/// cleanly — nothing is partially written, and the app never crashes on bad
/// input. Validation is strict but forgiving of optional fields.
class ContentValidator {
  const ContentValidator();

  static const int minGrade = 1;
  static const int maxGrade = 8;
  static const int maxSubjects = 40;
  static const int maxLessonsPerUnit = 200;
  static const int maxOptions = 8;

  /// Parses [jsonText] and validates it, returning a safe [ContentPackage].
  /// Throws [ContentValidationException] on any structural problem — including
  /// malformed JSON or wrong field types — so callers never see a raw
  /// [FormatException] or [TypeError].
  ContentPackage parse(String jsonText) {
    final Object? decoded;
    try {
      decoded = jsonDecode(jsonText);
    } on FormatException catch (e) {
      throw ContentValidationException(
        'Package is not valid JSON: ${e.message}',
        code: 'malformed_json',
      );
    }
    if (decoded is! Map<String, dynamic>) {
      throw const ContentValidationException(
        'Package must be a JSON object.',
        code: 'not_object',
      );
    }
    final ContentPackage pkg;
    try {
      pkg = ContentPackage.fromJson(decoded);
    } catch (_) {
      // Any missing/mistyped field surfaces here as a controlled error.
      throw const ContentValidationException(
        'Package structure is invalid or has missing fields.',
        code: 'bad_structure',
      );
    }
    validate(pkg);
    return pkg;
  }

  /// Validates an already-parsed package. Throws on the first problem found.
  void validate(ContentPackage pkg) {
    if (pkg.grade < minGrade || pkg.grade > maxGrade) {
      throw ContentValidationException(
        'Grade ${pkg.grade} is out of range ($minGrade–$maxGrade).',
        code: 'bad_grade',
      );
    }
    if (pkg.subjects.isEmpty) {
      throw const ContentValidationException(
        'Package has no subjects.',
        code: 'no_subjects',
      );
    }
    if (pkg.subjects.length > maxSubjects) {
      throw const ContentValidationException(
        'Package has too many subjects.',
        code: 'too_many_subjects',
      );
    }
    for (final subject in pkg.subjects) {
      if (subject.code.trim().isEmpty) {
        throw const ContentValidationException(
          'A subject is missing its code.',
          code: 'bad_subject',
        );
      }
      if (subject.name.en.trim().isEmpty) {
        throw ContentValidationException(
          'Subject "${subject.code}" is missing an English name.',
          code: 'bad_subject_name',
        );
      }
      if (subject.units.isEmpty) {
        throw ContentValidationException(
          'Subject "${subject.code}" has no units.',
          code: 'no_units',
        );
      }
      for (final unit in subject.units) {
        if (unit.title.en.trim().isEmpty) {
          throw const ContentValidationException(
            'A unit is missing its title.',
            code: 'bad_unit',
          );
        }
        if (unit.lessons.isEmpty) {
          throw ContentValidationException(
            'Unit "${unit.title.en}" has no lessons.',
            code: 'no_lessons',
          );
        }
        if (unit.lessons.length > maxLessonsPerUnit) {
          throw const ContentValidationException(
            'A unit has too many lessons.',
            code: 'too_many_lessons',
          );
        }
        for (final lesson in unit.lessons) {
          if (lesson.title.en.trim().isEmpty) {
            throw const ContentValidationException(
              'A lesson is missing its title.',
              code: 'bad_lesson',
            );
          }
          for (final q in lesson.questions) {
            if (q.prompt.en.trim().isEmpty) {
              throw ContentValidationException(
                'A question in "${lesson.title.en}" is missing its prompt.',
                code: 'bad_question',
              );
            }
            if (q.options.length < 2) {
              throw ContentValidationException(
                'A question in "${lesson.title.en}" needs at least 2 options.',
                code: 'too_few_options',
              );
            }
            if (q.options.length > maxOptions) {
              throw ContentValidationException(
                'A question in "${lesson.title.en}" has too many options.',
                code: 'too_many_options',
              );
            }
            if (q.correctIndex < 0 || q.correctIndex >= q.options.length) {
              throw ContentValidationException(
                'A question in "${lesson.title.en}" has an out-of-range '
                'correct answer.',
                code: 'bad_correct_index',
              );
            }
          }
        }
      }
    }
  }
}
