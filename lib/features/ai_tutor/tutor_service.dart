import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mock_tutor.dart';
import 'tutor_api.dart';
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
        final note = MockTutor.performanceNote(code, ctx.recentQuizPercent);
        return TutorReply(
            text: MockTutor.explainLesson(code, context: ctx, grade: grade) +
                note);

      case TutorIntent.iDontUnderstand:
        final lead = _encourage(code);
        final body = topic == null
            ? MockTutor.explainLesson(code, context: ctx, grade: grade)
            : MockTutor.explain(topic, grade, code);
        final note = MockTutor.performanceNote(code, ctx.recentQuizPercent);
        return TutorReply(text: '$lead$body$note');

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

/// Production-shaped remote tutor.
///
/// The intended architecture is:  Flutter App → Secure Backend → AI Provider.
/// This class talks to YOUR backend via a [TutorApiClient]; the backend holds
/// the AI provider's API key. **No API key is ever stored in the app.**
///
/// Cost control & safety are handled before any network call:
///  1. **Safety** — sensitive questions get a safe, local, educational answer
///     and never reach the paid API.
///  2. **Local knowledge** — if the offline mock can answer confidently, we use
///     it (no API call).
///  3. **Cache** — identical questions reuse the previous backend answer.
///  4. Otherwise a **minimal** request is sent to the backend.
///
/// Until a backend is configured it reports "not connected" so callers fall
/// back to [MockTutorService] and the app keeps working offline.
class RemoteTutorService implements TutorService {
  const RemoteTutorService({
    this.backendUrl,
    this.apiClient = const UnconfiguredTutorApiClient(),
    this.cache,
  });

  /// URL of your secure backend endpoint (informational; the [apiClient] does
  /// the actual transport). When null and the client is unconfigured, the
  /// service is disabled.
  final String? backendUrl;

  /// Transport to the secure backend.
  final TutorApiClient apiClient;

  /// Optional in-memory response cache (cost control). Shared across calls.
  final TutorResponseCache? cache;

  bool get isConfigured =>
      apiClient.isConfigured ||
      (backendUrl != null && backendUrl!.isNotEmpty);

  @override
  Future<TutorReply> respond(TutorRequest request) async {
    if (!isConfigured) {
      throw StateError('Remote tutor backend is not configured.');
    }

    final ctx = request.context;
    final code = ctx.languageCode;

    // 1) Safety first — no paid API call for sensitive topics.
    final safe = MockTutor.safety(request.message, code);
    if (safe != null) return TutorReply(text: safe);

    // If the transport isn't wired yet (only a URL was provided), we cannot
    // make a real call in this build.
    if (!apiClient.isConfigured) {
      throw UnimplementedError(
          'Configure a TutorApiClient to call the backend.');
    }

    final apiRequest = TutorApiRequest.fromContext(
      ctx,
      intent: request.intent,
      message: request.message,
    );

    // 2) Cache lookup (cost control).
    final cached = cache?.get(apiRequest.cacheKey);
    if (cached != null) return TutorReply(text: cached.answer);

    // 3) Minimal request to the secure backend.
    final response = await apiClient.ask(apiRequest);
    cache?.put(apiRequest.cacheKey, response);
    return TutorReply(text: response.answer);
  }
}

/// A tiny in-memory cache for backend answers (AI cost control). Bounded so it
/// never grows without limit on a low-RAM device.
class TutorResponseCache {
  TutorResponseCache({this.maxEntries = 64});
  final int maxEntries;
  final Map<String, TutorApiResponse> _store = {};

  TutorApiResponse? get(String key) => _store[key];

  void put(String key, TutorApiResponse response) {
    if (_store.length >= maxEntries && !_store.containsKey(key)) {
      _store.remove(_store.keys.first); // simple FIFO eviction
    }
    _store[key] = response;
  }

  void clear() => _store.clear();
}

/// Back-compat alias for the remote service (kept so existing references and
/// tests continue to work).
class FutureRemoteTutorService extends RemoteTutorService {
  const FutureRemoteTutorService() : super();
}

/// The tutor service the app uses today (mock, offline). Swap this override for
/// a [RemoteTutorService] pointed at your secure backend in the future — no UI
/// changes required.
final tutorServiceProvider =
    Provider<TutorService>((ref) => const MockTutorService());
