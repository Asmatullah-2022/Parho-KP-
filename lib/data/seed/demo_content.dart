import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// Seeds DEMO Grade-5 content into the database on first launch.
///
/// IMPORTANT: This is original *demo* content for illustration only. It does
/// not reproduce any copyrighted textbook. Replace it with properly licensed
/// curriculum content later — the schema and this seeding entry point are the
/// only things that need to change.
const _seedVersionKey = 'seed_version';
const _seedVersion = '2';
const int demoGrade = 5;

/// Small trilingual string bundle.
class T {
  const T(this.en, this.ur, this.ps);
  final String en;
  final String ur;
  final String ps;
}

class _Q {
  const _Q(this.prompt, this.options, this.correct);
  final T prompt;
  // Options in each language, same length & order.
  final List<T> options;
  final int correct;
}

class _Lesson {
  const _Lesson({
    required this.title,
    required this.objective,
    required this.explanation,
    required this.example,
    required this.illustration,
    required this.questions,
  });
  final T title;
  final T objective;
  final T explanation;
  final T example;
  final String illustration;
  final List<_Q> questions;
}

class _Unit {
  const _Unit(this.title, this.lessons);
  final T title;
  final List<_Lesson> lessons;
}

class _Subject {
  const _Subject({
    required this.code,
    required this.name,
    required this.emoji,
    required this.units,
  });
  final String code;
  final T name;
  final String emoji;
  final List<_Unit> units;
}

Future<void> seedDemoContentIfNeeded(AppDatabase db) async {
  final version = await db.getSetting(_seedVersionKey);
  if (version == _seedVersion) return;

  await db.transaction(() async {
    // Clear any previously-seeded catalog (and its dependent rows) so a content
    // upgrade re-seeds cleanly instead of duplicating. Foreign-key cascades are
    // not relied upon, so delete child tables explicitly, deepest first.
    await db.delete(db.quizAnswers).go();
    await db.delete(db.quizAttempts).go();
    await db.delete(db.lessonProgress).go();
    await db.delete(db.favorites).go();
    await db.delete(db.downloads).go();
    await db.delete(db.questions).go();
    await db.delete(db.lessons).go();
    await db.delete(db.units).go();
    await db.delete(db.subjects).go();

    for (var s = 0; s < _catalog.length; s++) {
      final subject = _catalog[s];
      final subjectId = await db.into(db.subjects).insert(
            SubjectsCompanion.insert(
              code: subject.code,
              grade: demoGrade,
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
                  isDemo: const Value(true),
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
                    correctIndex: q.correct,
                    sortOrder: Value(qi),
                  ),
                );
          }
        }
      }
    }
  });

  await db.putSetting(_seedVersionKey, _seedVersion);
}

// ---------------------------------------------------------------------------
// DEMO CONTENT (Grade 5)
// ---------------------------------------------------------------------------

const _catalog = <_Subject>[
  // ------------------------------- URDU ------------------------------------
  _Subject(
    code: 'urdu',
    name: T('Urdu', 'اردو', 'اردو'),
    emoji: '📖',
    units: [
      _Unit(
        T('Nouns (Ism)', 'اسم', 'اسم (نوم)'),
        [
          _Lesson(
            title: T('What is a Noun', 'اسم کیا ہے', 'اسم څه شی دی'),
            objective: T(
              'Children can identify names of people, places and things.',
              'بچے افراد، جگہوں اور چیزوں کے نام پہچان سکیں۔',
              'ماشومان د خلکو، ځایونو او شیانو نومونه وپیژني.',
            ),
            explanation: T(
              'A noun (Ism) is a naming word — the name of a person, place, animal or thing, like Ahmad, Peshawar, cat, or book.',
              'اسم کسی شخص، جگہ، جانور یا چیز کے نام کو کہتے ہیں، جیسے احمد، پشاور، بلی، یا کتاب۔',
              'اسم د یو کس، ځای، حیوان یا شي نوم دی، لکه احمد، پېښور، پیشو، یا کتاب.',
            ),
            example: T(
              '"Ahmad reads a book in Peshawar." Here Ahmad, book and Peshawar are all nouns.',
              '"احمد پشاور میں کتاب پڑھتا ہے۔" یہاں احمد، کتاب اور پشاور سب اسم ہیں۔',
              '"احمد په پېښور کې کتاب لولي." دلته احمد، کتاب او پېښور ټول اسمونه دي.',
            ),
            illustration: '📖',
            questions: [
              _Q(
                T('Which word is a noun?', 'کون سا لفظ اسم ہے؟',
                    'کوم کلمه اسم ده؟'),
                [
                  T('Book', 'کتاب', 'کتاب'),
                  T('Run', 'دوڑنا', 'منډه'),
                  T('Fast', 'تیز', 'ګړندی'),
                  T('Beautiful', 'خوبصورت', 'ښکلی'),
                ],
                0,
              ),
              _Q(
                T('Peshawar is the name of a…', 'پشاور کس چیز کا نام ہے؟',
                    'پېښور د څه نوم دی؟'),
                [
                  T('Place', 'جگہ', 'ځای'),
                  T('Animal', 'جانور', 'حیوان'),
                  T('Colour', 'رنگ', 'رنګ'),
                  T('Action', 'کام', 'کار'),
                ],
                0,
              ),
              _Q(
                T('Choose the noun.', 'اسم چنیں۔', 'اسم وټاکئ.'),
                [
                  T('Cat', 'بلی', 'پیشو'),
                  T('Jump', 'کودنا', 'ټوپ'),
                  T('Green', 'سبز', 'شین'),
                  T('Slowly', 'آہستہ', 'ورو'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
      _Unit(
        T('Verbs (Fail)', 'فعل', 'فعل'),
        [
          _Lesson(
            title: T('What is a Verb', 'فعل کیا ہے', 'فعل څه شی دی'),
            objective: T(
              'Children can recognise action words.',
              'بچے کام ظاہر کرنے والے الفاظ پہچان سکیں۔',
              'ماشومان د کار کلمې وپیژني.',
            ),
            explanation: T(
              'A verb (Fail) is an action word — it tells what someone does, like read, write, run or eat.',
              'فعل وہ لفظ ہے جو کام ظاہر کرے، جیسے پڑھنا، لکھنا، دوڑنا یا کھانا۔',
              'فعل هغه کلمه ده چې کار ښیي، لکه لوستل، لیکل، منډه یا خوړل.',
            ),
            example: T(
              '"Sana writes a letter." The word "writes" is the verb.',
              '"ثنا خط لکھتی ہے۔" لفظ "لکھتی" فعل ہے۔',
              '"ثنا لیک لیکي." کلمه "لیکي" فعل دی.',
            ),
            illustration: '✍️',
            questions: [
              _Q(
                T('Which word is a verb?', 'کون سا لفظ فعل ہے؟',
                    'کومه کلمه فعل ده؟'),
                [
                  T('Eat', 'کھانا', 'خوړل'),
                  T('Table', 'میز', 'مېز'),
                  T('Red', 'سرخ', 'سور'),
                  T('School', 'اسکول', 'ښوونځی'),
                ],
                0,
              ),
              _Q(
                T('"Run" is a…', '"دوڑنا" ایک…', '"منډه" یو…'),
                [
                  T('Verb', 'فعل', 'فعل'),
                  T('Noun', 'اسم', 'اسم'),
                  T('Colour', 'رنگ', 'رنګ'),
                  T('Number', 'عدد', 'شمېره'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
      _Unit(
        T('Reading', 'مطالعہ', 'لوستل'),
        [
          _Lesson(
            title: T('Reading a Short Story', 'مختصر کہانی پڑھنا',
                'لنډه کیسه لوستل'),
            objective: T(
              'Children can read a short passage and understand it.',
              'بچے مختصر عبارت پڑھ کر سمجھ سکیں۔',
              'ماشومان لنډه پاراګراف ولولي او پوه شي.',
            ),
            explanation: T(
              'Reading means understanding words together as sentences. Read slowly and think about the meaning.',
              'مطالعہ کا مطلب ہے الفاظ کو جملوں کی صورت میں سمجھنا۔ آہستہ پڑھیں اور معنی پر غور کریں۔',
              'لوستل یعنې کلمې د جملو په بڼه پوهېدل. ورو ولولئ او په معنا فکر وکړئ.',
            ),
            example: T(
              '"The sun rises in the east." What rises? The sun.',
              '"سورج مشرق سے نکلتا ہے۔" کیا نکلتا ہے؟ سورج۔',
              '"لمر له ختیځ څخه راخېژي." څه راخېژي؟ لمر.',
            ),
            illustration: '🌅',
            questions: [
              _Q(
                T('In the sentence, what rises in the east?',
                    'جملے میں مشرق سے کیا نکلتا ہے؟',
                    'په جمله کې له ختیځ څخه څه راخېژي؟'),
                [
                  T('The sun', 'سورج', 'لمر'),
                  T('The moon', 'چاند', 'سپوږمۍ'),
                  T('A bird', 'پرندہ', 'مرغه'),
                  T('The rain', 'بارش', 'باران'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
    ],
  ),

  // ------------------------------ ENGLISH ----------------------------------
  _Subject(
    code: 'english',
    name: T('English', 'انگریزی', 'انګلیسي'),
    emoji: '🔤',
    units: [
      _Unit(
        T('Nouns', 'اسم (Nouns)', 'نومونه (Nouns)'),
        [
          _Lesson(
            title: T('Naming Words', 'نام والے الفاظ', 'د نوم کلمې'),
            objective: T(
              'Children can identify nouns in English sentences.',
              'بچے انگریزی جملوں میں اسم پہچان سکیں۔',
              'ماشومان په انګلیسي جملو کې نومونه وپیژني.',
            ),
            explanation: T(
              'A noun names a person, place, animal or thing: boy, city, dog, pen.',
              'اسم کسی شخص، جگہ، جانور یا چیز کا نام ہے: boy, city, dog, pen۔',
              'نوم د یو کس، ځای، حیوان یا شي نوم دی: boy, city, dog, pen.',
            ),
            example: T(
              'In "The dog runs", the word "dog" is a noun.',
              '"The dog runs" میں لفظ "dog" اسم ہے۔',
              'په "The dog runs" کې کلمه "dog" نوم دی.',
            ),
            illustration: '🐕',
            questions: [
              _Q(
                T('Which is a noun?', 'کون سا اسم ہے؟', 'کوم یو نوم دی؟'),
                [
                  T('Pen', 'قلم', 'قلم'),
                  T('Jump', 'کودنا', 'ټوپ'),
                  T('Happy', 'خوش', 'خوښ'),
                  T('Quickly', 'جلدی', 'ژر'),
                ],
                0,
              ),
              _Q(
                T('"City" is a…', '"City" ایک…', '"City" یو…'),
                [
                  T('Noun', 'اسم', 'نوم'),
                  T('Verb', 'فعل', 'فعل'),
                  T('Colour', 'رنگ', 'رنګ'),
                  T('Number', 'عدد', 'شمېره'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
      _Unit(
        T('Verbs', 'فعل (Verbs)', 'فعلونه (Verbs)'),
        [
          _Lesson(
            title: T('Action Words', 'کام والے الفاظ', 'د کار کلمې'),
            objective: T(
              'Children can identify verbs in English sentences.',
              'بچے انگریزی جملوں میں فعل پہچان سکیں۔',
              'ماشومان په انګلیسي جملو کې فعلونه وپیژني.',
            ),
            explanation: T(
              'A verb shows an action: run, jump, read, write.',
              'فعل کام ظاہر کرتا ہے: run, jump, read, write۔',
              'فعل کار ښیي: run, jump, read, write.',
            ),
            example: T(
              'In "She reads a book", "reads" is the verb.',
              '"She reads a book" میں "reads" فعل ہے۔',
              'په "She reads a book" کې "reads" فعل دی.',
            ),
            illustration: '🏃',
            questions: [
              _Q(
                T('Which is a verb?', 'کون سا فعل ہے؟', 'کوم یو فعل دی؟'),
                [
                  T('Write', 'لکھنا', 'لیکل'),
                  T('Chair', 'کرسی', 'څوکۍ'),
                  T('Blue', 'نیلا', 'شین'),
                  T('Slow', 'سست', 'ورو'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
      _Unit(
        T('Reading', 'مطالعہ (Reading)', 'لوستل (Reading)'),
        [
          _Lesson(
            title: T('Reading Sentences', 'جملے پڑھنا', 'جملې لوستل'),
            objective: T(
              'Children can read and understand simple English sentences.',
              'بچے آسان انگریزی جملے پڑھ اور سمجھ سکیں۔',
              'ماشومان ساده انګلیسي جملې ولولي او پوه شي.',
            ),
            explanation: T(
              'Read each word, then understand the whole sentence together.',
              'ہر لفظ پڑھیں، پھر پورا جملہ مل کر سمجھیں۔',
              'هره کلمه ولولئ، بیا ټوله جمله سره پوه شئ.',
            ),
            example: T(
              '"The cat is black." What colour is the cat? Black.',
              '"The cat is black." بلی کس رنگ کی ہے؟ کالی۔',
              '"The cat is black." پیشو کوم رنګ ده؟ تور.',
            ),
            illustration: '🐈',
            questions: [
              _Q(
                T('What colour is the cat?', 'بلی کس رنگ کی ہے؟',
                    'پیشو کوم رنګ ده؟'),
                [
                  T('Black', 'کالی', 'تور'),
                  T('White', 'سفید', 'سپین'),
                  T('Green', 'سبز', 'شین'),
                  T('Red', 'سرخ', 'سور'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
    ],
  ),

  // ---------------------------- MATHEMATICS --------------------------------
  _Subject(
    code: 'math',
    name: T('Mathematics', 'ریاضی', 'ریاضي'),
    emoji: '➕',
    units: [
      _Unit(
        T('Numbers', 'اعداد', 'شمېرې'),
        [
          _Lesson(
            title: T('Place Value', 'عددی قدر', 'د ځای ارزښت'),
            objective: T(
              'Children can read the place value of digits.',
              'بچے ہندسوں کی عددی قدر پڑھ سکیں۔',
              'ماشومان د عددونو د ځای ارزښت ولولي.',
            ),
            explanation: T(
              'In 452, the 4 means 4 hundreds, the 5 means 5 tens, and the 2 means 2 ones.',
              '452 میں 4 کا مطلب 4 سو، 5 کا مطلب 5 دہائیاں، اور 2 کا مطلب 2 اکائیاں ہیں۔',
              'په ۴۵۲ کې ۴ د څلور سوه، ۵ د پنځه لسیزو، او ۲ د دوه یوایونو معنا لري.',
            ),
            example: T(
              'The digit 7 in 73 stands for 7 tens = 70.',
              '73 میں ہندسہ 7 کا مطلب 7 دہائیاں = 70 ہے۔',
              'په ۷۳ کې عدد ۷ د اوه لسیزو = ۷۰ معنا لري.',
            ),
            illustration: '🔢',
            questions: [
              _Q(
                T('In 452, what does 5 mean?', '452 میں 5 کا کیا مطلب ہے؟',
                    'په ۴۵۲ کې ۵ څه معنا لري؟'),
                [
                  T('5 tens', '5 دہائیاں', '۵ لسیزې'),
                  T('5 ones', '5 اکائیاں', '۵ یوایونه'),
                  T('5 hundreds', '5 سو', '۵ سوه'),
                  T('5 thousands', '5 ہزار', '۵ زره'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
      _Unit(
        T('Fractions', 'کسر', 'کسر'),
        [
          _Lesson(
            title: T('Understanding Fractions', 'کسر کو سمجھنا',
                'د کسر پوهه'),
            objective: T(
              'Children can understand fractions with simple examples.',
              'بچے کسر کو آسان مثالوں سے سمجھ سکیں۔',
              'ماشومان کسر په ساده مثالونو سره پوه شي.',
            ),
            explanation: T(
              'A fraction shows a part of a whole. If we cut one bread into 4 equal parts, each part is one-fourth (1/4).',
              'کسر کسی مکمل چیز کے حصے کو ظاہر کرتا ہے۔ اگر ایک روٹی کو 4 برابر حصوں میں کاٹا جائے تو ہر حصہ ایک چوتھائی (1/4) ہے۔',
              'کسر د یو بشپړ شي یوه برخه ښیي. که یوه ډوډۍ په ۴ برابرو برخو ووېشل شي، هره برخه یو څلورمه (۱/۴) ده.',
            ),
            example: T(
              'One bread is cut into 4 equal parts. One part = 1/4 of the bread.',
              'ایک روٹی کو 4 برابر حصوں میں کاٹا گیا۔ ایک حصہ = روٹی کا 1/4۔',
              'یوه ډوډۍ په ۴ برابرو برخو ووېشل شوه. یوه برخه = د ډوډۍ ۱/۴.',
            ),
            illustration: '🍕',
            questions: [
              _Q(
                T(
                    'A bread is cut into 4 equal parts. One part is which fraction?',
                    'ایک روٹی کے 4 برابر حصے کیے گئے۔ ایک حصہ کون سا fraction ہے؟',
                    'یوه ډوډۍ په ۴ برابرو برخو ووېشل شوه. یوه برخه کوم کسر دی؟'),
                [
                  T('1/2', '1/2', '۱/۲'),
                  T('1/3', '1/3', '۱/۳'),
                  T('1/4', '1/4', '۱/۴'),
                  T('4/4', '4/4', '۴/۴'),
                ],
                2,
              ),
              _Q(
                T('Which fraction is the biggest?',
                    'کون سا کسر سب سے بڑا ہے؟', 'کوم کسر تر ټولو لوی دی؟'),
                [
                  T('1/2', '1/2', '۱/۲'),
                  T('1/4', '1/4', '۱/۴'),
                  T('1/8', '1/8', '۱/۸'),
                  T('1/10', '1/10', '۱/۱۰'),
                ],
                0,
              ),
              _Q(
                T('2/4 is equal to…', '2/4 برابر ہے…', '۲/۴ برابر دی…'),
                [
                  T('1/2', '1/2', '۱/۲'),
                  T('1/3', '1/3', '۱/۳'),
                  T('1/4', '1/4', '۱/۴'),
                  T('3/4', '3/4', '۳/۴'),
                ],
                0,
              ),
              _Q(
                T('In the fraction 3/5, which is the denominator?',
                    '3/5 میں نیچے کا عدد (denominator) کون سا ہے؟',
                    'په ۳/۵ کې ښکتنۍ شمېره کومه ده؟'),
                [
                  T('5', '5', '۵'),
                  T('3', '3', '۳'),
                  T('8', '8', '۸'),
                  T('2', '2', '۲'),
                ],
                0,
              ),
              _Q(
                T('A pizza is cut into 8 equal slices. You eat 3. What fraction did you eat?',
                    'ایک پیزا 8 برابر حصوں میں کاٹا گیا۔ آپ نے 3 کھائے۔ آپ نے کون سا حصہ کھایا؟',
                    'یو پیزا په ۸ برابرو ټوټو ووېشل شو. تاسو ۳ وخوړل. کومه برخه مو وخوړه؟'),
                [
                  T('3/8', '3/8', '۳/۸'),
                  T('8/3', '8/3', '۸/۳'),
                  T('3/5', '3/5', '۳/۵'),
                  T('1/8', '1/8', '۱/۸'),
                ],
                0,
              ),
              _Q(
                T('Which fraction means one whole?',
                    'کون سا کسر ایک مکمل (پورا) کو ظاہر کرتا ہے؟',
                    'کوم کسر یو بشپړ ښیي؟'),
                [
                  T('4/4', '4/4', '۴/۴'),
                  T('1/4', '1/4', '۱/۴'),
                  T('3/4', '3/4', '۳/۴'),
                  T('1/2', '1/2', '۱/۲'),
                ],
                0,
              ),
              _Q(
                T('Half of a chocolate bar is the same as…',
                    'چاکلیٹ کا آدھا حصہ برابر ہے…',
                    'د چاکلیټ نیمه برخه برابره ده…'),
                [
                  T('1/2', '1/2', '۱/۲'),
                  T('1/3', '1/3', '۱/۳'),
                  T('2/3', '2/3', '۲/۳'),
                  T('1/5', '1/5', '۱/۵'),
                ],
                0,
              ),
              _Q(
                T('Which of these is a fraction?',
                    'ان میں سے کون سا کسر ہے؟',
                    'له دې څخه کوم یو کسر دی؟'),
                [
                  T('3/4', '3/4', '۳/۴'),
                  T('7', '7', '۷'),
                  T('12', '12', '۱۲'),
                  T('20', '20', '۲۰'),
                ],
                0,
              ),
            ],
          ),
          _Lesson(
            title: T('Comparing Fractions', 'کسر کا موازنہ',
                'د کسر پرتله'),
            objective: T(
              'Children can compare simple fractions.',
              'بچے آسان کسر کا موازنہ کر سکیں۔',
              'ماشومان ساده کسرونه پرتله کړي.',
            ),
            explanation: T(
              'When the top number is the same, the fraction with the smaller bottom number is bigger.',
              'جب اوپر کا عدد برابر ہو تو جس کسر کا نیچے کا عدد چھوٹا ہو وہ بڑا ہوتا ہے۔',
              'کله چې پورتنۍ شمېره یو شان وي، هغه کسر چې ښکتنۍ شمېره یې کوچنۍ وي لوی وي.',
            ),
            example: T(
              '1/2 is bigger than 1/4 because halves are bigger than quarters.',
              '1/2، 1/4 سے بڑا ہے کیونکہ آدھے چوتھائیوں سے بڑے ہوتے ہیں۔',
              '۱/۲ له ۱/۴ لوی دی ځکه نیمایي له څلورمو لوی وي.',
            ),
            illustration: '⚖️',
            questions: [
              _Q(
                T('Which is bigger: 1/3 or 1/6?',
                    'کون سا بڑا ہے: 1/3 یا 1/6؟',
                    'کوم لوی دی: ۱/۳ یا ۱/۶؟'),
                [
                  T('1/3', '1/3', '۱/۳'),
                  T('1/6', '1/6', '۱/۶'),
                  T('Equal', 'برابر', 'برابر'),
                  T('None', 'کوئی نہیں', 'هیڅ یو'),
                ],
                0,
              ),
              _Q(
                T('Which is smaller: 1/2 or 1/5?',
                    'کون سا چھوٹا ہے: 1/2 یا 1/5؟',
                    'کوم کوچنی دی: ۱/۲ یا ۱/۵؟'),
                [
                  T('1/5', '1/5', '۱/۵'),
                  T('1/2', '1/2', '۱/۲'),
                  T('Equal', 'برابر', 'برابر'),
                  T('None', 'کوئی نہیں', 'هیڅ یو'),
                ],
                0,
              ),
              _Q(
                T('Put in order, biggest first: 1/2, 1/4, 1/8. Which is biggest?',
                    'ترتیب دیں، سب سے بڑا پہلے: 1/2، 1/4، 1/8۔ سب سے بڑا کون سا ہے؟',
                    'ترتیب کړئ، تر ټولو لوی لومړی: ۱/۲، ۱/۴، ۱/۸. تر ټولو لوی کوم دی؟'),
                [
                  T('1/2', '1/2', '۱/۲'),
                  T('1/4', '1/4', '۱/۴'),
                  T('1/8', '1/8', '۱/۸'),
                  T('They are equal', 'سب برابر ہیں', 'ټول برابر دي'),
                ],
                0,
              ),
              _Q(
                T('Which two fractions are equal?',
                    'کون سے دو کسر برابر ہیں؟',
                    'کوم دوه کسرونه برابر دي؟'),
                [
                  T('1/2 and 2/4', '1/2 اور 2/4', '۱/۲ او ۲/۴'),
                  T('1/2 and 1/3', '1/2 اور 1/3', '۱/۲ او ۱/۳'),
                  T('1/4 and 1/2', '1/4 اور 1/2', '۱/۴ او ۱/۲'),
                  T('1/3 and 1/4', '1/3 اور 1/4', '۱/۳ او ۱/۴'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
      _Unit(
        T('Multiplication', 'ضرب', 'ضرب'),
        [
          _Lesson(
            title: T('Multiplying Numbers', 'اعداد کی ضرب',
                'د شمېرو ضرب'),
            objective: T(
              'Children can multiply small numbers.',
              'بچے چھوٹے اعداد کی ضرب کر سکیں۔',
              'ماشومان کوچنۍ شمېرې ضرب کړي.',
            ),
            explanation: T(
              'Multiplication is repeated addition. 3 × 4 means 4 added three times: 4 + 4 + 4 = 12.',
              'ضرب بار بار جمع کرنا ہے۔ 3 × 4 کا مطلب 4 کو تین بار جمع کرنا: 4 + 4 + 4 = 12۔',
              'ضرب تکرارې جمع ده. ۳ × ۴ یعنې ۴ درې ځله جمع: ۴ + ۴ + ۴ = ۱۲.',
            ),
            example: T(
              '5 × 2 = 10 (two fives).',
              '5 × 2 = 10 (دو پانچ)۔',
              '۵ × ۲ = ۱۰ (دوه پنځه).',
            ),
            illustration: '✖️',
            questions: [
              _Q(
                T('What is 3 × 4?', '3 × 4 کتنا ہے؟', '۳ × ۴ څومره دی؟'),
                [
                  T('12', '12', '۱۲'),
                  T('7', '7', '۷'),
                  T('9', '9', '۹'),
                  T('16', '16', '۱۶'),
                ],
                0,
              ),
              _Q(
                T('What is 6 × 2?', '6 × 2 کتنا ہے؟', '۶ × ۲ څومره دی؟'),
                [
                  T('12', '12', '۱۲'),
                  T('8', '8', '۸'),
                  T('10', '10', '۱۰'),
                  T('14', '14', '۱۴'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
      _Unit(
        T('Division', 'تقسیم', 'وېش'),
        [
          _Lesson(
            title: T('Dividing Numbers', 'اعداد کی تقسیم',
                'د شمېرو وېش'),
            objective: T(
              'Children can divide small numbers equally.',
              'بچے چھوٹے اعداد کو برابر تقسیم کر سکیں۔',
              'ماشومان کوچنۍ شمېرې برابرې ووېشي.',
            ),
            explanation: T(
              'Division shares a number into equal groups. 12 ÷ 3 = 4 means 12 shared into 3 groups makes 4 each.',
              'تقسیم کسی عدد کو برابر گروہوں میں بانٹنا ہے۔ 12 ÷ 3 = 4 یعنی 12 کو 3 گروہوں میں بانٹنے سے ہر گروہ میں 4۔',
              'وېش یوه شمېره په برابرو ډلو وېشي. ۱۲ ÷ ۳ = ۴ یعنې ۱۲ په ۳ ډلو کې هره ۴.',
            ),
            example: T(
              '10 ÷ 2 = 5 (ten shared into two groups).',
              '10 ÷ 2 = 5 (دس کو دو گروہوں میں)۔',
              '۱۰ ÷ ۲ = ۵ (لس په دوه ډلو کې).',
            ),
            illustration: '➗',
            questions: [
              _Q(
                T('What is 12 ÷ 3?', '12 ÷ 3 کتنا ہے؟', '۱۲ ÷ ۳ څومره دی؟'),
                [
                  T('4', '4', '۴'),
                  T('3', '3', '۳'),
                  T('6', '6', '۶'),
                  T('9', '9', '۹'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
    ],
  ),

  // -------------------------- GENERAL SCIENCE ------------------------------
  _Subject(
    code: 'science',
    name: T('General Science', 'جنرل سائنس', 'عمومي ساینس'),
    emoji: '🔬',
    units: [
      _Unit(
        T('Plants', 'پودے', 'بوټي'),
        [
          _Lesson(
            title: T('Parts of a Plant', 'پودے کے حصے', 'د بوټي برخې'),
            objective: T(
              'Children can name the main parts of a plant.',
              'بچے پودے کے بنیادی حصوں کے نام بتا سکیں۔',
              'ماشومان د بوټي اصلي برخې ونوموي.',
            ),
            explanation: T(
              'A plant has roots, a stem, leaves and flowers. Roots take water from the soil; leaves make food using sunlight.',
              'پودے کی جڑیں، تنا، پتے اور پھول ہوتے ہیں۔ جڑیں مٹی سے پانی لیتی ہیں؛ پتے سورج کی روشنی سے خوراک بناتے ہیں۔',
              'بوټی ولې، ډډ، پاڼې او ګلونه لري. ولې له خاورې اوبه اخلي؛ پاڼې د لمر رڼا سره خواړه جوړوي.',
            ),
            example: T(
              'The roots of a mango tree hold it in the ground and drink water.',
              'آم کے درخت کی جڑیں اسے زمین میں تھامتی ہیں اور پانی پیتی ہیں۔',
              'د آم د ونې ولې هغه په ځمکه کې ټینګوي او اوبه څښي.',
            ),
            illustration: '🌱',
            questions: [
              _Q(
                T('Which part takes water from the soil?',
                    'کون سا حصہ مٹی سے پانی لیتا ہے؟',
                    'کومه برخه له خاورې اوبه اخلي؟'),
                [
                  T('Roots', 'جڑیں', 'ولې'),
                  T('Flowers', 'پھول', 'ګلونه'),
                  T('Leaves', 'پتے', 'پاڼې'),
                  T('Stem', 'تنا', 'ډډ'),
                ],
                0,
              ),
              _Q(
                T('Which part makes food using sunlight?',
                    'کون سا حصہ سورج کی روشنی سے خوراک بناتا ہے؟',
                    'کومه برخه د لمر رڼا سره خواړه جوړوي؟'),
                [
                  T('Leaves', 'پتے', 'پاڼې'),
                  T('Roots', 'جڑیں', 'ولې'),
                  T('Seed', 'بیج', 'تخم'),
                  T('Stem', 'تنا', 'ډډ'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
      _Unit(
        T('Water', 'پانی', 'اوبه'),
        [
          _Lesson(
            title: T('States of Water', 'پانی کی حالتیں',
                'د اوبو حالتونه'),
            objective: T(
              'Children can name the three states of water.',
              'بچے پانی کی تین حالتیں بتا سکیں۔',
              'ماشومان د اوبو درې حالتونه ونوموي.',
            ),
            explanation: T(
              'Water can be solid (ice), liquid (water) or gas (steam). Heat changes water from one state to another.',
              'پانی ٹھوس (برف)، مائع (پانی) یا گیس (بھاپ) ہو سکتا ہے۔ حرارت پانی کی حالت بدلتی ہے۔',
              'اوبه کلک (کنګل)، مایع (اوبه) یا ګاز (بړاس) کیدی شي. تودوخه د اوبو حالت بدلوي.',
            ),
            example: T(
              'When water freezes it becomes ice; when it boils it becomes steam.',
              'پانی جم جائے تو برف بنتا ہے؛ ابلے تو بھاپ بنتا ہے۔',
              'کله چې اوبه کنګل شي کنګل جوړیږي؛ کله چې اېشیږي بړاس جوړیږي.',
            ),
            illustration: '💧',
            questions: [
              _Q(
                T('Ice is the … state of water.',
                    'برف پانی کی … حالت ہے۔', 'کنګل د اوبو د … حالت دی.'),
                [
                  T('Solid', 'ٹھوس', 'کلک'),
                  T('Liquid', 'مائع', 'مایع'),
                  T('Gas', 'گیس', 'ګاز'),
                  T('None', 'کوئی نہیں', 'هیڅ'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
      _Unit(
        T('Living Things', 'جاندار', 'ژوندي شیان'),
        [
          _Lesson(
            title: T('Living and Non-living', 'جاندار اور بے جان',
                'ژوندي او بې ژوند'),
            objective: T(
              'Children can tell living things from non-living things.',
              'بچے جاندار اور بے جان میں فرق بتا سکیں۔',
              'ماشومان د ژوندیو او بې ژوند توپیر وکړي.',
            ),
            explanation: T(
              'Living things grow, eat and breathe, like people, animals and plants. Non-living things do not, like stones and chairs.',
              'جاندار بڑھتے، کھاتے اور سانس لیتے ہیں، جیسے انسان، جانور اور پودے۔ بے جان ایسا نہیں کرتے، جیسے پتھر اور کرسی۔',
              'ژوندي شیان لویږي، خوري او ساه اخلي، لکه انسانان، حیوانات او بوټي. بې ژوند شیان داسې نه کوي، لکه تیږه او څوکۍ.',
            ),
            example: T(
              'A dog is living; a rock is non-living.',
              'کتا جاندار ہے؛ پتھر بے جان ہے۔',
              'سپی ژوندی دی؛ تیږه بې ژوند ده.',
            ),
            illustration: '🐢',
            questions: [
              _Q(
                T('Which one is a living thing?',
                    'کون سا جاندار ہے؟', 'کوم یو ژوندی شی دی؟'),
                [
                  T('Tree', 'درخت', 'ونه'),
                  T('Stone', 'پتھر', 'تیږه'),
                  T('Chair', 'کرسی', 'څوکۍ'),
                  T('Pen', 'قلم', 'قلم'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
    ],
  ),

  // ----------------------------- ISLAMIAT ----------------------------------
  _Subject(
    code: 'islamiat',
    name: T('Islamiat', 'اسلامیات', 'اسلامیات'),
    emoji: '☪️',
    units: [
      _Unit(
        T('Basics of Islam', 'اسلام کی بنیادی باتیں',
            'د اسلام بنسټیز خبرې'),
        [
          _Lesson(
            title: T('Good Manners', 'اچھے اخلاق', 'ښه اخلاق'),
            objective: T(
              'Children can learn good manners like truthfulness and kindness.',
              'بچے سچائی اور نرمی جیسے اچھے اخلاق سیکھ سکیں۔',
              'ماشومان د رښتینولۍ او مهربانۍ ښه اخلاق زده کړي.',
            ),
            explanation: T(
              'Islam teaches us to be truthful, kind and respectful to parents, teachers and everyone.',
              'اسلام ہمیں سچ بولنے، نرمی کرنے اور والدین، اساتذہ اور سب کا احترام کرنے کی تعلیم دیتا ہے۔',
              'اسلام موږ ته ښیي چې رښتیا ووایو، مهرباني وکړو او د مور و پلار، ښوونکو او ټولو درناوی وکړو.',
            ),
            example: T(
              'Saying "salam", helping others and speaking the truth are good manners.',
              '"سلام" کہنا، دوسروں کی مدد کرنا اور سچ بولنا اچھے اخلاق ہیں۔',
              '"سلام" ویل، د نورو مرسته کول او رښتیا ویل ښه اخلاق دي.',
            ),
            illustration: '🤝',
            questions: [
              _Q(
                T('Which is a good manner?', 'کون سا اچھا اخلاق ہے؟',
                    'کوم یو ښه اخلاق دی؟'),
                [
                  T('Telling the truth', 'سچ بولنا', 'رښتیا ویل'),
                  T('Being unkind', 'بے رحمی', 'بې رحمي'),
                  T('Shouting', 'چیخنا', 'چیغې'),
                  T('Wasting food', 'کھانا ضائع کرنا', 'د خوراک ضایع کول'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
    ],
  ),

  // ------------------------- GENERAL KNOWLEDGE ------------------------------
  _Subject(
    code: 'gk',
    name: T('General Knowledge', 'جنرل نالج', 'عمومي پوهه'),
    emoji: '🌍',
    units: [
      _Unit(
        T('Pakistan', 'پاکستان', 'پاکستان'),
        [
          _Lesson(
            title: T('About Pakistan', 'پاکستان کے بارے میں',
                'د پاکستان په اړه'),
            objective: T(
              'Children can learn basic facts about Pakistan.',
              'بچے پاکستان کے بارے میں بنیادی معلومات سیکھ سکیں۔',
              'ماشومان د پاکستان بنسټیزې خبرې زده کړي.',
            ),
            explanation: T(
              'Pakistan is our country. Its capital is Islamabad and its national language is Urdu.',
              'پاکستان ہمارا ملک ہے۔ اس کا دارالحکومت اسلام آباد اور قومی زبان اردو ہے۔',
              'پاکستان زموږ هیواد دی. پلازمینه یې اسلام آباد او ملي ژبه یې اردو ده.',
            ),
            example: T(
              'The capital city of Pakistan is Islamabad.',
              'پاکستان کا دارالحکومت اسلام آباد ہے۔',
              'د پاکستان پلازمینه اسلام آباد دی.',
            ),
            illustration: '🇵🇰',
            questions: [
              _Q(
                T('What is the capital of Pakistan?',
                    'پاکستان کا دارالحکومت کیا ہے؟',
                    'د پاکستان پلازمینه څه ده؟'),
                [
                  T('Islamabad', 'اسلام آباد', 'اسلام آباد'),
                  T('Lahore', 'لاہور', 'لاهور'),
                  T('Karachi', 'کراچی', 'کراچي'),
                  T('Peshawar', 'پشاور', 'پېښور'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
      _Unit(
        T('Khyber Pakhtunkhwa', 'خیبر پختونخوا', 'خیبر پښتونخوا'),
        [
          _Lesson(
            title: T('About Khyber Pakhtunkhwa', 'خیبر پختونخوا کے بارے میں',
                'د خیبر پښتونخوا په اړه'),
            objective: T(
              'Children can learn basic facts about their province.',
              'بچے اپنے صوبے کے بارے میں بنیادی معلومات سیکھ سکیں۔',
              'ماشومان د خپلې ولایت بنسټیزې خبرې زده کړي.',
            ),
            explanation: T(
              'Khyber Pakhtunkhwa is a province of Pakistan. Its capital is Peshawar and many people speak Pashto.',
              'خیبر پختونخوا پاکستان کا ایک صوبہ ہے۔ اس کا دارالحکومت پشاور ہے اور بہت سے لوگ پښتو بولتے ہیں۔',
              'خیبر پښتونخوا د پاکستان یو ولایت دی. پلازمینه یې پېښور ده او ډیر خلک پښتو وایي.',
            ),
            example: T(
              'The capital of Khyber Pakhtunkhwa is Peshawar.',
              'خیبر پختونخوا کا دارالحکومت پشاور ہے۔',
              'د خیبر پښتونخوا پلازمینه پېښور ده.',
            ),
            illustration: '🏔️',
            questions: [
              _Q(
                T('What is the capital of Khyber Pakhtunkhwa?',
                    'خیبر پختونخوا کا دارالحکومت کیا ہے؟',
                    'د خیبر پښتونخوا پلازمینه څه ده؟'),
                [
                  T('Peshawar', 'پشاور', 'پېښور'),
                  T('Islamabad', 'اسلام آباد', 'اسلام آباد'),
                  T('Quetta', 'کوئٹہ', 'کوټه'),
                  T('Lahore', 'لاہور', 'لاهور'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
      _Unit(
        T('World Knowledge', 'دنیا کی معلومات', 'د نړۍ پوهه'),
        [
          _Lesson(
            title: T('Our World', 'ہماری دنیا', 'زموږ نړۍ'),
            objective: T(
              'Children can learn simple facts about the world.',
              'بچے دنیا کے بارے میں آسان معلومات سیکھ سکیں۔',
              'ماشومان د نړۍ په اړه ساده معلومات زده کړي.',
            ),
            explanation: T(
              'The Earth is our planet. It has land and water, and the Sun gives us light and heat.',
              'زمین ہمارا سیارہ ہے۔ اس پر خشکی اور پانی ہے، اور سورج ہمیں روشنی اور حرارت دیتا ہے۔',
              'ځمکه زموږ سیاره ده. وچه او اوبه لري، او لمر موږ ته رڼا او تودوخه راکوي.',
            ),
            example: T(
              'The Sun gives the Earth light during the day.',
              'سورج دن میں زمین کو روشنی دیتا ہے۔',
              'لمر د ورځې ځمکې ته رڼا ورکوي.',
            ),
            illustration: '🌏',
            questions: [
              _Q(
                T('What gives the Earth light and heat?',
                    'زمین کو روشنی اور حرارت کون دیتا ہے؟',
                    'ځمکې ته رڼا او تودوخه څوک ورکوي؟'),
                [
                  T('The Sun', 'سورج', 'لمر'),
                  T('The Moon', 'چاند', 'سپوږمۍ'),
                  T('A star', 'ستارہ', 'ستوری'),
                  T('A cloud', 'بادل', 'ورېځ'),
                ],
                0,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
