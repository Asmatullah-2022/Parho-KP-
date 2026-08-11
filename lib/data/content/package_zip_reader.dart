import 'dart:convert';

import 'package:archive/archive.dart';

import 'content_models.dart';
import 'content_validation.dart';

/// Thrown when a package archive is structurally invalid (missing required
/// files, malformed JSON, or content that fails validation). Carries a friendly
/// [message] and a machine [code]; the download service maps it to a safe,
/// non-technical error and deletes the bad download.
class PackageFormatException implements Exception {
  const PackageFormatException(this.message, {this.code = 'invalid_package'});
  final String message;
  final String code;
  @override
  String toString() => 'PackageFormatException($code): $message';
}

/// The in-archive manifest (`manifest.json`) plus the assembled, validated
/// [ContentPackage] ready to import. Separate from the catalog's
/// `PackageMetadata`: this is what lives *inside* the verified archive.
class ReadPackage {
  const ReadPackage({
    required this.packageId,
    required this.grade,
    required this.version,
    required this.package,
    this.audioFiles = const {},
    this.imageFiles = const {},
  });

  final String packageId;
  final int grade;
  final String version;
  final ContentPackage package;

  /// Extracted audio files, keyed by their in-package path (e.g.
  /// `audio/lesson_100.mp3`). Empty when the package ships no audio.
  final Map<String, List<int>> audioFiles;

  /// Extracted image files, keyed by their in-package path.
  final Map<String, List<int>> imageFiles;

  bool get hasAudio => audioFiles.isNotEmpty;
  bool get hasImages => imageFiles.isNotEmpty;
}

/// Reads and validates a content package archive.
///
/// Expected layout (predictable format):
/// ```
/// package.zip
///   manifest.json
///   content/subjects.json
///   content/units.json
///   content/lessons.json
///   content/questions.json
///   audio/     (optional)
///   images/    (optional)
/// ```
/// The relational content files are reassembled into a [ContentPackage] and run
/// through [ContentValidator]. A malformed package is rejected before any
/// database write.
class PackageZipReader {
  const PackageZipReader({this.validator = const ContentValidator()});
  final ContentValidator validator;

  static const requiredFiles = <String>[
    'manifest.json',
    'content/subjects.json',
    'content/units.json',
    'content/lessons.json',
    'content/questions.json',
  ];

  ReadPackage read(List<int> zipBytes) {
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(zipBytes);
    } catch (_) {
      throw const PackageFormatException('Package archive is unreadable.',
          code: 'bad_zip');
    }

    final files = <String, List<int>>{};
    final audioFiles = <String, List<int>>{};
    final imageFiles = <String, List<int>>{};
    for (final f in archive.files) {
      if (!f.isFile) continue;
      final name = f.name;
      final content = f.content as List<int>;
      if (name.startsWith('audio/')) audioFiles[name] = content;
      if (name.startsWith('images/')) imageFiles[name] = content;
      files[name] = content;
    }

    for (final required in requiredFiles) {
      if (!files.containsKey(required)) {
        throw PackageFormatException(
          'Package is missing "$required".',
          code: 'missing_file',
        );
      }
    }

    final manifest = _decodeObject(files['manifest.json']!, 'manifest.json');
    final grade = (manifest['grade'] as num?)?.toInt();
    final packageId = manifest['packageId'] as String?;
    final version = (manifest['version'] as String?) ?? '1.0.0';
    if (grade == null || packageId == null || packageId.isEmpty) {
      throw const PackageFormatException(
        'manifest.json is missing packageId/grade.',
        code: 'bad_manifest',
      );
    }

    final subjects = _decodeArray(files['content/subjects.json']!, 'subjects');
    final units = _decodeArray(files['content/units.json']!, 'units');
    final lessons = _decodeArray(files['content/lessons.json']!, 'lessons');
    final questions =
        _decodeArray(files['content/questions.json']!, 'questions');

    final package = _assemble(
      grade: grade,
      isDemo: (manifest['isDemo'] as bool?) ?? true,
      province:
          (manifest['province'] as String?) ?? 'Khyber Pakhtunkhwa',
      subjects: subjects,
      units: units,
      lessons: lessons,
      questions: questions,
    );

    // Reject malformed content before it can touch the database.
    validator.validate(package);

    return ReadPackage(
      packageId: packageId,
      grade: grade,
      version: version,
      package: package,
      audioFiles: audioFiles,
      imageFiles: imageFiles,
    );
  }

  Map<String, dynamic> _decodeObject(List<int> bytes, String label) {
    try {
      final v = jsonDecode(utf8.decode(bytes));
      if (v is! Map<String, dynamic>) {
        throw const FormatException('not an object');
      }
      return v;
    } catch (_) {
      throw PackageFormatException('"$label" is not valid JSON.',
          code: 'bad_json');
    }
  }

  List<dynamic> _decodeArray(List<int> bytes, String label) {
    try {
      final v = jsonDecode(utf8.decode(bytes));
      if (v is! List) throw const FormatException('not a list');
      return v;
    } catch (_) {
      throw PackageFormatException('"$label" is not a JSON array.',
          code: 'bad_json');
    }
  }

  /// Reassembles the relational content files into a nested [ContentPackage].
  ContentPackage _assemble({
    required int grade,
    required bool isDemo,
    required String province,
    required List<dynamic> subjects,
    required List<dynamic> units,
    required List<dynamic> lessons,
    required List<dynamic> questions,
  }) {
    LText lt(Object? v) => v is Map<String, dynamic>
        ? LText.fromJson(v)
        : throw const PackageFormatException('Bad localized text.',
            code: 'bad_ltext');

    // Index children by their parent id.
    final unitsBySubject = <Object, List<Map<String, dynamic>>>{};
    for (final u in units.cast<Map<String, dynamic>>()) {
      (unitsBySubject[u['subjectId'] as Object? ?? -1] ??= []).add(u);
    }
    final lessonsByUnit = <Object, List<Map<String, dynamic>>>{};
    for (final l in lessons.cast<Map<String, dynamic>>()) {
      (lessonsByUnit[l['unitId'] as Object? ?? -1] ??= []).add(l);
    }
    final questionsByLesson = <Object, List<Map<String, dynamic>>>{};
    for (final q in questions.cast<Map<String, dynamic>>()) {
      (questionsByLesson[q['lessonId'] as Object? ?? -1] ??= []).add(q);
    }

    final subjectSpecs = <SubjectSpec>[];
    for (final s in subjects.cast<Map<String, dynamic>>()) {
      final subjectId = s['id'] as Object? ?? -1;
      final unitSpecs = <UnitSpec>[];
      for (final u in unitsBySubject[subjectId] ?? const []) {
        final unitId = u['id'] as Object? ?? -1;
        final lessonSpecs = <LessonSpec>[];
        for (final l in lessonsByUnit[unitId] ?? const []) {
          final lessonId = l['id'] as Object? ?? -1;
          final questionSpecs = <QuestionSpec>[];
          for (final q in questionsByLesson[lessonId] ?? const []) {
            questionSpecs.add(QuestionSpec(
              prompt: lt(q['prompt']),
              options: (q['options'] as List)
                  .map((o) => lt(o))
                  .toList(),
              correctIndex: (q['correctIndex'] as num).toInt(),
            ));
          }
          lessonSpecs.add(LessonSpec(
            title: lt(l['title']),
            objective: lt(l['objective']),
            explanation: lt(l['explanation']),
            example: lt(l['example']),
            illustration: (l['illustration'] as String?) ?? '📘',
            audio: l['audio'] as String?,
            questions: questionSpecs,
          ));
        }
        unitSpecs.add(UnitSpec(title: lt(u['title']), lessons: lessonSpecs));
      }
      subjectSpecs.add(SubjectSpec(
        code: s['code'] as String,
        name: lt(s['name']),
        emoji: (s['emoji'] as String?) ?? '📚',
        units: unitSpecs,
      ));
    }

    return ContentPackage(
      grade: grade,
      subjects: subjectSpecs,
      province: province,
      isDemo: isDemo,
    );
  }
}
