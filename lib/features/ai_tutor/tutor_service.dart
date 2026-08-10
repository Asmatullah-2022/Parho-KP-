import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mock_tutor.dart';
import 'tutor_models.dart';

/// Abstraction over the tutoring backend.
///
/// The UI depends only on this interface, so a real AI provider can be added
/// later ([FutureRemoteTutorService]) without touching the screens. Secret API
/// keys must never be embedded in the app — a remote implementation should call
/// a backend that holds the key server-side.
abstract class TutorService {
  Future<TutorReply> respond(TutorRequest request);
}

/// The next language to translate into, cycling en → ur → ps → en.
String _nextLanguage(String code) => switch (code) {
      'en' => 'ur',
      'ur' => 'ps',
      _ => 'en',
    };

/// On-device mock tutor. Deterministic, grade-aware, multilingual and fully
/// offline. Used everywhere today.
class MockTutorService implements TutorService {
  const MockTutorService();

  @override
  Future<TutorReply> respond(TutorRequest request) async {
    // Small "thinking" pause — no network involved.
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final ctx = request.context;
    final code = ctx.languageCode;
    final grade = ctx.grade;

    // Safety first: medical/legal/dangerous questions get a safe response.
    final safe = MockTutor.safety(request.message, code);
    if (safe != null) return TutorReply(text: safe);

    final topic = MockTutor.detectTopic(request.message, ctx);

    switch (request.intent) {
      case TutorIntent.freeText:
        return TutorReply(text: MockTutor.reply(request.message, code, grade: grade));

      case TutorIntent.explainLesson:
        return TutorReply(
            text: MockTutor.explainLesson(code, context: ctx, grade: grade));

      case TutorIntent.iDontUnderstand:
        final lead = _encourage(code);
        final body = topic == null
            ? MockTutor.explainLesson(code, context: ctx, grade: grade)
            : MockTutor.explain(topic, grade, code);
        return TutorReply(text: '$lead$body');

      case TutorIntent.explainSimply:
        final body = topic == null
            ? MockTutor.explainLesson(code, context: ctx, grade: grade)
            : MockTutor.explain(topic, grade, code, detailed: false);
        return TutorReply(text: body);

      case TutorIntent.explainForClass:
        final body = topic == null
            ? MockTutor.explainLesson(code, context: ctx, grade: grade)
            : MockTutor.explainForClass(topic, grade, code);
        return TutorReply(text: body);

      case TutorIntent.giveExample:
        return TutorReply(
            text: topic == null
                ? MockTutor.easyExample(code, context: ctx)
                : MockTutor.example(topic, code));

      case TutorIntent.explainAnother:
        final body = topic == null
            ? MockTutor.easyExample(code, context: ctx)
            : MockTutor.explainAnother(topic, grade, code);
        return TutorReply(text: body);

      case TutorIntent.translate:
        final target = request.translateTo ?? _nextLanguage(code);
        final body = topic == null
            ? MockTutor.explainLesson(target, context: ctx.copyWith(languageCode: target), grade: grade)
            : MockTutor.explain(topic, grade, target);
        return TutorReply(text: body);

      case TutorIntent.askQuestion:
        final q = MockTutor.question(topic, code);
        return TutorReply(text: _askIntro(code), question: q, graded: false);

      case TutorIntent.testUnderstanding:
        final q = MockTutor.question(topic, code);
        return TutorReply(text: _testIntro(code), question: q, graded: true);
    }
  }

  String _encourage(String code) => switch (code) {
        'ur' => 'کوئی بات نہیں — آئیے اسے آسان بناتے ہیں۔ ',
        'ps' => 'کومه ستونزه نشته — راځئ اسانه یې کړو. ',
        _ => "No problem — let's make it easy. ",
      };

  String _askIntro(String code) => switch (code) {
        'ur' => 'یہ سوال حل کر کے دیکھیں:',
        'ps' => 'دا پوښتنه حل کړئ:',
        _ => "Here's a question to try:",
      };

  String _testIntro(String code) => switch (code) {
        'ur' => 'آئیے آپ کی سمجھ جانچتے ہیں:',
        'ps' => 'راځئ ستاسو پوهه وازمویو:',
        _ => "Let's check your understanding:",
      };
}

/// Placeholder for a future online AI provider. NOT connected yet — it throws
/// so callers fall back to the mock. When implemented it must call a backend
/// that keeps the API key server-side (never in the app).
class FutureRemoteTutorService implements TutorService {
  const FutureRemoteTutorService();

  @override
  Future<TutorReply> respond(TutorRequest request) async {
    throw StateError('Remote tutor is not connected yet.');
  }
}

/// The tutor service the app uses today (mock, offline). Swap this override for
/// a remote-backed service in the future — no UI changes required.
final tutorServiceProvider =
    Provider<TutorService>((ref) => const MockTutorService());
