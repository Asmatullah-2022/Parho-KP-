import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parho_kp/data/content/content_importer.dart';
import 'package:parho_kp/data/database/app_database.dart';
import 'package:parho_kp/data/repositories/learning_repository.dart';
import 'package:parho_kp/data/seed/demo_content.dart';
import 'package:parho_kp/features/ai_tutor/tutor_models.dart';
import 'package:parho_kp/features/ai_tutor/tutor_service.dart';
import 'package:parho_kp/features/teacher/teacher_data.dart';
import 'package:parho_kp/shared/services/speech_input_service.dart';
import 'package:parho_kp/shared/services/voice_language_support.dart';

void main() {
  late AppDatabase db;
  late LearningRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = LearningRepository(db);
    await seedDemoContentIfNeeded(db);
  });

  tearDown(() async => db.close());

  group('curriculum', () {
    test('every grade 1-8 has content with lessons and questions', () async {
      for (final grade in demoGrades) {
        final subjects = await repo.subjectsForGrade(grade);
        expect(subjects, isNotEmpty, reason: 'grade $grade has subjects');
        var lessons = 0;
        var questions = 0;
        for (final s in subjects) {
          final ls = await db.lessonsForSubject(s.id);
          lessons += ls.length;
          for (final l in ls) {
            questions += (await repo.questionsForLesson(l.id)).length;
          }
        }
        expect(lessons, greaterThan(0), reason: 'grade $grade has lessons');
        expect(questions, greaterThan(0),
            reason: 'grade $grade has questions');
      }
    });

    test('Grade 5 still has its 6 rich subjects', () async {
      final subjects = await repo.subjectsForGrade(5);
      expect(subjects.length, 6);
    });
  });

  group('content architecture', () {
    test('a JSON content package can be imported at runtime', () async {
      const json = '''
      {
        "grade": 6,
        "isDemo": true,
        "subjects": [
          {
            "code": "math", "emoji": "➕",
            "name": {"en": "Mathematics", "ur": "ریاضی", "ps": "ریاضي"},
            "units": [
              {
                "title": {"en": "Geometry", "ur": "جیومیٹری", "ps": "جیومیټري"},
                "lessons": [
                  {
                    "title": {"en": "Shapes", "ur": "شکلیں", "ps": "شکلونه"},
                    "objective": {"en": "o", "ur": "o", "ps": "o"},
                    "explanation": {"en": "e", "ur": "e", "ps": "e"},
                    "example": {"en": "x", "ur": "x", "ps": "x"},
                    "illustration": "🔺",
                    "questions": [
                      {
                        "prompt": {"en": "Sides of a triangle?", "ur": "?", "ps": "?"},
                        "options": [
                          {"en": "3", "ur": "3", "ps": "۳"},
                          {"en": "4", "ur": "4", "ps": "۴"}
                        ],
                        "correctIndex": 0
                      }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }
      ''';
      final importer = ContentImporter(db);
      await db.deleteGradeContent(6); // remove generated grade-6 content first
      await importer.importJson(json);

      final subjects = await repo.subjectsForGrade(6);
      final geo = subjects.firstWhere((s) => s.code == 'math');
      final lessons = await db.lessonsForSubject(geo.id);
      expect(lessons.any((l) => l.titleEn == 'Shapes'), isTrue);
      final q = await repo.questionsForLesson(
          lessons.firstWhere((l) => l.titleEn == 'Shapes').id);
      expect(q, isNotEmpty);
      expect(q.first.correctIndex, 0);
    });
  });

  group('student report', () {
    test('assembles overall/quiz/strong-weak/next from local data', () async {
      final id =
          await repo.createStudent(name: 'Ahmed', grade: 5, languageCode: 'en');
      final student = await repo.currentStudent();
      // Complete one lesson + a full-marks quiz.
      final math =
          (await repo.subjectsForGrade(5)).firstWhere((s) => s.code == 'math');
      final lesson = (await db.lessonsForSubject(math.id)).first;
      final qs = await repo.questionsForLesson(lesson.id);
      await repo.saveQuizResult(
        studentId: id,
        lessonId: lesson.id,
        questions: qs,
        selected: qs.map((q) => q.correctIndex).toList(),
      );

      final report = await repo.buildStudentReport(student!);
      expect(report.subjects.length, 6);
      expect(report.quizzesTaken, 1);
      expect(report.quizAveragePercent, 100);
      expect(report.lessonsCompleted, greaterThanOrEqualTo(1));
      expect(report.recentActivity, isNotEmpty);
    });
  });

  group('teacher demo data', () {
    test('demo class has students, average and weak areas', () {
      final c = buildDemoClass(id: 5, grade: 5);
      expect(c.students.length, 32);
      expect(c.averageProgress, inInclusiveRange(0, 100));
      expect(c.subjectAverages, isNotEmpty);
      // Deterministic across runs.
      expect(buildDemoClass(id: 5, grade: 5).averageProgress,
          c.averageProgress);
      for (final s in c.needingSupport) {
        expect(s.needsSupport, isTrue);
        expect(s.weakest, isNotNull);
      }
    });
  });

  group('AI tutor production', () {
    const service = MockTutorService();

    test('recent low quiz score triggers a review recommendation', () async {
      final reply = await service.respond(TutorRequest(
        context: const TutorContext(
          grade: 5,
          languageCode: 'en',
          topic: 'Fractions',
          recentQuizPercent: 40,
        ),
        intent: TutorIntent.explainLesson,
      ));
      expect(reply.text.toLowerCase(), contains('review'));
    });

    test('recent high quiz score suggests the next lesson', () async {
      final reply = await service.respond(TutorRequest(
        context: const TutorContext(
          grade: 5,
          languageCode: 'en',
          topic: 'Fractions',
          recentQuizPercent: 90,
        ),
        intent: TutorIntent.explainLesson,
      ));
      expect(reply.text.toLowerCase(), contains('next lesson'));
    });

    test('RemoteTutorService is not connected without a backend', () async {
      const remote = RemoteTutorService();
      expect(remote.isConfigured, isFalse);
      expect(() => remote.respond(const TutorRequest(context: TutorContext())),
          throwsA(isA<StateError>()));
    });
  });

  group('voice', () {
    test('VoiceLanguageSupport maps the three languages', () {
      expect(VoiceLanguageSupport.isSupported('ur'), isTrue);
      expect(VoiceLanguageSupport.isSupported('ps'), isTrue);
      expect(VoiceLanguageSupport.isSupported('fr'), isFalse);
      expect(VoiceLanguageSupport.localeHint('ps'), 'ps-AF');
    });

    test('speech input safely reports unavailable (no crash)', () async {
      const service = UnavailableSpeechInputService();
      expect(await service.isAvailable(), isFalse);
      expect(await service.listen(languageCode: 'ur'), isNull);
    });
  });
}
