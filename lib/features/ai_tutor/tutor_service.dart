import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mock_tutor.dart';

/// The kinds of help the AI Tutor can give. Actions map to these intents so the
/// UI stays the same whether the backend is the mock or a real API later.
enum TutorIntent {
  freeText,
  explainLesson,
  easyExample,
  inUrdu,
  inPashto,
}

/// A single tutoring request.
class TutorRequest {
  const TutorRequest({
    required this.message,
    required this.languageCode,
    this.intent = TutorIntent.freeText,
  });

  final String message;
  final String languageCode;
  final TutorIntent intent;
}

/// Abstraction over the tutoring backend.
///
/// Only a MOCK implementation exists today. To connect a real AI later,
/// implement this interface and override [tutorServiceProvider] — no UI changes
/// are needed.
abstract class TutorService {
  Future<String> respond(TutorRequest request);
}

/// On-device mock tutor. Returns friendly, deterministic responses with a short
/// simulated "thinking" delay. No network is used, so it works fully offline.
class MockTutorService implements TutorService {
  const MockTutorService();

  @override
  Future<String> respond(TutorRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    switch (request.intent) {
      case TutorIntent.explainLesson:
        return MockTutor.explainLesson(request.languageCode);
      case TutorIntent.easyExample:
        return MockTutor.easyExample(request.languageCode);
      case TutorIntent.inUrdu:
        return MockTutor.reply(
          request.message.isEmpty ? 'fractions' : request.message,
          'ur',
        );
      case TutorIntent.inPashto:
        return MockTutor.reply(
          request.message.isEmpty ? 'fractions' : request.message,
          'ps',
        );
      case TutorIntent.freeText:
        return MockTutor.reply(request.message, request.languageCode);
    }
  }
}

/// Swap this override for a real API-backed [TutorService] in the future.
final tutorServiceProvider =
    Provider<TutorService>((ref) => const MockTutorService());
