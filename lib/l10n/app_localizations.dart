import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ps.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ps'),
    Locale('ur'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Parho KP'**
  String get appName;

  /// No description provided for @appNameNative.
  ///
  /// In en, this message translates to:
  /// **'پڑھو KP'**
  String get appNameNative;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI Learning Companion'**
  String get appSubtitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Learn Anywhere — Even Without Internet'**
  String get appTagline;

  /// No description provided for @actionNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get actionNext;

  /// No description provided for @actionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// No description provided for @actionGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get actionGetStarted;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get actionYes;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// No description provided for @actionSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get actionSend;

  /// No description provided for @onboard1Title.
  ///
  /// In en, this message translates to:
  /// **'Learn at your own pace'**
  String get onboard1Title;

  /// No description provided for @onboard1Body.
  ///
  /// In en, this message translates to:
  /// **'Learn the lessons of your class in a simple way.'**
  String get onboard1Body;

  /// No description provided for @onboard2Title.
  ///
  /// In en, this message translates to:
  /// **'Learn even without internet'**
  String get onboard2Title;

  /// No description provided for @onboard2Body.
  ///
  /// In en, this message translates to:
  /// **'Save your lessons first, then read them offline later.'**
  String get onboard2Body;

  /// No description provided for @onboard3Title.
  ///
  /// In en, this message translates to:
  /// **'Urdu, Pashto and English'**
  String get onboard3Title;

  /// No description provided for @onboard3Body.
  ///
  /// In en, this message translates to:
  /// **'Learn in the language you prefer.'**
  String get onboard3Body;

  /// No description provided for @onboard4Title.
  ///
  /// In en, this message translates to:
  /// **'Make hard lessons easy with AI'**
  String get onboard4Title;

  /// No description provided for @onboard4Body.
  ///
  /// In en, this message translates to:
  /// **'The AI learning assistant helps explain difficult concepts with simple examples.'**
  String get onboard4Body;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @chooseLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this later in Settings.'**
  String get chooseLanguageSubtitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageUrdu.
  ///
  /// In en, this message translates to:
  /// **'اردو'**
  String get languageUrdu;

  /// No description provided for @languagePashto.
  ///
  /// In en, this message translates to:
  /// **'پښتو'**
  String get languagePashto;

  /// No description provided for @languageEnglishNative.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglishNative;

  /// No description provided for @languageUrduNative.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get languageUrduNative;

  /// No description provided for @languagePashtoNative.
  ///
  /// In en, this message translates to:
  /// **'Pashto'**
  String get languagePashtoNative;

  /// No description provided for @createProfile.
  ///
  /// In en, this message translates to:
  /// **'Create your profile'**
  String get createProfile;

  /// No description provided for @createProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No phone number or email required.'**
  String get createProfileSubtitle;

  /// No description provided for @studentName.
  ///
  /// In en, this message translates to:
  /// **'Student Name'**
  String get studentName;

  /// No description provided for @studentNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get studentNameHint;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameRequired;

  /// No description provided for @selectClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get selectClass;

  /// No description provided for @grade.
  ///
  /// In en, this message translates to:
  /// **'Grade {number}'**
  String grade(int number);

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @startLearning.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get startLearning;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Assalam-o-Alaikum, {name} 👋'**
  String greeting(String name);

  /// No description provided for @gradeShort.
  ///
  /// In en, this message translates to:
  /// **'Grade {number}'**
  String gradeShort(int number);

  /// No description provided for @statusOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get statusOnline;

  /// No description provided for @statusOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get statusOffline;

  /// No description provided for @continueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get continueLearning;

  /// No description provided for @continueLearningAction.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get continueLearningAction;

  /// No description provided for @whatToStudyToday.
  ///
  /// In en, this message translates to:
  /// **'What to study today?'**
  String get whatToStudyToday;

  /// No description provided for @tileMyLessons.
  ///
  /// In en, this message translates to:
  /// **'My Lessons'**
  String get tileMyLessons;

  /// No description provided for @tileQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get tileQuiz;

  /// No description provided for @tileAiTutor.
  ///
  /// In en, this message translates to:
  /// **'AI Tutor'**
  String get tileAiTutor;

  /// No description provided for @tileOfflineLessons.
  ///
  /// In en, this message translates to:
  /// **'Offline Lessons'**
  String get tileOfflineLessons;

  /// No description provided for @tileMyProgress.
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get tileMyProgress;

  /// No description provided for @tileAudioLearning.
  ///
  /// In en, this message translates to:
  /// **'Audio Learning'**
  String get tileAudioLearning;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get navLessons;

  /// No description provided for @navQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get navQuiz;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @mySubjects.
  ///
  /// In en, this message translates to:
  /// **'My Subjects'**
  String get mySubjects;

  /// No description provided for @overallProgress.
  ///
  /// In en, this message translates to:
  /// **'Overall Progress'**
  String get overallProgress;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit {number}'**
  String unit(int number);

  /// No description provided for @labelCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get labelCompleted;

  /// No description provided for @labelContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get labelContinue;

  /// No description provided for @labelStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get labelStart;

  /// No description provided for @lesson.
  ///
  /// In en, this message translates to:
  /// **'Lesson {number}'**
  String lesson(int number);

  /// No description provided for @learningObjective.
  ///
  /// In en, this message translates to:
  /// **'Learning Objective'**
  String get learningObjective;

  /// No description provided for @sectionExplanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get sectionExplanation;

  /// No description provided for @sectionExample.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get sectionExample;

  /// No description provided for @sectionIllustration.
  ///
  /// In en, this message translates to:
  /// **'Illustration'**
  String get sectionIllustration;

  /// No description provided for @listenToLesson.
  ///
  /// In en, this message translates to:
  /// **'Listen to lesson'**
  String get listenToLesson;

  /// No description provided for @iDidntUnderstand.
  ///
  /// In en, this message translates to:
  /// **'I didn\'t understand'**
  String get iDidntUnderstand;

  /// No description provided for @helpExplainSimply.
  ///
  /// In en, this message translates to:
  /// **'Explain in simple words'**
  String get helpExplainSimply;

  /// No description provided for @helpExplainWithExample.
  ///
  /// In en, this message translates to:
  /// **'Explain with an example'**
  String get helpExplainWithExample;

  /// No description provided for @helpExplainInUrdu.
  ///
  /// In en, this message translates to:
  /// **'Explain in Urdu'**
  String get helpExplainInUrdu;

  /// No description provided for @helpExplainInPashto.
  ///
  /// In en, this message translates to:
  /// **'Explain in Pashto'**
  String get helpExplainInPashto;

  /// No description provided for @helpListen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get helpListen;

  /// No description provided for @practice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// No description provided for @startQuiz.
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get startQuiz;

  /// No description provided for @demoContent.
  ///
  /// In en, this message translates to:
  /// **'DEMO CONTENT'**
  String get demoContent;

  /// No description provided for @demoContentNote.
  ///
  /// In en, this message translates to:
  /// **'This is sample demo content, not from any official textbook.'**
  String get demoContentNote;

  /// No description provided for @questionProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String questionProgress(int current, int total);

  /// No description provided for @quizComplete.
  ///
  /// In en, this message translates to:
  /// **'Quiz Complete'**
  String get quizComplete;

  /// No description provided for @labelCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get labelCorrect;

  /// No description provided for @labelWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get labelWrong;

  /// No description provided for @practiceAgain.
  ///
  /// In en, this message translates to:
  /// **'Practice Again'**
  String get practiceAgain;

  /// No description provided for @nextLesson.
  ///
  /// In en, this message translates to:
  /// **'Next Lesson'**
  String get nextLesson;

  /// No description provided for @scoreOutOf.
  ///
  /// In en, this message translates to:
  /// **'{score} / {total}'**
  String scoreOutOf(int score, int total);

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percent(int value);

  /// No description provided for @quizNoQuestions.
  ///
  /// In en, this message translates to:
  /// **'No questions available for this lesson yet.'**
  String get quizNoQuestions;

  /// No description provided for @myProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get myProgressTitle;

  /// No description provided for @statusStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get statusStrong;

  /// No description provided for @statusImproving.
  ///
  /// In en, this message translates to:
  /// **'Improving'**
  String get statusImproving;

  /// No description provided for @statusNeedsPractice.
  ///
  /// In en, this message translates to:
  /// **'Needs Practice'**
  String get statusNeedsPractice;

  /// No description provided for @noProgressYet.
  ///
  /// In en, this message translates to:
  /// **'Start a lesson or quiz to see your progress here.'**
  String get noProgressYet;

  /// No description provided for @aiTutorTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Tutor'**
  String get aiTutorTitle;

  /// No description provided for @aiTutorIntro.
  ///
  /// In en, this message translates to:
  /// **'I am here to help you with your studies.'**
  String get aiTutorIntro;

  /// No description provided for @aiTutorDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'AI is a study assistant. It supports — it does not replace — your teacher.'**
  String get aiTutorDisclaimer;

  /// No description provided for @aiExplainLesson.
  ///
  /// In en, this message translates to:
  /// **'Explain a lesson'**
  String get aiExplainLesson;

  /// No description provided for @aiAskByVoice.
  ///
  /// In en, this message translates to:
  /// **'Ask by voice'**
  String get aiAskByVoice;

  /// No description provided for @aiAskByText.
  ///
  /// In en, this message translates to:
  /// **'Ask by writing'**
  String get aiAskByText;

  /// No description provided for @aiListenAnswer.
  ///
  /// In en, this message translates to:
  /// **'Listen to answer'**
  String get aiListenAnswer;

  /// No description provided for @aiTypeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Type your question…'**
  String get aiTypeQuestion;

  /// No description provided for @aiWantSmallQuestion.
  ///
  /// In en, this message translates to:
  /// **'Would you like to solve a small question?'**
  String get aiWantSmallQuestion;

  /// No description provided for @roleStudent.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get roleStudent;

  /// No description provided for @roleAi.
  ///
  /// In en, this message translates to:
  /// **'AI Tutor'**
  String get roleAi;

  /// No description provided for @aiVoiceComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Voice input is a demo. Please type your question for now.'**
  String get aiVoiceComingSoon;

  /// No description provided for @aiThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking…'**
  String get aiThinking;

  /// No description provided for @offlineLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline Lessons'**
  String get offlineLessonsTitle;

  /// No description provided for @offlineWorksWithout.
  ///
  /// In en, this message translates to:
  /// **'Downloaded lessons work without internet — no data needed.'**
  String get offlineWorksWithout;

  /// No description provided for @labelDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get labelDownloaded;

  /// No description provided for @labelDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get labelDownload;

  /// No description provided for @labelDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get labelDelete;

  /// No description provided for @downloadOnWifi.
  ///
  /// In en, this message translates to:
  /// **'Download on Wi-Fi only'**
  String get downloadOnWifi;

  /// No description provided for @storageUsed.
  ///
  /// In en, this message translates to:
  /// **'Storage Used'**
  String get storageUsed;

  /// No description provided for @downloadStarted.
  ///
  /// In en, this message translates to:
  /// **'Downloaded for offline use.'**
  String get downloadStarted;

  /// No description provided for @downloadDeleted.
  ///
  /// In en, this message translates to:
  /// **'Removed from offline storage.'**
  String get downloadDeleted;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileLearningProgress.
  ///
  /// In en, this message translates to:
  /// **'Learning Progress'**
  String get profileLearningProgress;

  /// No description provided for @profileOfflineContent.
  ///
  /// In en, this message translates to:
  /// **'Offline Content'**
  String get profileOfflineContent;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileTeacherDashboard.
  ///
  /// In en, this message translates to:
  /// **'Teacher Dashboard'**
  String get profileTeacherDashboard;

  /// No description provided for @classLabel.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get classLabel;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get settingsFontSize;

  /// No description provided for @settingsAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get settingsAudio;

  /// No description provided for @settingsAudioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read lessons aloud'**
  String get settingsAudioSubtitle;

  /// No description provided for @settingsDownloadWifi.
  ///
  /// In en, this message translates to:
  /// **'Download on Wi-Fi only'**
  String get settingsDownloadWifi;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsDarkMode;

  /// No description provided for @settingsOfflineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get settingsOfflineMode;

  /// No description provided for @settingsOfflineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use only downloaded content'**
  String get settingsOfflineSubtitle;

  /// No description provided for @settingsStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get settingsStorage;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @fontSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get fontSmall;

  /// No description provided for @fontMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get fontMedium;

  /// No description provided for @fontLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get fontLarge;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'Parho KP is a demo learning companion designed for students in remote areas. It works offline and supports Urdu, Pashto and English. This is not an official government application.'**
  String get aboutBody;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'Parho KP stores your name, class and progress only on this device. No account, phone number or email is required, and your data is not shared.'**
  String get privacyBody;

  /// No description provided for @teacherDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher Dashboard'**
  String get teacherDashboardTitle;

  /// No description provided for @teacherMyClasses.
  ///
  /// In en, this message translates to:
  /// **'My Classes'**
  String get teacherMyClasses;

  /// No description provided for @teacherStudents.
  ///
  /// In en, this message translates to:
  /// **'{count} Students'**
  String teacherStudents(int count);

  /// No description provided for @teacherAverageProgress.
  ///
  /// In en, this message translates to:
  /// **'Average Progress'**
  String get teacherAverageProgress;

  /// No description provided for @teacherLearningAreas.
  ///
  /// In en, this message translates to:
  /// **'Learning Areas'**
  String get teacherLearningAreas;

  /// No description provided for @teacherBackToStudent.
  ///
  /// In en, this message translates to:
  /// **'Back to Student View'**
  String get teacherBackToStudent;

  /// No description provided for @teacherDemoNote.
  ///
  /// In en, this message translates to:
  /// **'Demo classroom data for illustration.'**
  String get teacherDemoNote;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In en, this message translates to:
  /// **'Content will appear here once available.'**
  String get emptyBody;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @errorBody.
  ///
  /// In en, this message translates to:
  /// **'Please try again.'**
  String get errorBody;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No favorite lessons yet. Tap the ⭐ on a lesson to save it here.'**
  String get favoritesEmpty;

  /// No description provided for @favoriteAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites ⭐'**
  String get favoriteAdded;

  /// No description provided for @favoriteRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get favoriteRemoved;

  /// No description provided for @favoriteAction.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favoriteAction;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search lessons…'**
  String get searchHint;

  /// No description provided for @searchPromptBody.
  ///
  /// In en, this message translates to:
  /// **'Type to search your lessons — for example: Fractions, Plants, Nouns.'**
  String get searchPromptBody;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No lessons found. Try another word.'**
  String get searchNoResults;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @aiEasyExample.
  ///
  /// In en, this message translates to:
  /// **'Give an easy example'**
  String get aiEasyExample;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ps', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ps':
      return AppLocalizationsPs();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
