import 'package:flutter_test/flutter_test.dart';
import 'package:parho_kp/features/ai_tutor/mock_tutor.dart';
import 'package:parho_kp/features/ai_tutor/tutor_models.dart';
import 'package:parho_kp/features/ai_tutor/tutor_service.dart';

void main() {
  const service = MockTutorService();

  TutorContext ctx({
    int grade = 5,
    String lang = 'en',
    String? topic,
    String? lesson,
    int? lessonId,
  }) =>
      TutorContext(
        studentName: 'Ahmed',
        grade: grade,
        languageCode: lang,
        subjectName: 'Mathematics',
        lessonId: lessonId,
        lessonTitle: lesson,
        topic: topic,
      );

  test('explainLesson uses topic from context', () async {
    final reply = await service.respond(TutorRequest(
      context: ctx(topic: 'Fractions'),
      intent: TutorIntent.explainLesson,
    ));
    expect(reply.text.toLowerCase(), contains('fraction'));
  });

  test('responds in the requested language', () async {
    final ur = await service.respond(TutorRequest(
      context: ctx(lang: 'ur', topic: 'Fractions'),
      intent: TutorIntent.explainSimply,
    ));
    expect(ur.text, contains('روٹی'));

    final ps = await service.respond(TutorRequest(
      context: ctx(lang: 'ps', topic: 'Fractions'),
      intent: TutorIntent.explainSimply,
    ));
    expect(ps.text, contains('ډوډۍ'));
  });

  test('explanations are class-aware (grade 8 differs from grade 3)', () async {
    final young = await service.respond(TutorRequest(
      context: ctx(grade: 3, topic: 'Fractions'),
      intent: TutorIntent.explainSimply,
    ));
    final older = await service.respond(TutorRequest(
      context: ctx(grade: 8, topic: 'Fractions'),
      intent: TutorIntent.explainSimply,
    ));
    expect(young.text, isNot(equals(older.text)));
    // The grade-8 answer includes the more detailed denominator/numerator idea.
    expect(older.text.toLowerCase(), contains('denominator'));
  });

  test('explainForClass names the grade', () async {
    final reply = await service.respond(TutorRequest(
      context: ctx(grade: 5, topic: 'Fractions'),
      intent: TutorIntent.explainForClass,
    ));
    expect(reply.text, contains('5'));
  });

  test('Test My Understanding returns a graded question', () async {
    final reply = await service.respond(TutorRequest(
      context: ctx(topic: 'Fractions'),
      intent: TutorIntent.testUnderstanding,
    ));
    expect(reply.graded, isTrue);
    expect(reply.question, isNotNull);
    expect(reply.question!.options.length, greaterThanOrEqualTo(2));
    expect(reply.question!.correctIndex,
        inInclusiveRange(0, reply.question!.options.length - 1));
  });

  test('Ask Me a Question returns a non-graded question', () async {
    final reply = await service.respond(TutorRequest(
      context: ctx(topic: 'Plants'),
      intent: TutorIntent.askQuestion,
    ));
    expect(reply.graded, isFalse);
    expect(reply.question, isNotNull);
  });

  test('translate returns the explanation in another language', () async {
    final reply = await service.respond(TutorRequest(
      context: ctx(lang: 'en', topic: 'Fractions'),
      intent: TutorIntent.translate,
      translateTo: 'ur',
    ));
    expect(reply.text, contains('روٹی'));
  });

  test('unknown topic returns the friendly fallback, not invented facts',
      () async {
    final reply = await service.respond(TutorRequest(
      context: ctx(),
      message: 'Tell me about quantum tunnelling',
    ));
    expect(reply.text, equals(MockTutor.fallback('en')));
  });

  test('medical/legal/dangerous questions get a safe response', () async {
    final reply = await service.respond(TutorRequest(
      context: ctx(),
      message: 'what medicine should I take for fever',
    ));
    expect(reply.text.toLowerCase(), contains('adult'));
  });

  test('FutureRemoteTutorService is not connected yet', () async {
    const remote = FutureRemoteTutorService();
    expect(
      () => remote.respond(TutorRequest(context: ctx())),
      throwsA(isA<StateError>()),
    );
  });

  test('mock knowledge covers the required demo topics', () {
    for (final topic in [
      'fractions',
      'multiplication',
      'division',
      'plants',
      'water',
      'living',
      'nouns',
      'verbs',
      'reading',
      'pakistan',
      'kp',
    ]) {
      expect(MockTutor.explain(topic, 5, 'en'), isNotEmpty);
      expect(MockTutor.question(topic, 'en'), isNotNull);
    }
  });
}
