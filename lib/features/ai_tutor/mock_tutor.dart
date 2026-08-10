/// A tiny rule-based "AI" that produces friendly, pedagogical replies.
///
/// This is a MOCK — there is no network call and no real AI model. It exists so
/// the AI Tutor screen is fully functional offline. Swap [MockTutor.reply] for a
/// real assistant later without touching the UI.
class MockTutor {
  /// Returns a helpful reply for the given [question] in the [languageCode].
  static String reply(String question, String languageCode) {
    final q = question.toLowerCase();

    bool has(List<String> keys) => keys.any(q.contains);

    if (has(['fraction', 'کسر', 'kasar'])) {
      return _byLang(
        languageCode,
        en: 'No problem! Imagine one bread cut into 4 equal parts. If we take one part, that is 1/4. The bottom number tells how many equal parts in total.',
        ur: 'کوئی بات نہیں۔ فرض کریں ایک روٹی کو چار برابر حصوں میں تقسیم کیا جائے۔ اگر ہم ایک حصہ لیں تو یہ 1/4 ہوگا۔ نیچے کا عدد بتاتا ہے کہ کل کتنے برابر حصے ہیں۔',
        ps: 'کومه ستونزه نشته. تصور وکړئ چې یوه ډوډۍ په څلورو برابرو برخو ووېشل شي. که یوه برخه واخلو، دا ۱/۴ دی. ښکتنۍ شمېره ښیي چې ټول څو برابرې برخې دي.',
      );
    }
    if (has(['multipl', 'ضرب', 'zarb', 'times'])) {
      return _byLang(
        languageCode,
        en: 'Multiplication is repeated addition. 3 × 4 means adding 4 three times: 4 + 4 + 4 = 12.',
        ur: 'ضرب بار بار جمع کرنا ہے۔ 3 × 4 کا مطلب 4 کو تین بار جمع کرنا: 4 + 4 + 4 = 12۔',
        ps: 'ضرب تکرارې جمع ده. ۳ × ۴ یعنې ۴ درې ځله جمع: ۴ + ۴ + ۴ = ۱۲.',
      );
    }
    if (has(['divi', 'تقسیم', 'وېش'])) {
      return _byLang(
        languageCode,
        en: 'Division shares a number into equal groups. 12 ÷ 3 = 4 means 12 shared into 3 groups gives 4 in each group.',
        ur: 'تقسیم کسی عدد کو برابر گروہوں میں بانٹنا ہے۔ 12 ÷ 3 = 4 یعنی 12 کو 3 گروہوں میں بانٹنے سے ہر گروہ میں 4۔',
        ps: 'وېش یوه شمېره په برابرو ډلو وېشي. ۱۲ ÷ ۳ = ۴ یعنې ۱۲ په ۳ ډلو کې هره ۴.',
      );
    }
    if (has(['plant', 'پودا', 'پودے', 'بوټ'])) {
      return _byLang(
        languageCode,
        en: 'A plant has roots, a stem, leaves and flowers. Roots drink water from the soil, and leaves make food using sunlight.',
        ur: 'پودے کی جڑیں، تنا، پتے اور پھول ہوتے ہیں۔ جڑیں مٹی سے پانی لیتی ہیں اور پتے سورج کی روشنی سے خوراک بناتے ہیں۔',
        ps: 'بوټی ولې، ډډ، پاڼې او ګلونه لري. ولې له خاورې اوبه څښي او پاڼې د لمر رڼا سره خواړه جوړوي.',
      );
    }

    // Default encouraging reply.
    return _byLang(
      languageCode,
      en: "Good question! Let's break it into small steps. Tell me the topic — like fractions, multiplication or plants — and I'll explain it with a simple example.",
      ur: 'اچھا سوال! آئیے اسے چھوٹے مرحلوں میں سمجھتے ہیں۔ مجھے موضوع بتائیں — جیسے کسر، ضرب یا پودے — اور میں اسے آسان مثال سے سمجھاؤں گا۔',
      ps: 'ښه پوښتنه! راځئ چې دا په وړو ګامونو کې تشریح کړو. موضوع راته ووایاست — لکه کسر، ضرب یا بوټي — او زه به یې په ساده مثال تشریح کړم.',
    );
  }

  /// A gentle "explain the lesson" style reply.
  static String explainLesson(String languageCode) {
    return _byLang(
      languageCode,
      en: "Let's take it step by step. Read the objective, then the example, and try one small question. Tell me the topic and I'll explain it simply.",
      ur: 'آئیے قدم بہ قدم چلتے ہیں۔ پہلے مقصد پڑھیں، پھر مثال، اور ایک چھوٹا سوال حل کریں۔ مجھے موضوع بتائیں تو میں آسان انداز میں سمجھاؤں گا۔',
      ps: 'راځئ ګام په ګام یې وکړو. لومړی موخه ولولئ، بیا مثال، او یوه کوچنۍ پوښتنه حل کړئ. موضوع راته ووایاست چې په ساده ډول یې تشریح کړم.',
    );
  }

  /// A concrete, easy worked example (fractions).
  static String easyExample(String languageCode) {
    return _byLang(
      languageCode,
      en: 'Imagine one bread cut into 4 equal parts. If you take one part, that is 1/4. If you take two parts, that is 2/4 = 1/2.',
      ur: 'ایک روٹی کو چار برابر حصوں میں تقسیم کرنے کا تصور کریں۔ اگر آپ ایک حصہ لیتے ہیں تو یہ 1/4 ہے۔ اگر دو حصے لیں تو یہ 2/4 = 1/2 ہے۔',
      ps: 'تصور وکړئ چې یوه ډوډۍ په څلورو برابرو برخو وویشل شي. که یوه برخه واخلئ، دا ۱/۴ ده. که دوه برخې واخلئ، دا ۲/۴ = ۱/۲ ده.',
    );
  }

  /// A tiny follow-up practice question the tutor can offer.
  static String practicePrompt(String languageCode) {
    return _byLang(
      languageCode,
      en: 'A bread is cut into 4 equal parts. One part is which fraction?',
      ur: 'ایک روٹی کے 4 برابر حصے کیے گئے۔ ایک حصہ کون سا fraction ہے؟',
      ps: 'یوه ډوډۍ په ۴ برابرو برخو ووېشل شوه. یوه برخه کوم کسر دی؟',
    );
  }

  static String _byLang(String code,
      {required String en, required String ur, required String ps}) {
    switch (code) {
      case 'ur':
        return ur;
      case 'ps':
        return ps;
      default:
        return en;
    }
  }
}
