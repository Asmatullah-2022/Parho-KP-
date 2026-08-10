import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'content_models.dart';

/// Writes [ContentPackage]s into the local database. Used by the first-run demo
/// seeding and available at runtime to import additional content packages
/// (bundled JSON, downloaded packages, or — in future — a secure server).
class ContentImporter {
  ContentImporter(this.db);
  final AppDatabase db;

  /// Imports a package parsed from JSON text.
  Future<void> importJson(String jsonText) async {
    final map = jsonDecode(jsonText) as Map<String, dynamic>;
    await importPackage(ContentPackage.fromJson(map));
  }

  /// Inserts all subjects/units/lessons/questions of [pkg] for its grade.
  ///
  /// If [replaceGrade] is true, existing subjects for that grade are removed
  /// first so re-importing updates cleanly instead of duplicating.
  Future<void> importPackage(
    ContentPackage pkg, {
    bool replaceGrade = false,
  }) async {
    await db.transaction(() async {
      if (replaceGrade) {
        await db.deleteGradeContent(pkg.grade);
      }
      for (var s = 0; s < pkg.subjects.length; s++) {
        final subject = pkg.subjects[s];
        final subjectId = await db.into(db.subjects).insert(
              SubjectsCompanion.insert(
                code: subject.code,
                grade: pkg.grade,
                nameEn: subject.name.en,
                nameUr: subject.name.ur,
                namePs: subject.name.ps,
                emoji: subject.emoji,
                sortOrder: Value(s),
              ),
            );
        for (var u = 0; u < subject.units.length; u++) {
          final unit = subject.units[u];
          final unitId = await db.into(db.units).insert(
                UnitsCompanion.insert(
                  subjectId: subjectId,
                  titleEn: unit.title.en,
                  titleUr: unit.title.ur,
                  titlePs: unit.title.ps,
                  sortOrder: Value(u),
                ),
              );
          for (var li = 0; li < unit.lessons.length; li++) {
            final lesson = unit.lessons[li];
            final lessonId = await db.into(db.lessons).insert(
                  LessonsCompanion.insert(
                    unitId: unitId,
                    titleEn: lesson.title.en,
                    titleUr: lesson.title.ur,
                    titlePs: lesson.title.ps,
                    objectiveEn: lesson.objective.en,
                    objectiveUr: lesson.objective.ur,
                    objectivePs: lesson.objective.ps,
                    explanationEn: lesson.explanation.en,
                    explanationUr: lesson.explanation.ur,
                    explanationPs: lesson.explanation.ps,
                    exampleEn: lesson.example.en,
                    exampleUr: lesson.example.ur,
                    examplePs: lesson.example.ps,
                    illustration: lesson.illustration,
                    sortOrder: Value(li),
                    isDemo: Value(pkg.isDemo),
                  ),
                );
            for (var qi = 0; qi < lesson.questions.length; qi++) {
              final q = lesson.questions[qi];
              await db.into(db.questions).insert(
                    QuestionsCompanion.insert(
                      lessonId: lessonId,
                      promptEn: q.prompt.en,
                      promptUr: q.prompt.ur,
                      promptPs: q.prompt.ps,
                      optionsEn:
                          jsonEncode(q.options.map((o) => o.en).toList()),
                      optionsUr:
                          jsonEncode(q.options.map((o) => o.ur).toList()),
                      optionsPs:
                          jsonEncode(q.options.map((o) => o.ps).toList()),
                      correctIndex: q.correctIndex,
                      sortOrder: Value(qi),
                    ),
                  );
            }
          }
        }
      }
    });
  }
}
