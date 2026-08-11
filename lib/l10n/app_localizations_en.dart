// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Parho KP';

  @override
  String get appNameNative => 'پڑھو KP';

  @override
  String get appSubtitle => 'AI Learning Companion';

  @override
  String get appTagline => 'Learn Anywhere — Even Without Internet';

  @override
  String get actionNext => 'Next';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionGetStarted => 'Get Started';

  @override
  String get actionBack => 'Back';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionSave => 'Save';

  @override
  String get actionDone => 'Done';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionYes => 'Yes';

  @override
  String get actionClose => 'Close';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionOk => 'OK';

  @override
  String get actionSend => 'Send';

  @override
  String get onboard1Title => 'Learn at your own pace';

  @override
  String get onboard1Body => 'Learn the lessons of your class in a simple way.';

  @override
  String get onboard2Title => 'Learn even without internet';

  @override
  String get onboard2Body =>
      'Save your lessons first, then read them offline later.';

  @override
  String get onboard3Title => 'Urdu, Pashto and English';

  @override
  String get onboard3Body => 'Learn in the language you prefer.';

  @override
  String get onboard4Title => 'Make hard lessons easy with AI';

  @override
  String get onboard4Body =>
      'The AI learning assistant helps explain difficult concepts with simple examples.';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get chooseLanguageSubtitle => 'You can change this later in Settings.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageUrdu => 'اردو';

  @override
  String get languagePashto => 'پښتو';

  @override
  String get languageEnglishNative => 'English';

  @override
  String get languageUrduNative => 'Urdu';

  @override
  String get languagePashtoNative => 'Pashto';

  @override
  String get createProfile => 'Create your profile';

  @override
  String get createProfileSubtitle => 'No phone number or email required.';

  @override
  String get studentName => 'Student Name';

  @override
  String get studentNameHint => 'Enter your name';

  @override
  String get nameRequired => 'Please enter your name';

  @override
  String get selectClass => 'Class';

  @override
  String grade(int number) {
    return 'Grade $number';
  }

  @override
  String get languageLabel => 'Language';

  @override
  String get startLearning => 'Start Learning';

  @override
  String greeting(String name) {
    return 'Assalam-o-Alaikum, $name 👋';
  }

  @override
  String gradeShort(int number) {
    return 'Grade $number';
  }

  @override
  String get statusOnline => 'Online';

  @override
  String get statusOffline => 'Offline Mode';

  @override
  String get continueLearning => 'Continue Learning';

  @override
  String get continueLearningAction => 'Continue Learning';

  @override
  String get whatToStudyToday => 'What to study today?';

  @override
  String get tileMyLessons => 'My Lessons';

  @override
  String get tileQuiz => 'Quiz';

  @override
  String get tileAiTutor => 'AI Tutor';

  @override
  String get tileOfflineLessons => 'Offline Lessons';

  @override
  String get tileMyProgress => 'My Progress';

  @override
  String get tileAudioLearning => 'Audio Learning';

  @override
  String get navHome => 'Home';

  @override
  String get navLessons => 'Lessons';

  @override
  String get navQuiz => 'Quiz';

  @override
  String get navProgress => 'Progress';

  @override
  String get navProfile => 'Profile';

  @override
  String get mySubjects => 'My Subjects';

  @override
  String get overallProgress => 'Overall Progress';

  @override
  String unit(int number) {
    return 'Unit $number';
  }

  @override
  String get labelCompleted => 'Completed';

  @override
  String get labelContinue => 'Continue';

  @override
  String get labelStart => 'Start';

  @override
  String lesson(int number) {
    return 'Lesson $number';
  }

  @override
  String get learningObjective => 'Learning Objective';

  @override
  String get sectionExplanation => 'Explanation';

  @override
  String get sectionExample => 'Example';

  @override
  String get sectionIllustration => 'Illustration';

  @override
  String get listenToLesson => 'Listen to lesson';

  @override
  String get iDidntUnderstand => 'I didn\'t understand';

  @override
  String get helpExplainSimply => 'Explain in simple words';

  @override
  String get helpExplainWithExample => 'Explain with an example';

  @override
  String get helpExplainInUrdu => 'Explain in Urdu';

  @override
  String get helpExplainInPashto => 'Explain in Pashto';

  @override
  String get helpListen => 'Listen';

  @override
  String get practice => 'Practice';

  @override
  String get startQuiz => 'Start Quiz';

  @override
  String get demoContent => 'DEMO CONTENT';

  @override
  String get demoContentNote =>
      'This is sample demo content, not from any official textbook.';

  @override
  String questionProgress(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get quizComplete => 'Quiz Complete';

  @override
  String get labelCorrect => 'Correct';

  @override
  String get labelWrong => 'Wrong';

  @override
  String get practiceAgain => 'Practice Again';

  @override
  String get nextLesson => 'Next Lesson';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String percent(int value) {
    return '$value%';
  }

  @override
  String get quizNoQuestions => 'No questions available for this lesson yet.';

  @override
  String get myProgressTitle => 'My Progress';

  @override
  String get statusStrong => 'Strong';

  @override
  String get statusImproving => 'Improving';

  @override
  String get statusNeedsPractice => 'Needs Practice';

  @override
  String get noProgressYet =>
      'Start a lesson or quiz to see your progress here.';

  @override
  String get aiTutorTitle => 'AI Tutor';

  @override
  String get aiTutorIntro => 'I am here to help you with your studies.';

  @override
  String get aiTutorDisclaimer =>
      'AI is a study assistant. It supports — it does not replace — your teacher.';

  @override
  String get aiExplainLesson => 'Explain a lesson';

  @override
  String get aiAskByVoice => 'Ask by voice';

  @override
  String get aiAskByText => 'Ask by writing';

  @override
  String get aiListenAnswer => 'Listen to answer';

  @override
  String get aiTypeQuestion => 'Type your question…';

  @override
  String get aiWantSmallQuestion => 'Would you like to solve a small question?';

  @override
  String get roleStudent => 'You';

  @override
  String get roleAi => 'AI Tutor';

  @override
  String get aiVoiceComingSoon =>
      'Voice input is a demo. Please type your question for now.';

  @override
  String get aiThinking => 'Thinking…';

  @override
  String get offlineLessonsTitle => 'Offline Lessons';

  @override
  String get offlineWorksWithout =>
      'Downloaded lessons work without internet — no data needed.';

  @override
  String get labelDownloaded => 'Downloaded';

  @override
  String get labelDownload => 'Download';

  @override
  String get labelDelete => 'Delete';

  @override
  String get downloadOnWifi => 'Download on Wi-Fi only';

  @override
  String get storageUsed => 'Storage Used';

  @override
  String get downloadStarted => 'Downloaded for offline use.';

  @override
  String get downloadDeleted => 'Removed from offline storage.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileLearningProgress => 'Learning Progress';

  @override
  String get profileOfflineContent => 'Offline Content';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileTeacherDashboard => 'Teacher Dashboard';

  @override
  String get classLabel => 'Class';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsFontSize => 'Font Size';

  @override
  String get settingsAudio => 'Audio';

  @override
  String get settingsAudioSubtitle => 'Read lessons aloud';

  @override
  String get settingsDownloadWifi => 'Download on Wi-Fi only';

  @override
  String get settingsDarkMode => 'Theme';

  @override
  String get settingsOfflineMode => 'Offline Mode';

  @override
  String get settingsOfflineSubtitle => 'Use only downloaded content';

  @override
  String get settingsStorage => 'Storage';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsAbout => 'About';

  @override
  String get fontSmall => 'Small';

  @override
  String get fontMedium => 'Medium';

  @override
  String get fontLarge => 'Large';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get aboutBody =>
      'Parho KP is a demo learning companion designed for students in remote areas. It works offline and supports Urdu, Pashto and English. This is not an official government application.';

  @override
  String get privacyBody =>
      'Parho KP stores your name, class and progress only on this device. No account, phone number or email is required, and your data is not shared.';

  @override
  String get teacherDashboardTitle => 'Teacher Dashboard';

  @override
  String get teacherMyClasses => 'My Classes';

  @override
  String teacherStudents(int count) {
    return '$count Students';
  }

  @override
  String get teacherAverageProgress => 'Average Progress';

  @override
  String get teacherLearningAreas => 'Learning Areas';

  @override
  String get teacherBackToStudent => 'Back to Student View';

  @override
  String get teacherDemoNote => 'Demo classroom data for illustration.';

  @override
  String get loading => 'Loading…';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get emptyBody => 'Content will appear here once available.';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorBody => 'Please try again.';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmpty =>
      'No favorite lessons yet. Tap the ⭐ on a lesson to save it here.';

  @override
  String get favoriteAdded => 'Added to favorites ⭐';

  @override
  String get favoriteRemoved => 'Removed from favorites';

  @override
  String get favoriteAction => 'Favorite';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Search lessons…';

  @override
  String get searchPromptBody =>
      'Type to search your lessons — for example: Fractions, Plants, Nouns.';

  @override
  String get searchNoResults => 'No lessons found. Try another word.';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get aiEasyExample => 'Give me an example';

  @override
  String get aiOfflineTitle => 'Offline AI Tutor';

  @override
  String get aiOfflineHelp => 'Basic learning help is available offline.';

  @override
  String get aiClear => 'Clear conversation';

  @override
  String get aiExplainSimply => 'Explain simply';

  @override
  String get aiExplainForClass => 'Explain for my class';

  @override
  String get aiAskQuestion => 'Ask me a question';

  @override
  String get aiTestUnderstanding => 'Test my understanding';

  @override
  String get aiExplainAnother => 'Explain another way';

  @override
  String get aiTranslate => 'Translate explanation';

  @override
  String get aiCorrect => 'Correct ✓  Well done!';

  @override
  String get aiTryAgain => 'Not quite — let\'s try again.';

  @override
  String get aiRecReview => 'Let\'s review this topic again.';

  @override
  String get aiRecReady => 'Great! You are ready for the next lesson.';

  @override
  String get aiRecKeepGoing => 'Keep going — you\'re doing well.';

  @override
  String get aiVoiceUnavailable =>
      'Voice input isn\'t available on this device yet. Please type your question.';

  @override
  String get aiVoiceOutputUnavailable =>
      'This language\'s voice isn\'t installed on your device yet.';

  @override
  String get reportTitle => 'Learning Report';

  @override
  String get reportLessonsCompleted => 'Lessons completed';

  @override
  String get reportQuizAverage => 'Quiz average';

  @override
  String get reportStrongTopics => 'Strong subjects';

  @override
  String get reportNeedsPractice => 'Needs practice';

  @override
  String get reportRecommended => 'Recommended next lesson';

  @override
  String get reportRecentActivity => 'Recent activity';

  @override
  String get teacherSubjectPerformance => 'Subject performance';

  @override
  String get teacherNeedingSupport => 'Students needing support';

  @override
  String get teacherStudentList => 'Student list';

  @override
  String get teacherWeakAreas => 'Weak area';

  @override
  String get offlinePackageSize => 'Package size';

  @override
  String get offlineAvailable => 'Available';

  @override
  String get offlineUpdate => 'Update';

  @override
  String get profileAchievements => 'Achievements';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String get achievementsPointsLabel => 'Points';

  @override
  String get achievementsUnlockedLabel => 'Unlocked';

  @override
  String get achievementsLockedLabel => 'Locked';

  @override
  String get achievementsEmpty =>
      'Complete lessons and quizzes to earn achievements.';

  @override
  String get achievementFirstLesson => 'First Lesson';

  @override
  String get achievementFirstQuiz => 'First Quiz';

  @override
  String get achievementPerfectScore => 'Perfect Score';

  @override
  String get achievementFiveLessons => '5 Lessons Completed';

  @override
  String get achievementTenLessons => '10 Lessons Completed';

  @override
  String get achievementSevenDayStreak => '7-Day Streak';

  @override
  String get reportExportCsv => 'Export CSV';

  @override
  String get reportCsvReady => 'Report saved as CSV';

  @override
  String get contentPackagesTitle => 'Content Packages';

  @override
  String get profileContentPackages => 'Content Packages';

  @override
  String get packageStatusInstalled => 'Installed';

  @override
  String get packageStatusAvailable => 'Available';

  @override
  String get packageStatusUpdate => 'Update available';

  @override
  String get packageCheckUpdates => 'Check for updates';

  @override
  String get packageOfflineNotice =>
      'Offline — installed content is available.';

  @override
  String get packageVerifying => 'Verifying…';

  @override
  String get packageInstalling => 'Installing…';

  @override
  String get packageDownloading => 'Downloading…';

  @override
  String get packageInstalledOk => 'Installed successfully';

  @override
  String get packageNoneAvailable => 'No packages available right now.';

  @override
  String get packageConfirmTitle => 'Download this package?';

  @override
  String packageConfirmBody(String size) {
    return 'This package is $size. Download now?';
  }

  @override
  String get settingsContentUpdates => 'Content updates';

  @override
  String get settingsAutoCheckUpdates => 'Auto-check for content updates';

  @override
  String get settingsMobileDataDownloads => 'Download over mobile data';

  @override
  String get pkgErrNoInternet => 'No internet connection.';

  @override
  String get pkgErrTimeout => 'Download timed out. Please try again.';

  @override
  String get pkgErrHttp => 'Could not reach the content server.';

  @override
  String get pkgErrStorage =>
      'Not enough storage space to download this lesson package.';

  @override
  String get pkgErrCorrupt =>
      'This package could not be verified and was not installed.';

  @override
  String get pkgErrChecksum => 'The download was incomplete or corrupted.';

  @override
  String get pkgErrSignature =>
      'This package could not be verified and was not installed.';

  @override
  String get pkgErrUnsupportedApp =>
      'Please update the app to install this package.';

  @override
  String get pkgErrWifiRequired => 'Wi-Fi required for content download.';
}
