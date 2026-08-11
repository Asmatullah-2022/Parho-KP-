import 'dart:convert';

import 'package:archive/archive.dart';

/// Builds the ORIGINAL DEMO content package archive used for development and
/// testing: **Grade 5 Mathematics — Fractions** (English + Urdu + Pashto),
/// 3 lessons with 10+ quiz questions total.
///
/// This is original demo content — it does not reproduce any copyrighted
/// textbook. The archive uses the real production package layout (manifest.json
/// + content/*.json), so it exercises the exact import path a downloaded
/// package would.
class DemoPackageBuilder {
  const DemoPackageBuilder();

  static const String packageId = 'grade5_math_ur_v1';
  static const int grade = 5;
  static const String version = '1';

  /// Returns the raw ZIP bytes of the demo package.
  List<int> buildZipBytes({String version = version}) {
    final manifest = {
      'packageId': packageId,
      'grade': grade,
      'subject': 'math',
      'language': 'ur',
      'version': version,
      'isDemo': true,
      'province': 'Khyber Pakhtunkhwa',
    };

    // Relational content files (ids link children to parents).
    final subjects = [
      {
        'id': 1,
        'code': 'math',
        'emoji': '➕',
        'name': {'en': 'Mathematics', 'ur': 'ریاضی', 'ps': 'ریاضي'},
      },
    ];
    final units = [
      {
        'id': 10,
        'subjectId': 1,
        'title': {'en': 'Fractions', 'ur': 'کسر', 'ps': 'کسرونه'},
      },
    ];
    final lessons = [
      {
        'id': 100,
        'unitId': 10,
        'title': {
          'en': 'Understanding Fractions',
          'ur': 'کسر کو سمجھنا',
          'ps': 'د کسرونو پوهه',
        },
        'objective': {
          'en': 'Understand what a fraction means (part of a whole).',
          'ur': 'سمجھیں کہ کسر کا مطلب کیا ہے (کل کا حصہ)۔',
          'ps': 'پوه شئ چې کسر څه معنا لري (د بشپړ یوه برخه).',
        },
        'explanation': {
          'en':
              'A fraction shows a part of a whole. In 1/2, the whole is split '
                  'into 2 equal parts and we take 1 part.',
          'ur':
              'کسر کل کا ایک حصہ ظاہر کرتا ہے۔ 1/2 میں کل کو 2 برابر حصوں میں '
                  'تقسیم کیا جاتا ہے اور ہم 1 حصہ لیتے ہیں۔',
          'ps':
              'کسر د بشپړ یوه برخه ښیي. په 1/2 کې بشپړ په 2 مساوي برخو ویشل '
                  'کیږي او موږ 1 برخه اخلو.',
        },
        'example': {
          'en': 'Half a roti is 1/2. A quarter is 1/4.',
          'ur': 'آدھی روٹی 1/2 ہے۔ چوتھائی 1/4 ہے۔',
          'ps': 'نیمه ډوډۍ 1/2 ده. څلورمه برخه 1/4 ده.',
        },
        'illustration': '🍕',
      },
      {
        'id': 101,
        'unitId': 10,
        'title': {
          'en': 'Comparing Fractions',
          'ur': 'کسروں کا موازنہ',
          'ps': 'د کسرونو پرتله',
        },
        'objective': {
          'en': 'Compare simple fractions with the same denominator.',
          'ur': 'ایک جیسے مخرج والی سادہ کسروں کا موازنہ کریں۔',
          'ps': 'د ورته مخرج سره ساده کسرونه پرتله کړئ.',
        },
        'explanation': {
          'en':
              'When the bottom numbers are equal, the fraction with the bigger '
                  'top number is larger: 3/4 is bigger than 1/4.',
          'ur':
              'جب نیچے کے اعداد برابر ہوں تو بڑے اوپر والے عدد والی کسر بڑی ہوتی '
                  'ہے: 3/4، 1/4 سے بڑی ہے۔',
          'ps':
              'کله چې لاندې شمېرې مساوي وي، هغه کسر چې پورتنۍ شمېره یې لویه وي '
                  'لوی دی: 3/4 له 1/4 لوی دی.',
        },
        'example': {
          'en': '2/5 and 4/5 → 4/5 is bigger.',
          'ur': '2/5 اور 4/5 → 4/5 بڑی ہے۔',
          'ps': '2/5 او 4/5 → 4/5 لوی دی.',
        },
        'illustration': '⚖️',
      },
      {
        'id': 102,
        'unitId': 10,
        'title': {
          'en': 'Adding Fractions',
          'ur': 'کسروں کی جمع',
          'ps': 'د کسرونو جمع',
        },
        'objective': {
          'en': 'Add fractions that share the same denominator.',
          'ur': 'ایک جیسے مخرج والی کسروں کو جمع کریں۔',
          'ps': 'هغه کسرونه چې ورته مخرج لري جمع کړئ.',
        },
        'explanation': {
          'en':
              'To add fractions with the same bottom number, add the top '
                  'numbers and keep the bottom: 1/4 + 2/4 = 3/4.',
          'ur':
              'ایک جیسے نیچے والے عدد والی کسروں کو جمع کرنے کے لیے اوپر والے '
                  'اعداد جمع کریں اور نیچے والا وہی رکھیں: 1/4 + 2/4 = 3/4۔',
          'ps':
              'د ورته لاندې شمېرې سره د کسرونو د جمع لپاره پورتنۍ شمېرې جمع کړئ '
                  'او لاندې همغه وساتئ: 1/4 + 2/4 = 3/4.',
        },
        'example': {
          'en': '1/5 + 3/5 = 4/5.',
          'ur': '1/5 + 3/5 = 4/5۔',
          'ps': '1/5 + 3/5 = 4/5.',
        },
        'illustration': '➕',
      },
    ];

    final questions = <Map<String, dynamic>>[];
    void addQ(int id, int lessonId, Map<String, String> prompt,
        List<Map<String, String>> options, int correct) {
      questions.add({
        'id': id,
        'lessonId': lessonId,
        'prompt': prompt,
        'options': options,
        'correctIndex': correct,
      });
    }

    Map<String, String> t(String en, String ur, String ps) =>
        {'en': en, 'ur': ur, 'ps': ps};

    // Lesson 100 — 4 questions.
    addQ(1000, 100, t('What does 1/2 mean?', '1/2 کا کیا مطلب ہے؟',
        '1/2 څه معنا لري؟'), [
      t('One of two equal parts', 'دو برابر حصوں میں سے ایک',
          'د دوو مساوي برخو یوه'),
      t('Two wholes', 'دو مکمل', 'دوه بشپړ'),
      t('Half of ten', 'دس کا آدھا', 'د لسو نیمه'),
      t('Nothing', 'کچھ نہیں', 'هیڅ'),
    ], 0);
    addQ(1001, 100, t('Half of a roti is written as…',
        'آدھی روٹی کیسے لکھی جاتی ہے…', 'نیمه ډوډۍ څنګه لیکل کیږي…'), [
      t('1/2', '1/2', '1/2'),
      t('2/1', '2/1', '2/1'),
      t('1/4', '1/4', '1/4'),
      t('2/2', '2/2', '2/2'),
    ], 0);
    addQ(1002, 100, t('A whole is split into 4 equal parts. One part is…',
        'کل کو 4 برابر حصوں میں بانٹا گیا۔ ایک حصہ ہے…',
        'بشپړ په 4 مساوي برخو وویشل شو. یوه برخه ده…'), [
      t('1/4', '1/4', '1/4'),
      t('4/1', '4/1', '4/1'),
      t('1/2', '1/2', '1/2'),
      t('4/4', '4/4', '4/4'),
    ], 0);
    addQ(1003, 100, t('4/4 is the same as…', '4/4 کس کے برابر ہے…',
        '4/4 د څه سره برابر دی…'), [
      t('One whole', 'ایک مکمل', 'یو بشپړ'),
      t('Half', 'آدھا', 'نیمه'),
      t('A quarter', 'چوتھائی', 'څلورمه'),
      t('Zero', 'صفر', 'صفر'),
    ], 0);

    // Lesson 101 — 3 questions.
    addQ(1010, 101, t('Which is bigger: 3/4 or 1/4?',
        'کون سی بڑی ہے: 3/4 یا 1/4؟', 'کوم لوی دی: 3/4 یا 1/4؟'), [
      t('3/4', '3/4', '3/4'),
      t('1/4', '1/4', '1/4'),
      t('They are equal', 'برابر ہیں', 'برابر دي'),
      t('Cannot tell', 'نہیں بتا سکتے', 'نشو ویلی'),
    ], 0);
    addQ(1011, 101, t('Which is smaller: 2/5 or 4/5?',
        'کون سی چھوٹی ہے: 2/5 یا 4/5؟', 'کوم کوچنی دی: 2/5 یا 4/5؟'), [
      t('2/5', '2/5', '2/5'),
      t('4/5', '4/5', '4/5'),
      t('Equal', 'برابر', 'برابر'),
      t('Neither', 'کوئی نہیں', 'هیڅ یو'),
    ], 0);
    addQ(1012, 101, t('5/8 and 7/8 — which is larger?',
        '5/8 اور 7/8 — کون سی بڑی؟', '5/8 او 7/8 — کوم لوی دی؟'), [
      t('7/8', '7/8', '7/8'),
      t('5/8', '5/8', '5/8'),
      t('Equal', 'برابر', 'برابر'),
      t('8/8', '8/8', '8/8'),
    ], 0);

    // Lesson 102 — 4 questions.
    addQ(1020, 102, t('1/4 + 2/4 = ?', '1/4 + 2/4 = ؟', '1/4 + 2/4 = ؟'), [
      t('3/4', '3/4', '3/4'),
      t('3/8', '3/8', '3/8'),
      t('2/4', '2/4', '2/4'),
      t('1/4', '1/4', '1/4'),
    ], 0);
    addQ(1021, 102, t('1/5 + 3/5 = ?', '1/5 + 3/5 = ؟', '1/5 + 3/5 = ؟'), [
      t('4/5', '4/5', '4/5'),
      t('4/10', '4/10', '4/10'),
      t('3/5', '3/5', '3/5'),
      t('2/5', '2/5', '2/5'),
    ], 0);
    addQ(1022, 102, t('2/6 + 3/6 = ?', '2/6 + 3/6 = ؟', '2/6 + 3/6 = ؟'), [
      t('5/6', '5/6', '5/6'),
      t('5/12', '5/12', '5/12'),
      t('1/6', '1/6', '1/6'),
      t('6/6', '6/6', '6/6'),
    ], 0);
    addQ(1023, 102, t('When adding 1/4 + 2/4, the bottom number stays…',
        '1/4 + 2/4 جمع کرتے وقت نیچے کا عدد رہتا ہے…',
        'کله چې 1/4 + 2/4 جمع کوو، لاندې شمېره پاتې کیږي…'), [
      t('4', '4', '4'),
      t('8', '8', '8'),
      t('2', '2', '2'),
      t('16', '16', '16'),
    ], 0);

    final archive = Archive();
    void add(String name, Object json) {
      final bytes = utf8.encode(const JsonEncoder().convert(json));
      archive.addFile(ArchiveFile(name, bytes.length, bytes));
    }

    add('manifest.json', manifest);
    add('content/subjects.json', subjects);
    add('content/units.json', units);
    add('content/lessons.json', lessons);
    add('content/questions.json', questions);
    // audio/ and images/ are optional and omitted from the demo package.

    final zipped = ZipEncoder().encode(archive);
    if (zipped == null) {
      throw StateError('Failed to build demo package archive.');
    }
    return zipped;
  }
}
