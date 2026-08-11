// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'Parho KP';

  @override
  String get appNameNative => 'پڑھو KP';

  @override
  String get appSubtitle => 'AI Learning Companion';

  @override
  String get appTagline => 'انٹرنیٹ کے بغیر بھی سیکھیں';

  @override
  String get actionNext => 'آگے';

  @override
  String get actionSkip => 'چھوڑیں';

  @override
  String get actionGetStarted => 'شروع کریں';

  @override
  String get actionBack => 'واپس';

  @override
  String get actionCancel => 'منسوخ';

  @override
  String get actionSave => 'محفوظ کریں';

  @override
  String get actionDone => 'مکمل';

  @override
  String get actionContinue => 'جاری رکھیں';

  @override
  String get actionYes => 'جی ہاں';

  @override
  String get actionClose => 'بند کریں';

  @override
  String get actionRetry => 'دوبارہ کوشش';

  @override
  String get actionOk => 'ٹھیک ہے';

  @override
  String get actionSend => 'بھیجیں';

  @override
  String get onboard1Title => 'اپنی تعلیم، اپنی رفتار سے';

  @override
  String get onboard1Body => 'اپنی جماعت کے اسباق آسان انداز میں سیکھیں۔';

  @override
  String get onboard2Title => 'انٹرنیٹ نہ ہو تب بھی سیکھیں';

  @override
  String get onboard2Body =>
      'اپنے اسباق پہلے محفوظ کریں اور بعد میں آف لائن پڑھیں۔';

  @override
  String get onboard3Title => 'اردو، پښتو اور English';

  @override
  String get onboard3Body => 'اپنی پسند کی زبان میں سیکھیں۔';

  @override
  String get onboard4Title => 'AI سے مشکل سبق آسان بنائیں';

  @override
  String get onboard4Body =>
      'AI learning assistant مشکل concepts کو آسان مثالوں سے سمجھانے میں مدد کرتا ہے۔';

  @override
  String get chooseLanguage => 'اپنی زبان منتخب کریں';

  @override
  String get chooseLanguageSubtitle =>
      'آپ اسے بعد میں ترتیبات سے تبدیل کر سکتے ہیں۔';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageUrdu => 'اردو';

  @override
  String get languagePashto => 'پښتو';

  @override
  String get languageEnglishNative => 'انگریزی';

  @override
  String get languageUrduNative => 'اردو';

  @override
  String get languagePashtoNative => 'پښتو';

  @override
  String get createProfile => 'اپنا پروفائل بنائیں';

  @override
  String get createProfileSubtitle => 'فون نمبر یا ای میل کی ضرورت نہیں۔';

  @override
  String get studentName => 'طالبِ علم کا نام';

  @override
  String get studentNameHint => 'اپنا نام لکھیں';

  @override
  String get nameRequired => 'براہِ کرم اپنا نام لکھیں';

  @override
  String get selectClass => 'جماعت';

  @override
  String grade(int number) {
    return 'جماعت $number';
  }

  @override
  String get languageLabel => 'زبان';

  @override
  String get startLearning => 'سیکھنا شروع کریں';

  @override
  String greeting(String name) {
    return 'السلام علیکم، $name 👋';
  }

  @override
  String gradeShort(int number) {
    return 'جماعت $number';
  }

  @override
  String get statusOnline => 'آن لائن';

  @override
  String get statusOffline => 'آف لائن موڈ';

  @override
  String get continueLearning => 'پڑھائی جاری رکھیں';

  @override
  String get continueLearningAction => 'پڑھائی جاری رکھیں';

  @override
  String get whatToStudyToday => 'آج کیا پڑھنا ہے؟';

  @override
  String get tileMyLessons => 'میرے اسباق';

  @override
  String get tileQuiz => 'Quiz';

  @override
  String get tileAiTutor => 'AI Tutor';

  @override
  String get tileOfflineLessons => 'آف لائن اسباق';

  @override
  String get tileMyProgress => 'میری Progress';

  @override
  String get tileAudioLearning => 'آڈیو لرننگ';

  @override
  String get navHome => 'ہوم';

  @override
  String get navLessons => 'اسباق';

  @override
  String get navQuiz => 'Quiz';

  @override
  String get navProgress => 'Progress';

  @override
  String get navProfile => 'پروفائل';

  @override
  String get mySubjects => 'میرے مضامین';

  @override
  String get overallProgress => 'مجموعی Progress';

  @override
  String unit(int number) {
    return 'یونٹ $number';
  }

  @override
  String get labelCompleted => 'مکمل';

  @override
  String get labelContinue => 'جاری رکھیں';

  @override
  String get labelStart => 'شروع کریں';

  @override
  String lesson(int number) {
    return 'سبق $number';
  }

  @override
  String get learningObjective => 'سیکھنے کا مقصد';

  @override
  String get sectionExplanation => 'وضاحت';

  @override
  String get sectionExample => 'مثال';

  @override
  String get sectionIllustration => 'تصویری وضاحت';

  @override
  String get listenToLesson => 'سبق سنیں';

  @override
  String get iDidntUnderstand => 'مجھے سمجھ نہیں آیا';

  @override
  String get helpExplainSimply => 'آسان الفاظ میں سمجھائیں';

  @override
  String get helpExplainWithExample => 'مثال کے ساتھ سمجھائیں';

  @override
  String get helpExplainInUrdu => 'اردو میں سمجھائیں';

  @override
  String get helpExplainInPashto => 'پښتو میں سمجھائیں';

  @override
  String get helpListen => 'سنائیں';

  @override
  String get practice => 'مشق';

  @override
  String get startQuiz => 'Quiz شروع کریں';

  @override
  String get demoContent => 'ڈیمو مواد';

  @override
  String get demoContentNote =>
      'یہ نمونہ ڈیمو مواد ہے، کسی سرکاری نصابی کتاب سے نہیں۔';

  @override
  String questionProgress(int current, int total) {
    return 'سوال $current از $total';
  }

  @override
  String get quizComplete => 'Quiz مکمل';

  @override
  String get labelCorrect => 'درست';

  @override
  String get labelWrong => 'غلط';

  @override
  String get practiceAgain => 'دوبارہ مشق کریں';

  @override
  String get nextLesson => 'اگلا سبق';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String get quizNoQuestions => 'اس سبق کے لیے ابھی کوئی سوال دستیاب نہیں۔';

  @override
  String get myProgressTitle => 'میری Progress';

  @override
  String get statusStrong => 'مضبوط';

  @override
  String get statusImproving => 'بہتر ہو رہا ہے';

  @override
  String get statusNeedsPractice => 'مزید مشق درکار';

  @override
  String get noProgressYet =>
      'اپنی Progress دیکھنے کے لیے کوئی سبق یا Quiz شروع کریں۔';

  @override
  String get aiTutorTitle => 'AI Tutor';

  @override
  String get aiTutorIntro => 'میں آپ کی پڑھائی میں مدد کرنے کے لیے یہاں ہوں۔';

  @override
  String get aiTutorDisclaimer =>
      'AI صرف پڑھائی میں مددگار ہے۔ یہ استاد کی جگہ نہیں لیتا، بلکہ مدد کرتا ہے۔';

  @override
  String get aiExplainLesson => 'سبق سمجھائیں';

  @override
  String get aiAskByVoice => 'سوال بولیں';

  @override
  String get aiAskByText => 'سوال لکھیں';

  @override
  String get aiListenAnswer => 'جواب سنیں';

  @override
  String get aiTypeQuestion => 'اپنا سوال لکھیں…';

  @override
  String get aiWantSmallQuestion => 'کیا آپ ایک چھوٹا سوال حل کرنا چاہتے ہیں؟';

  @override
  String get roleStudent => 'آپ';

  @override
  String get roleAi => 'AI Tutor';

  @override
  String get aiVoiceComingSoon =>
      'آواز سے سوال ابھی ڈیمو ہے۔ فی الحال اپنا سوال لکھیں۔';

  @override
  String get aiThinking => 'سوچ رہا ہوں…';

  @override
  String get offlineLessonsTitle => 'آف لائن اسباق';

  @override
  String get offlineWorksWithout =>
      'ڈاؤن لوڈ کیے گئے اسباق انٹرنیٹ کے بغیر کام کرتے ہیں — ڈیٹا کی ضرورت نہیں۔';

  @override
  String get labelDownloaded => 'ڈاؤن لوڈ ہو گیا';

  @override
  String get labelDownload => 'ڈاؤن لوڈ';

  @override
  String get labelDelete => 'حذف کریں';

  @override
  String get downloadOnWifi => 'صرف Wi-Fi پر ڈاؤن لوڈ';

  @override
  String get storageUsed => 'استعمال شدہ اسٹوریج';

  @override
  String get downloadStarted => 'آف لائن استعمال کے لیے محفوظ ہو گیا۔';

  @override
  String get downloadDeleted => 'آف لائن اسٹوریج سے ہٹا دیا گیا۔';

  @override
  String get profileTitle => 'پروفائل';

  @override
  String get profileLearningProgress => 'سیکھنے کی Progress';

  @override
  String get profileOfflineContent => 'آف لائن مواد';

  @override
  String get profileSettings => 'ترتیبات';

  @override
  String get profileTeacherDashboard => 'اساتذہ ڈیش بورڈ';

  @override
  String get classLabel => 'جماعت';

  @override
  String get settingsTitle => 'ترتیبات';

  @override
  String get settingsFontSize => 'متن کا حجم';

  @override
  String get settingsAudio => 'آڈیو';

  @override
  String get settingsAudioSubtitle => 'اسباق بلند آواز میں پڑھیں';

  @override
  String get settingsDownloadWifi => 'صرف Wi-Fi پر ڈاؤن لوڈ';

  @override
  String get settingsDarkMode => 'تھیم';

  @override
  String get settingsOfflineMode => 'آف لائن موڈ';

  @override
  String get settingsOfflineSubtitle => 'صرف ڈاؤن لوڈ شدہ مواد استعمال کریں';

  @override
  String get settingsStorage => 'اسٹوریج';

  @override
  String get settingsPrivacy => 'پرائیویسی';

  @override
  String get settingsAbout => 'ایپ کے بارے میں';

  @override
  String get fontSmall => 'چھوٹا';

  @override
  String get fontMedium => 'درمیانہ';

  @override
  String get fontLarge => 'بڑا';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'گہرا';

  @override
  String get themeSystem => 'سسٹم';

  @override
  String get aboutBody =>
      'پڑھو KP دور دراز علاقوں کے طلبہ کے لیے ایک ڈیمو لرننگ ساتھی ہے۔ یہ آف لائن کام کرتا ہے اور اردو، پښتو اور English کی سہولت دیتا ہے۔ یہ کوئی سرکاری ایپلی کیشن نہیں ہے۔';

  @override
  String get privacyBody =>
      'پڑھو KP آپ کا نام، جماعت اور Progress صرف اسی آلے میں محفوظ کرتا ہے۔ کسی اکاؤنٹ، فون نمبر یا ای میل کی ضرورت نہیں، اور آپ کا ڈیٹا شیئر نہیں کیا جاتا۔';

  @override
  String get teacherDashboardTitle => 'اساتذہ ڈیش بورڈ';

  @override
  String get teacherMyClasses => 'میری جماعتیں';

  @override
  String teacherStudents(int count) {
    return '$count طلبہ';
  }

  @override
  String get teacherAverageProgress => 'اوسط Progress';

  @override
  String get teacherLearningAreas => 'سیکھنے کے شعبے';

  @override
  String get teacherBackToStudent => 'طالبِ علم ویو پر واپس';

  @override
  String get teacherDemoNote => 'وضاحت کے لیے ڈیمو کلاس روم ڈیٹا۔';

  @override
  String get loading => 'لوڈ ہو رہا ہے…';

  @override
  String get emptyTitle => 'ابھی یہاں کچھ نہیں';

  @override
  String get emptyBody => 'مواد دستیاب ہونے پر یہاں ظاہر ہوگا۔';

  @override
  String get errorTitle => 'کچھ مسئلہ پیش آیا';

  @override
  String get errorBody => 'دوبارہ کوشش کریں۔';

  @override
  String get favoritesTitle => 'پسندیدہ';

  @override
  String get favoritesEmpty =>
      'ابھی کوئی پسندیدہ سبق نہیں۔ کسی سبق پر ⭐ دبائیں تاکہ یہاں محفوظ ہو جائے۔';

  @override
  String get favoriteAdded => 'پسندیدہ میں شامل ⭐';

  @override
  String get favoriteRemoved => 'پسندیدہ سے ہٹا دیا گیا';

  @override
  String get favoriteAction => 'پسندیدہ';

  @override
  String get searchTitle => 'تلاش';

  @override
  String get searchHint => 'اسباق تلاش کریں…';

  @override
  String get searchPromptBody =>
      'اپنے اسباق تلاش کرنے کے لیے لکھیں — مثلاً: Fractions، پودے، اسم۔';

  @override
  String get searchNoResults => 'کوئی سبق نہیں ملا۔ کوئی اور لفظ آزمائیں۔';

  @override
  String get editProfileTitle => 'پروفائل میں تبدیلی';

  @override
  String get profileUpdated => 'پروفائل اپ ڈیٹ ہو گیا';

  @override
  String get aiEasyExample => 'مجھے مثال دیں';

  @override
  String get aiOfflineTitle => 'آف لائن AI Tutor';

  @override
  String get aiOfflineHelp => 'بنیادی تعلیمی مدد آف لائن دستیاب ہے۔';

  @override
  String get aiClear => 'گفتگو صاف کریں';

  @override
  String get aiExplainSimply => 'آسان الفاظ میں سمجھائیں';

  @override
  String get aiExplainForClass => 'میری جماعت کے مطابق سمجھائیں';

  @override
  String get aiAskQuestion => 'مجھ سے سوال پوچھیں';

  @override
  String get aiTestUnderstanding => 'میری سمجھ جانچیں';

  @override
  String get aiExplainAnother => 'کسی اور طریقے سے سمجھائیں';

  @override
  String get aiTranslate => 'ترجمہ کر کے سمجھائیں';

  @override
  String get aiCorrect => 'درست ✓  شاباش!';

  @override
  String get aiTryAgain => 'بالکل نہیں — آئیے دوبارہ کوشش کریں۔';

  @override
  String get aiRecReview => 'آئیے اس موضوع کو دوبارہ دہراتے ہیں۔';

  @override
  String get aiRecReady => 'بہت خوب! آپ اگلے سبق کے لیے تیار ہیں۔';

  @override
  String get aiRecKeepGoing => 'جاری رکھیں — آپ اچھا کر رہے ہیں۔';

  @override
  String get aiVoiceUnavailable =>
      'آواز سے سوال ابھی اس آلے پر دستیاب نہیں۔ براہِ کرم اپنا سوال لکھیں۔';

  @override
  String get aiVoiceOutputUnavailable =>
      'اس زبان کی آواز ابھی آپ کے آلے پر نصب نہیں ہے۔';

  @override
  String get reportTitle => 'لرننگ رپورٹ';

  @override
  String get reportLessonsCompleted => 'مکمل اسباق';

  @override
  String get reportQuizAverage => 'Quiz اوسط';

  @override
  String get reportStrongTopics => 'مضبوط مضامین';

  @override
  String get reportNeedsPractice => 'مزید مشق درکار';

  @override
  String get reportRecommended => 'تجویز کردہ اگلا سبق';

  @override
  String get reportRecentActivity => 'حالیہ سرگرمی';

  @override
  String get teacherSubjectPerformance => 'مضامین کی کارکردگی';

  @override
  String get teacherNeedingSupport => 'مدد کے متلاشی طلبہ';

  @override
  String get teacherStudentList => 'طلبہ کی فہرست';

  @override
  String get teacherWeakAreas => 'کمزور شعبہ';

  @override
  String get offlinePackageSize => 'پیکج سائز';

  @override
  String get offlineAvailable => 'دستیاب';

  @override
  String get offlineUpdate => 'اپ ڈیٹ';

  @override
  String get profileAchievements => 'کارنامے';

  @override
  String get achievementsTitle => 'کارنامے';

  @override
  String get achievementsPointsLabel => 'پوائنٹس';

  @override
  String get achievementsUnlockedLabel => 'کھل گئے';

  @override
  String get achievementsLockedLabel => 'بند';

  @override
  String get achievementsEmpty =>
      'کارنامے حاصل کرنے کے لیے اسباق اور کوئز مکمل کریں۔';

  @override
  String get achievementFirstLesson => 'پہلا سبق';

  @override
  String get achievementFirstQuiz => 'پہلا کوئز';

  @override
  String get achievementPerfectScore => 'مکمل نمبر';

  @override
  String get achievementFiveLessons => '5 اسباق مکمل';

  @override
  String get achievementTenLessons => '10 اسباق مکمل';

  @override
  String get achievementSevenDayStreak => '7 دن کا تسلسل';

  @override
  String get reportExportCsv => 'CSV محفوظ کریں';

  @override
  String get reportCsvReady => 'رپورٹ CSV میں محفوظ ہو گئی';

  @override
  String get contentPackagesTitle => 'مواد کے پیکجز';

  @override
  String get profileContentPackages => 'مواد کے پیکجز';

  @override
  String get packageStatusInstalled => 'انسٹال شدہ';

  @override
  String get packageStatusAvailable => 'دستیاب';

  @override
  String get packageStatusUpdate => 'اپ ڈیٹ دستیاب';

  @override
  String get packageCheckUpdates => 'اپ ڈیٹ چیک کریں';

  @override
  String get packageOfflineNotice => 'آف لائن — انسٹال شدہ مواد دستیاب ہے۔';

  @override
  String get packageVerifying => 'تصدیق ہو رہی ہے…';

  @override
  String get packageInstalling => 'انسٹال ہو رہا ہے…';

  @override
  String get packageDownloading => 'ڈاؤن لوڈ ہو رہا ہے…';

  @override
  String get packageInstalledOk => 'کامیابی سے انسٹال ہو گیا';

  @override
  String get packageNoneAvailable => 'ابھی کوئی پیکج دستیاب نہیں۔';

  @override
  String get packageConfirmTitle => 'یہ پیکج ڈاؤن لوڈ کریں؟';

  @override
  String packageConfirmBody(String size) {
    return 'اس پیکج کا حجم $size ہے۔ ابھی ڈاؤن لوڈ کریں؟';
  }

  @override
  String get settingsContentUpdates => 'مواد کی اپ ڈیٹس';

  @override
  String get settingsAutoCheckUpdates => 'مواد کی اپ ڈیٹ خودکار چیک کریں';

  @override
  String get settingsMobileDataDownloads => 'موبائل ڈیٹا پر ڈاؤن لوڈ';

  @override
  String get pkgErrNoInternet => 'انٹرنیٹ کنکشن نہیں ہے۔';

  @override
  String get pkgErrTimeout => 'ڈاؤن لوڈ کا وقت ختم ہو گیا۔ دوبارہ کوشش کریں۔';

  @override
  String get pkgErrHttp => 'مواد سرور تک نہیں پہنچا جا سکا۔';

  @override
  String get pkgErrStorage => 'اس پیکج کو انسٹال کرنے کے لیے کافی جگہ نہیں ہے۔';

  @override
  String get pkgErrCorrupt => 'اس پیکج کی تصدیق نہ ہو سکی اور انسٹال نہیں ہوا۔';

  @override
  String get pkgErrChecksum => 'ڈاؤن لوڈ نامکمل یا خراب تھا۔';

  @override
  String get pkgErrSignature =>
      'اس پیکج کی تصدیق نہ ہو سکی اور انسٹال نہیں ہوا۔';

  @override
  String get pkgErrUnsupportedApp =>
      'اس پیکج کو انسٹال کرنے کے لیے ایپ اپ ڈیٹ کریں۔';

  @override
  String get pkgErrWifiRequired => 'مواد ڈاؤن لوڈ کے لیے وائی فائی درکار ہے۔';
}
