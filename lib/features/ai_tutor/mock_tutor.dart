import 'tutor_models.dart';

/// Trilingual string.
class _T {
  const _T(this.en, this.ur, this.ps);
  final String en;
  final String ur;
  final String ps;
  String pick(String code) => switch (code) {
        'ur' => ur,
        'ps' => ps,
        _ => en,
      };
}

class _QSpec {
  const _QSpec(this.prompt, this.options, this.correct);
  final _T prompt;
  final List<_T> options;
  final int correct;
}

class _Knowledge {
  const _Knowledge({
    required this.simple,
    this.detailed,
    required this.example,
    required this.question,
    required this.keywords,
  });
  final _T simple;
  final _T? detailed;
  final _T example;
  final _QSpec question;
  final List<String> keywords;
}

/// On-device, rule-based tutor knowledge. This is a MOCK — no network, no real
/// model. It returns friendly, deterministic, grade-aware answers so the AI
/// Tutor is fully useful offline. Replace with a real backend later by
/// implementing `TutorService`; this class does not need to change.
abstract final class MockTutor {
  // ---- public API --------------------------------------------------------

  /// Free-text answer (used for typed questions and back-compat).
  static String reply(String question, String code, {int grade = 5}) {
    final safe = safety(question, code);
    if (safe != null) return safe;
    final topic = detectTopic(question, null);
    if (topic != null) return explain(topic, grade, code);
    return fallback(code);
  }

  /// A gentle "explain the whole lesson" answer using context if available.
  static String explainLesson(String code, {TutorContext? context, int grade = 5}) {
    final g = context?.grade ?? grade;
    final topic = _topicFromContext(context) ?? detectTopic('', context);
    if (topic != null) {
      final parts = <String>[
        if (context?.objective != null && context!.objective!.isNotEmpty)
          context.objective!,
        explain(topic, g, code, detailed: g >= 7),
      ];
      return parts.join('\n\n');
    }
    if (context?.objective != null && context!.objective!.isNotEmpty) {
      return context.objective!;
    }
    return _byLang(code,
        en: "Let's read the lesson together, step by step. Tell me the part you find hard and I'll explain it simply.",
        ur: 'آئیے سبق کو مل کر قدم بہ قدم پڑھتے ہیں۔ مجھے وہ حصہ بتائیں جو مشکل لگے، میں اسے آسان کر کے سمجھاؤں گا۔',
        ps: 'راځئ درس سره ګام په ګام ولولو. هغه برخه راته ووایاست چې ستونزمنه ښکاري، زه به یې ساده کړم.');
  }

  /// A concrete worked example for the current topic.
  static String easyExample(String code, {TutorContext? context, int grade = 5}) {
    final topic = _topicFromContext(context) ?? 'fractions';
    final k = _knowledge[topic];
    if (k != null) return k.example.pick(code);
    return _knowledge['fractions']!.example.pick(code);
  }

  /// A friendly, grade-aware explanation of a known topic.
  static String explain(String topic, int grade, String code,
      {bool detailed = false}) {
    final k = _knowledge[topic];
    if (k == null) return fallback(code);
    final band = _band(grade);
    final body = (detailed || band == _Band.older) && k.detailed != null
        ? k.detailed!.pick(code)
        : k.simple.pick(code);
    return '${_leadIn(band, code)}$body';
  }

  /// "Explain for my class" — names the grade and keeps it appropriate.
  static String explainForClass(String topic, int grade, String code) {
    final k = _knowledge[topic];
    final body = k == null
        ? fallback(code)
        : explain(topic, grade, code, detailed: grade >= 7);
    final prefix = _byLang(code,
        en: 'For Grade $grade: ',
        ur: 'جماعت $grade کے لیے: ',
        ps: 'د $grade ټولګي لپاره: ');
    return '$prefix$body';
  }

  /// A concrete example.
  static String example(String topic, String code) {
    final k = _knowledge[topic];
    if (k == null) return _knowledge['fractions']!.example.pick(code);
    return k.example.pick(code);
  }

  /// An alternate phrasing of the explanation.
  static String explainAnother(String topic, int grade, String code) {
    final k = _knowledge[topic];
    if (k == null) return fallback(code);
    final lead = _byLang(code,
        en: 'Another way to see it: ',
        ur: 'اسے دیکھنے کا ایک اور طریقہ: ',
        ps: 'د لیدو بله لاره: ');
    return '$lead${k.example.pick(code)}';
  }

  /// Localized understanding question for a topic (or null if unknown).
  static TutorQuestion? question(String? topic, String code) {
    final key = topic ?? 'fractions';
    final k = _knowledge[key] ?? _knowledge['fractions'];
    if (k == null) return null;
    return TutorQuestion(
      prompt: k.question.prompt.pick(code),
      options: k.question.options.map((o) => o.pick(code)).toList(),
      correctIndex: k.question.correct,
    );
  }

  /// Resolves the best topic for a request from free text and/or context.
  static String? detectTopic(String text, TutorContext? context) {
    final hay = text.toLowerCase();
    for (final entry in _knowledge.entries) {
      for (final kw in entry.value.keywords) {
        if (hay.contains(kw.toLowerCase())) return entry.key;
      }
    }
    return _topicFromContext(context);
  }

  static String? _topicFromContext(TutorContext? context) {
    if (context == null) return null;
    final hay =
        '${context.topic ?? ''} ${context.lessonTitle ?? ''} ${context.unitName ?? ''} ${context.subjectName ?? ''}'
            .toLowerCase();
    for (final entry in _knowledge.entries) {
      for (final kw in entry.value.keywords) {
        if (hay.contains(kw.toLowerCase())) return entry.key;
      }
    }
    return null;
  }

  /// A safe educational response for medical/legal/dangerous questions, or null.
  static String? safety(String text, String code) {
    final hay = text.toLowerCase();
    const danger = [
      'medicine', 'medical', 'dawa', 'دوا', 'دارو', 'illness', 'bimari',
      'بیماری', 'ناروغي', 'injury', 'poison', 'زہر', 'زهر',
      'law', 'legal', 'court', 'قانون', 'عدالت', 'محکمه',
      'weapon', 'gun', 'bomb', 'اسلحہ', 'بم', 'وسله', 'fire', 'اگ', 'اور',
    ];
    if (danger.any(hay.contains)) {
      return _byLang(code,
          en: "That's an important question. For health, safety or legal matters, please talk to a trusted adult — a parent, teacher or qualified professional. I can help you with your school lessons.",
          ur: 'یہ ایک اہم سوال ہے۔ صحت، حفاظت یا قانونی معاملات کے لیے براہِ کرم کسی بھروسے مند بڑے — والدین، استاد یا ماہر — سے بات کریں۔ میں آپ کی اسکول کی پڑھائی میں مدد کر سکتا ہوں۔',
          ps: 'دا یوه مهمه پوښتنه ده. د روغتیا، خوندیتوب یا قانوني چارو لپاره، مهرباني وکړئ له یو باوري لوی — مور و پلار، ښوونکي یا مسلکي کس — سره خبرې وکړئ. زه ستاسو د ښوونځي په درسونو کې مرسته کولی شم.');
    }
    return null;
  }

  /// A short recommendation based on the student's recent quiz score for the
  /// current lesson (review vs. move on). Returns '' when no score is known.
  static String performanceNote(String code, int? recentQuizPercent) {
    if (recentQuizPercent == null) return '';
    if (recentQuizPercent < 60) {
      return _byLang(code,
          en: " Your last quiz here was $recentQuizPercent% — let's review this topic again together.",
          ur: ' آپ کا پچھلا Quiz $recentQuizPercent% تھا — آئیے اس موضوع کو دوبارہ دہراتے ہیں۔',
          ps: ' ستاسو وروستی Quiz $recentQuizPercent% و — راځئ دا موضوع بیا تکرار کړو.');
    }
    if (recentQuizPercent >= 80) {
      return _byLang(code,
          en: " Great — your last quiz was $recentQuizPercent%. You look ready for the next lesson!",
          ur: ' بہت خوب — آپ کا پچھلا Quiz $recentQuizPercent% تھا۔ آپ اگلے سبق کے لیے تیار لگتے ہیں!',
          ps: ' ډېر ښه — ستاسو وروستی Quiz $recentQuizPercent% و. تاسو د بل درس لپاره چمتو ښکارئ!');
    }
    return _byLang(code,
        en: " Keep practicing — a little more and you'll master this.",
        ur: ' مشق جاری رکھیں — تھوڑی اور محنت سے آپ اس میں ماہر ہو جائیں گے۔',
        ps: ' تمرین ته دوام ورکړئ — لږ نور او تاسو به پرې ماهر شئ.');
  }

  /// Friendly fallback when the mock has no answer. Never pretends to know.
  static String fallback(String code) {
    return _byLang(code,
        en: "I'm still learning about this topic. Please also ask your teacher for guidance.",
        ur: 'میں اس موضوع کے بارے میں ابھی سیکھنے کے لیے تیار ہوں۔ براہ کرم اپنے استاد سے بھی رہنمائی لیں۔',
        ps: 'زه لا هم د دې موضوع په اړه زده کوم. مهرباني وکړئ له خپل ښوونکي څخه هم لارښوونه وغواړئ.');
  }

  // ---- helpers -----------------------------------------------------------

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

  static _Band _band(int grade) {
    if (grade <= 3) return _Band.young;
    if (grade <= 6) return _Band.mid;
    return _Band.older;
  }

  static String _leadIn(_Band band, String code) {
    switch (band) {
      case _Band.young:
        return _byLang(code,
            en: 'In very easy words: ',
            ur: 'بہت آسان الفاظ میں: ',
            ps: 'په ډېرو ساده ټکو کې: ');
      case _Band.mid:
        return _byLang(code,
            en: 'Simply put: ',
            ur: 'آسان انداز میں: ',
            ps: 'په ساده ډول: ');
      case _Band.older:
        return _byLang(code,
            en: "Here's a clear explanation: ",
            ur: 'واضح انداز میں: ',
            ps: 'په څرګند ډول: ');
    }
  }
}

enum _Band { young, mid, older }

// ---------------------------------------------------------------------------
// DEMO knowledge base (original, offline, not from any copyrighted textbook)
// ---------------------------------------------------------------------------

const Map<String, _Knowledge> _knowledge = {
  'fractions': _Knowledge(
    keywords: ['fraction', 'کسر', 'kasar', 'numerator', 'denominator', 'مخرج'],
    simple: _T(
      'A fraction is a part of a whole. Cut one bread into 4 equal parts — one part is 1/4.',
      'کسر کسی مکمل چیز کا ایک حصہ ہے۔ ایک روٹی کو 4 برابر حصوں میں کاٹیں — ایک حصہ 1/4 ہے۔',
      'کسر د یو بشپړ شي یوه برخه ده. یوه ډوډۍ په ۴ برابرو برخو ووېشئ — یوه برخه ۱/۴ ده.',
    ),
    detailed: _T(
      'A fraction has two numbers. The bottom (denominator) shows how many equal parts the whole is divided into; the top (numerator) shows how many parts we take. So 3/4 means 3 of 4 equal parts.',
      'کسر میں دو عدد ہوتے ہیں۔ نیچے والا (مخرج) بتاتا ہے کہ پوری چیز کو کتنے برابر حصوں میں بانٹا گیا؛ اوپر والا (عدد نما) بتاتا ہے کہ ہم کتنے حصے لیتے ہیں۔ تو 3/4 کا مطلب 4 برابر حصوں میں سے 3 حصے۔',
      'کسر دوه شمېرې لري. ښکتنۍ (مخرج) ښیي چې بشپړ شی په څو برابرو برخو وېشل شوی؛ پورتنۍ (شمېرونکی) ښیي چې موږ څو برخې اخلو. نو ۳/۴ یعنې د ۴ برابرو برخو څخه ۳ برخې.',
    ),
    example: _T(
      'A pizza is cut into 8 slices. If you eat 3 slices, you ate 3/8 of the pizza.',
      'ایک پیزا 8 ٹکڑوں میں کٹا ہے۔ اگر آپ 3 ٹکڑے کھائیں تو آپ نے پیزا کا 3/8 کھایا۔',
      'یو پیزا په ۸ ټوټو ووېشل شو. که ۳ ټوټې وخورئ، نو د پیزا ۳/۸ مو وخوړ.',
    ),
    question: _QSpec(
      _T('A cake is cut into 4 equal parts. You eat 1 part. How much cake did you eat?',
          'ایک کیک کو 4 برابر حصوں میں تقسیم کیا گیا۔ آپ 1 حصہ کھاتے ہیں۔ آپ نے کتنا کیک کھایا؟',
          'یوه کیک په ۴ برابرو برخو ووېشل شوه. تاسو ۱ برخه خورئ. څومره کیک مو وخوړه؟'),
      [
        _T('1/2', '1/2', '۱/۲'),
        _T('1/3', '1/3', '۱/۳'),
        _T('1/4', '1/4', '۱/۴'),
        _T('4/4', '4/4', '۴/۴'),
      ],
      2,
    ),
  ),
  'multiplication': _Knowledge(
    keywords: ['multipl', 'ضرب', 'zarb', 'times', 'table'],
    simple: _T(
      'Multiplication is quick repeated addition. 3 × 4 means 4 + 4 + 4 = 12.',
      'ضرب دراصل بار بار جمع کرنا ہے۔ 3 × 4 کا مطلب 4 + 4 + 4 = 12۔',
      'ضرب په حقیقت کې تکرارې جمع ده. ۳ × ۴ یعنې ۴ + ۴ + ۴ = ۱۲.',
    ),
    example: _T(
      'If one basket has 5 apples and there are 3 baskets, that is 5 × 3 = 15 apples.',
      'اگر ایک ٹوکری میں 5 سیب ہوں اور 3 ٹوکریاں ہوں تو یہ 5 × 3 = 15 سیب ہیں۔',
      'که په یوه ټوکرۍ کې ۵ مڼې وي او ۳ ټوکرۍ وي، نو دا ۵ × ۳ = ۱۵ مڼې دي.',
    ),
    question: _QSpec(
      _T('What is 3 × 4?', '3 × 4 کتنا ہے؟', '۳ × ۴ څومره دی؟'),
      [
        _T('12', '12', '۱۲'),
        _T('7', '7', '۷'),
        _T('9', '9', '۹'),
        _T('16', '16', '۱۶'),
      ],
      0,
    ),
  ),
  'division': _Knowledge(
    keywords: ['divi', 'تقسیم', 'وېش', 'share equally'],
    simple: _T(
      'Division shares a number into equal groups. 12 ÷ 3 = 4 means 12 shared into 3 groups gives 4 each.',
      'تقسیم کسی عدد کو برابر گروہوں میں بانٹتی ہے۔ 12 ÷ 3 = 4 یعنی 12 کو 3 گروہوں میں بانٹنے سے ہر گروہ میں 4۔',
      'وېش یوه شمېره په برابرو ډلو وېشي. ۱۲ ÷ ۳ = ۴ یعنې ۱۲ په ۳ ډلو کې هره ۴.',
    ),
    example: _T(
      'Share 10 sweets equally among 2 friends: 10 ÷ 2 = 5 sweets each.',
      '10 مٹھائیاں 2 دوستوں میں برابر بانٹیں: 10 ÷ 2 = 5 فی دوست۔',
      '۱۰ خوږې د ۲ ملګرو ترمنځ برابرې ووېشئ: ۱۰ ÷ ۲ = هر یو ۵.',
    ),
    question: _QSpec(
      _T('What is 12 ÷ 3?', '12 ÷ 3 کتنا ہے؟', '۱۲ ÷ ۳ څومره دی؟'),
      [
        _T('4', '4', '۴'),
        _T('3', '3', '۳'),
        _T('6', '6', '۶'),
        _T('9', '9', '۹'),
      ],
      0,
    ),
  ),
  'plants': _Knowledge(
    keywords: ['plant', 'پودا', 'پودے', 'بوټ', 'roots', 'جڑ', 'leaves', 'پتے', 'پاڼ'],
    simple: _T(
      'A plant has roots, a stem, leaves and flowers. Roots drink water; leaves make food using sunlight.',
      'پودے کی جڑیں، تنا، پتے اور پھول ہوتے ہیں۔ جڑیں پانی پیتی ہیں؛ پتے سورج کی روشنی سے خوراک بناتے ہیں۔',
      'بوټی ولې، ډډ، پاڼې او ګلونه لري. ولې اوبه څښي؛ پاڼې د لمر رڼا سره خواړه جوړوي.',
    ),
    example: _T(
      'A mango tree: its roots hold it in the soil and drink water, and its leaves make food.',
      'آم کا درخت: اس کی جڑیں اسے مٹی میں تھامتی اور پانی پیتی ہیں، اور پتے خوراک بناتے ہیں۔',
      'د آم ونه: ولې یې په خاوره کې ټینګوي او اوبه څښي، او پاڼې یې خواړه جوړوي.',
    ),
    question: _QSpec(
      _T('Which part of a plant makes food using sunlight?',
          'پودے کا کون سا حصہ سورج کی روشنی سے خوراک بناتا ہے؟',
          'د بوټي کومه برخه د لمر رڼا سره خواړه جوړوي؟'),
      [
        _T('Leaves', 'پتے', 'پاڼې'),
        _T('Roots', 'جڑیں', 'ولې'),
        _T('Stem', 'تنا', 'ډډ'),
        _T('Seed', 'بیج', 'تخم'),
      ],
      0,
    ),
  ),
  'water': _Knowledge(
    keywords: ['water', 'پانی', 'اوبه', 'ice', 'برف', 'کنګل', 'steam', 'بھاپ'],
    simple: _T(
      'Water can be a solid (ice), a liquid (water) or a gas (steam). Heating and cooling change its state.',
      'پانی ٹھوس (برف)، مائع (پانی) یا گیس (بھاپ) ہو سکتا ہے۔ گرم یا ٹھنڈا کرنے سے اس کی حالت بدلتی ہے۔',
      'اوبه کلک (کنګل)، مایع (اوبه) یا ګاز (بړاس) کیدی شي. ګرمول او یخول یې حالت بدلوي.',
    ),
    example: _T(
      'Put water in a freezer and it becomes ice; boil it and it becomes steam.',
      'پانی فریزر میں رکھیں تو برف بن جاتا ہے؛ ابالیں تو بھاپ بن جاتا ہے۔',
      'اوبه په فریزر کې کېږدئ کنګل کیږي؛ وې اېشوئ بړاس کیږي.',
    ),
    question: _QSpec(
      _T('Ice is the … state of water.', 'برف پانی کی … حالت ہے۔',
          'کنګل د اوبو د … حالت دی.'),
      [
        _T('Solid', 'ٹھوس', 'کلک'),
        _T('Liquid', 'مائع', 'مایع'),
        _T('Gas', 'گیس', 'ګاز'),
        _T('None', 'کوئی نہیں', 'هیڅ'),
      ],
      0,
    ),
  ),
  'living': _Knowledge(
    keywords: ['living', 'جاندار', 'ژوندي', 'non-living', 'بے جان', 'بې ژوند'],
    simple: _T(
      'Living things grow, eat and breathe — like people, animals and plants. Non-living things do not, like stones and chairs.',
      'جاندار بڑھتے، کھاتے اور سانس لیتے ہیں — جیسے انسان، جانور اور پودے۔ بے جان ایسا نہیں کرتے، جیسے پتھر اور کرسی۔',
      'ژوندي شیان لویږي، خوري او ساه اخلي — لکه انسانان، حیوانات او بوټي. بې ژوند شیان داسې نه کوي، لکه تیږه او څوکۍ.',
    ),
    example: _T(
      'A dog is living because it eats and grows. A rock is non-living.',
      'کتا جاندار ہے کیونکہ وہ کھاتا اور بڑھتا ہے۔ پتھر بے جان ہے۔',
      'سپی ژوندی دی ځکه خوري او لویږي. تیږه بې ژوند ده.',
    ),
    question: _QSpec(
      _T('Which one is a living thing?', 'کون سا جاندار ہے؟',
          'کوم یو ژوندی شی دی؟'),
      [
        _T('Tree', 'درخت', 'ونه'),
        _T('Stone', 'پتھر', 'تیږه'),
        _T('Chair', 'کرسی', 'څوکۍ'),
        _T('Pen', 'قلم', 'قلم'),
      ],
      0,
    ),
  ),
  'nouns': _Knowledge(
    keywords: ['noun', 'اسم', 'naming word'],
    simple: _T(
      'A noun (ism) is a naming word — the name of a person, place, animal or thing, like Ahmed, Peshawar, cat or book.',
      'اسم نام والا لفظ ہے — کسی شخص، جگہ، جانور یا چیز کا نام، جیسے احمد، پشاور، بلی یا کتاب۔',
      'اسم د نوم کلمه ده — د یو کس، ځای، حیوان یا شي نوم، لکه احمد، پېښور، پیشو یا کتاب.',
    ),
    example: _T(
      'In "Ahmed reads a book", the words "Ahmed" and "book" are nouns.',
      '"احمد کتاب پڑھتا ہے" میں "احمد" اور "کتاب" اسم ہیں۔',
      'په "احمد کتاب لولي" کې "احمد" او "کتاب" اسمونه دي.',
    ),
    question: _QSpec(
      _T('Which word is a noun?', 'کون سا لفظ اسم ہے؟', 'کومه کلمه اسم ده؟'),
      [
        _T('Book', 'کتاب', 'کتاب'),
        _T('Run', 'دوڑنا', 'منډه'),
        _T('Fast', 'تیز', 'ګړندی'),
        _T('Slowly', 'آہستہ', 'ورو'),
      ],
      0,
    ),
  ),
  'verbs': _Knowledge(
    keywords: ['verb', 'فعل', 'action word'],
    simple: _T(
      'A verb (fail) is an action word — it tells what someone does, like read, write, run or eat.',
      'فعل کام والا لفظ ہے — یہ بتاتا ہے کوئی کیا کرتا ہے، جیسے پڑھنا، لکھنا، دوڑنا یا کھانا۔',
      'فعل د کار کلمه ده — دا ښیي چې څوک څه کوي، لکه لوستل، لیکل، منډه یا خوړل.',
    ),
    example: _T(
      'In "Sana writes a letter", the word "writes" is the verb.',
      '"ثنا خط لکھتی ہے" میں لفظ "لکھتی" فعل ہے۔',
      'په "ثنا لیک لیکي" کې کلمه "لیکي" فعل دی.',
    ),
    question: _QSpec(
      _T('Which word is a verb?', 'کون سا لفظ فعل ہے؟', 'کومه کلمه فعل ده؟'),
      [
        _T('Eat', 'کھانا', 'خوړل'),
        _T('Table', 'میز', 'مېز'),
        _T('Red', 'سرخ', 'سور'),
        _T('School', 'اسکول', 'ښوونځی'),
      ],
      0,
    ),
  ),
  'reading': _Knowledge(
    keywords: ['reading', 'read', 'مطالعہ', 'لوستل', 'پڑھ'],
    simple: _T(
      'Reading means understanding words together as sentences. Read slowly and think about the meaning.',
      'مطالعہ کا مطلب الفاظ کو جملوں کی صورت میں سمجھنا ہے۔ آہستہ پڑھیں اور معنی پر غور کریں۔',
      'لوستل یعنې کلمې د جملو په بڼه پوهېدل. ورو ولولئ او په معنا فکر وکړئ.',
    ),
    example: _T(
      '"The sun rises in the east." Ask: what rises? The sun.',
      '"سورج مشرق سے نکلتا ہے۔" پوچھیں: کیا نکلتا ہے؟ سورج۔',
      '"لمر له ختیځه راخېژي." پوښتنه: څه راخېژي؟ لمر.',
    ),
    question: _QSpec(
      _T('In "The sun rises in the east", what rises?',
          '"سورج مشرق سے نکلتا ہے" میں کیا نکلتا ہے؟',
          'په "لمر له ختیځه راخېژي" کې څه راخېژي؟'),
      [
        _T('The sun', 'سورج', 'لمر'),
        _T('The moon', 'چاند', 'سپوږمۍ'),
        _T('A bird', 'پرندہ', 'مرغه'),
        _T('The rain', 'بارش', 'باران'),
      ],
      0,
    ),
  ),
  'pakistan': _Knowledge(
    keywords: ['pakistan', 'پاکستان', 'islamabad', 'اسلام آباد'],
    simple: _T(
      'Pakistan is our country. Its capital is Islamabad and its national language is Urdu.',
      'پاکستان ہمارا ملک ہے۔ اس کا دارالحکومت اسلام آباد اور قومی زبان اردو ہے۔',
      'پاکستان زموږ هیواد دی. پلازمینه یې اسلام آباد او ملي ژبه یې اردو ده.',
    ),
    example: _T(
      'The capital city of Pakistan is Islamabad.',
      'پاکستان کا دارالحکومت اسلام آباد ہے۔',
      'د پاکستان پلازمینه اسلام آباد ده.',
    ),
    question: _QSpec(
      _T('What is the capital of Pakistan?', 'پاکستان کا دارالحکومت کیا ہے؟',
          'د پاکستان پلازمینه څه ده؟'),
      [
        _T('Islamabad', 'اسلام آباد', 'اسلام آباد'),
        _T('Lahore', 'لاہور', 'لاهور'),
        _T('Karachi', 'کراچی', 'کراچي'),
        _T('Peshawar', 'پشاور', 'پېښور'),
      ],
      0,
    ),
  ),
  'kp': _Knowledge(
    keywords: [
      'khyber', 'pakhtunkhwa', 'پختونخوا', 'پښتونخوا', 'peshawar', 'پشاور', 'پېښور'
    ],
    simple: _T(
      'Khyber Pakhtunkhwa is a province of Pakistan. Its capital is Peshawar and many people speak Pashto.',
      'خیبر پختونخوا پاکستان کا ایک صوبہ ہے۔ اس کا دارالحکومت پشاور ہے اور بہت سے لوگ پښتو بولتے ہیں۔',
      'خیبر پښتونخوا د پاکستان یو ولایت دی. پلازمینه یې پېښور ده او ډېر خلک پښتو وایي.',
    ),
    example: _T(
      'The capital of Khyber Pakhtunkhwa is Peshawar.',
      'خیبر پختونخوا کا دارالحکومت پشاور ہے۔',
      'د خیبر پښتونخوا پلازمینه پېښور ده.',
    ),
    question: _QSpec(
      _T('What is the capital of Khyber Pakhtunkhwa?',
          'خیبر پختونخوا کا دارالحکومت کیا ہے؟',
          'د خیبر پښتونخوا پلازمینه څه ده؟'),
      [
        _T('Peshawar', 'پشاور', 'پېښور'),
        _T('Islamabad', 'اسلام آباد', 'اسلام آباد'),
        _T('Quetta', 'کوئٹہ', 'کوټه'),
        _T('Lahore', 'لاہور', 'لاهور'),
      ],
      0,
    ),
  ),
};
