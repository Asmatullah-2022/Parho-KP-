import 'tutor_models.dart';

/// The wire contract between the app and YOUR secure backend.
///
///   Flutter app  ─►  Secure backend  ─►  AI provider
///
/// The app sends a [TutorApiRequest]; the backend (which holds the AI
/// provider's API key) returns a [TutorApiResponse]. **No API key is ever
/// stored in the app.** Payloads are deliberately minimal to keep requests
/// cheap and low-bandwidth (AI cost control): only the fields the tutor needs.
class TutorApiRequest {
  const TutorApiRequest({
    required this.grade,
    required this.languageCode,
    required this.intent,
    this.message = '',
    this.subject,
    this.unit,
    this.topic,
    this.recentQuizPercent,
  });

  final int grade;
  final String languageCode;

  /// A short intent string (matches [TutorIntent.name]) so the backend can pick
  /// the right prompt without the app sending a long system prompt every call.
  final String intent;
  final String message;
  final String? subject;
  final String? unit;
  final String? topic;
  final int? recentQuizPercent;

  /// Builds a minimal request from app-side context (cost control: we send the
  /// least the backend needs, not the whole conversation).
  factory TutorApiRequest.fromContext(
    TutorContext ctx, {
    required TutorIntent intent,
    String message = '',
  }) =>
      TutorApiRequest(
        grade: ctx.grade,
        languageCode: ctx.languageCode,
        intent: intent.name,
        message: message,
        subject: ctx.subjectName,
        unit: ctx.unitName,
        topic: ctx.topic ?? ctx.lessonTitle,
        recentQuizPercent: ctx.recentQuizPercent,
      );

  Map<String, Object?> toJson() => {
        'grade': grade,
        'language': languageCode,
        'intent': intent,
        if (message.isNotEmpty) 'message': message,
        if (subject != null) 'subject': subject,
        if (unit != null) 'unit': unit,
        if (topic != null) 'topic': topic,
        if (recentQuizPercent != null) 'recentQuizPercent': recentQuizPercent,
      };

  /// A stable cache key so identical questions aren't re-sent (cost control).
  String get cacheKey =>
      '$languageCode|$grade|$intent|${topic ?? ''}|${message.trim().toLowerCase()}';
}

/// A non-teaching action the backend can suggest for the app to surface.
enum TutorSuggestedAction {
  none,
  reviewLesson,
  practiceMore,
  tryNextLesson,
  askTeacher,
}

TutorSuggestedAction _actionFromString(String? s) => switch (s) {
      'reviewLesson' => TutorSuggestedAction.reviewLesson,
      'practiceMore' => TutorSuggestedAction.practiceMore,
      'tryNextLesson' => TutorSuggestedAction.tryNextLesson,
      'askTeacher' => TutorSuggestedAction.askTeacher,
      _ => TutorSuggestedAction.none,
    };

/// The backend's reply. `safetyFlag` is true when the backend classified the
/// question as sensitive and returned a safe, non-harmful, educational answer.
class TutorApiResponse {
  const TutorApiResponse({
    required this.answer,
    required this.language,
    this.suggestedAction = TutorSuggestedAction.none,
    this.safetyFlag = false,
  });

  final String answer;
  final String language;
  final TutorSuggestedAction suggestedAction;
  final bool safetyFlag;

  factory TutorApiResponse.fromJson(Map<String, dynamic> json) {
    // Validate untrusted network input defensively (never trust the wire).
    final answer = json['answer'];
    if (answer is! String || answer.trim().isEmpty) {
      throw const FormatException('Tutor response missing "answer".');
    }
    return TutorApiResponse(
      answer: answer,
      language: (json['language'] as String?) ?? 'en',
      suggestedAction: _actionFromString(json['suggestedAction'] as String?),
      safetyFlag: (json['safetyFlag'] as bool?) ?? false,
    );
  }
}

/// Transport to the secure backend. A real implementation POSTs
/// [TutorApiRequest.toJson] to your endpoint over HTTPS and parses the JSON
/// with [TutorApiResponse.fromJson]. Kept behind an interface so no networking
/// code (or secret) lives in the UI layer.
abstract class TutorApiClient {
  bool get isConfigured;
  Future<TutorApiResponse> ask(TutorApiRequest request);
}

/// Default client: not configured. Callers fall back to the offline mock tutor
/// so the app keeps working with no backend.
class UnconfiguredTutorApiClient implements TutorApiClient {
  const UnconfiguredTutorApiClient();
  @override
  bool get isConfigured => false;
  @override
  Future<TutorApiResponse> ask(TutorApiRequest request) async {
    throw StateError('Tutor backend is not configured.');
  }
}
