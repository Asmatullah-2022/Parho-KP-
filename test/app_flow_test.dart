import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parho_kp/app.dart';
import 'package:parho_kp/data/database/app_database.dart';
import 'package:parho_kp/data/providers.dart';
import 'package:parho_kp/data/seed/demo_content.dart';
import 'package:parho_kp/shared/providers/app_settings.dart';
import 'package:parho_kp/shared/widgets/quiz_option.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Builds the real app against an in-memory, seeded database and mock prefs.
Future<Widget> _buildApp(
  Map<String, Object> prefs, {
  bool withStudent = false,
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final sp = await SharedPreferences.getInstance();
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await seedDemoContentIfNeeded(db);
  if (withStudent) {
    await db.createStudent(name: 'Ahmad', grade: 5, languageCode: 'en');
  }
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sp),
      databaseProvider.overrideWithValue(db),
    ],
    child: const ParhoKpApp(),
  );
}

/// Prefs for a fully-set-up returning user (lands on Home).
Map<String, Object> _authedPrefs({
  String language = 'en',
  String theme = 'light',
}) =>
    {
      'onboardingComplete': true,
      'hasProfile': true,
      'language': language,
      'themeMode': theme,
    };

bool _present(Finder f) => f.evaluate().isNotEmpty;

/// Bounded settle: pumps a fixed number of frames. Unlike [pumpAndSettle] this
/// does not hang on benign continuous animations (e.g. an indeterminate
/// progress spinner) while still allowing async provider futures to resolve.
Future<void> _settle(WidgetTester tester, {int frames = 12}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 60));
  }
}

Future<void> _settleSplash(WidgetTester tester) async {
  await tester.pump(); // splash frame
  await tester.pump(const Duration(milliseconds: 1600)); // splash timer
  await _settle(tester);
}

/// Pumps until [finder] appears (bounded), to allow async provider loads and
/// route transitions to complete without hanging on continuous animations.
Future<void> _waitFor(WidgetTester tester, Finder finder,
    {int tries = 50}) async {
  for (var i = 0; i < tries && finder.evaluate().isEmpty; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// Scrolls [finder] into view (handling lazily-built off-screen widgets) and
/// taps it.
Future<void> _tap(WidgetTester tester, Finder finder) async {
  final scrollable = find.byType(Scrollable);
  if (finder.evaluate().isEmpty && scrollable.evaluate().isNotEmpty) {
    // Widget not yet built (below the fold in a lazy list): scroll until found.
    await tester.scrollUntilVisible(finder, 120, scrollable: scrollable.first);
    await _settle(tester);
  } else if (scrollable.evaluate().isNotEmpty) {
    await tester.ensureVisible(finder.first);
    await _settle(tester);
  }
  await tester.tap(finder.first, warnIfMissed: false);
  await _settle(tester);
}

void main() {
  // Each test spins up its own in-memory database; silence the (harmless in
  // tests) warning about multiple database instances.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets(
      'Full flow: Splash → Onboarding → Language → Setup → Home → Subjects → '
      'Mathematics → Fractions → Lesson → Quiz → Quiz Result → Progress',
      (tester) async {
    await tester.pumpWidget(await _buildApp({}));

    // Splash shows brand, then routes to Onboarding (fresh user).
    await tester.pump();
    expect(find.text('PARHO KP'), findsOneWidget);
    await _settleSplash(tester);

    // Onboarding → skip to Language.
    expect(find.text('Skip'), findsOneWidget);
    await _tap(tester, find.text('Skip'));

    // Language screen (English default) → Continue.
    expect(find.text('Choose your language'), findsOneWidget);
    await _tap(tester, find.text('Continue'));

    // Student setup → enter name and start.
    expect(find.text('Create your profile'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Ahmad');
    await _settle(tester);
    await _tap(tester, find.text('Start Learning'));

    // Home dashboard.
    await _waitFor(tester, find.textContaining('Ahmad'));
    expect(find.textContaining('Ahmad'), findsWidgets);

    // Go to the Lessons (Subjects) tab via bottom navigation.
    await _tap(tester, find.text('Lessons'));
    await _waitFor(tester, find.text('My Subjects'));
    expect(find.text('My Subjects'), findsOneWidget);

    // Open Mathematics → subject detail.
    await _waitFor(tester, find.text('Mathematics'));
    await _tap(tester, find.text('Mathematics'));
    await _waitFor(tester, find.text('Overall Progress'));
    expect(find.text('Overall Progress'), findsOneWidget);

    // Open a Fractions lesson.
    await _waitFor(tester, find.text('Understanding Fractions'));
    await _tap(tester, find.text('Understanding Fractions'));

    // Lesson screen → Start Quiz.
    await _waitFor(tester, find.text('Learning Objective'));
    expect(find.text('Learning Objective'), findsOneWidget);
    await _tap(tester, find.text('Start Quiz'));
    await _waitFor(tester, find.byType(QuizOption));

    // Quiz: answer each question, advancing to the end.
    for (var guard = 0; guard < 15; guard++) {
      if (_present(find.byType(QuizOption))) {
        await tester.tap(find.byType(QuizOption).first);
        await _settle(tester);
      }
      if (_present(find.text('Done'))) {
        await _tap(tester, find.text('Done'));
        break;
      } else if (_present(find.text('Next'))) {
        await _tap(tester, find.text('Next'));
      } else {
        break;
      }
    }

    // Quiz Result.
    await _waitFor(tester, find.text('Quiz Complete'));
    expect(find.text('Quiz Complete'), findsOneWidget);
    expect(find.text('Correct'), findsOneWidget);

    // Next Lesson → Home, then open the Progress tab.
    await _tap(tester, find.text('Next Lesson'));
    await _waitFor(tester, find.text('Progress'));
    await _tap(tester, find.text('Progress'));
    await _waitFor(tester, find.text('Overall Progress'));
    expect(find.text('Overall Progress'), findsWidgets);
  });

  testWidgets('English is LTR', (tester) async {
    await tester.pumpWidget(
        await _buildApp(_authedPrefs(language: 'en'), withStudent: true));
    await tester.pump();
    expect(Directionality.of(tester.element(find.text('PARHO KP'))),
        TextDirection.ltr);
    await _settleSplash(tester);
  });

  testWidgets('Urdu is RTL', (tester) async {
    await tester.pumpWidget(
        await _buildApp(_authedPrefs(language: 'ur'), withStudent: true));
    await tester.pump();
    expect(Directionality.of(tester.element(find.text('PARHO KP'))),
        TextDirection.rtl);
    await _settleSplash(tester);
  });

  testWidgets('Pashto is RTL', (tester) async {
    await tester.pumpWidget(
        await _buildApp(_authedPrefs(language: 'ps'), withStudent: true));
    await tester.pump();
    expect(Directionality.of(tester.element(find.text('PARHO KP'))),
        TextDirection.rtl);
    await _settleSplash(tester);
  });

  testWidgets('Dark mode applies a dark theme', (tester) async {
    await tester.pumpWidget(
        await _buildApp(_authedPrefs(theme: 'dark'), withStudent: true));
    await tester.pump();
    expect(Theme.of(tester.element(find.text('PARHO KP'))).brightness,
        Brightness.dark);
    await _settleSplash(tester);
  });

  testWidgets(
      'Authed user reaches Home and can open AI Tutor, Offline, Profile and '
      'Settings with working back navigation', (tester) async {
    await tester.pumpWidget(
        await _buildApp(_authedPrefs(), withStudent: true));
    await _settleSplash(tester);

    // Home greeting.
    await _waitFor(tester, find.textContaining('Ahmad'));
    expect(find.textContaining('Ahmad'), findsWidgets);

    // AI Tutor (mock) via the Home tile.
    await _tap(tester, find.text('AI Tutor'));
    await _waitFor(tester, find.textContaining('I am here to help'));
    expect(find.textContaining('I am here to help'), findsOneWidget);

    // Back navigation returns to Home (the AI Tutor intro is gone and the
    // Home dashboard is shown again).
    await tester.pageBack();
    await _settle(tester);
    // AI Tutor is gone and the bottom-nav shell (Home) is shown again.
    expect(find.textContaining('I am here to help'), findsNothing);
    await _waitFor(tester, find.text('Lessons'));
    expect(find.text('Lessons'), findsWidgets);

    // Profile tab (bottom navigation).
    await _tap(tester, find.text('Profile'));
    await _waitFor(tester, find.text('Learning Progress'));
    expect(find.text('Learning Progress'), findsOneWidget);

    // Offline content via the Profile screen.
    await _tap(tester, find.text('Offline Content'));
    await _waitFor(tester, find.textContaining('without internet'));
    expect(find.textContaining('without internet'), findsWidgets);
    await tester.pageBack();
    await _settle(tester);

    // Settings via the Profile screen.
    await _tap(tester, find.text('Settings'));
    await _waitFor(tester, find.text('Font Size'));
    expect(find.text('Font Size'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets('Offline search and Favorites screens work', (tester) async {
    await tester.pumpWidget(
        await _buildApp(_authedPrefs(), withStudent: true));
    await _settleSplash(tester);

    // Open search from the Home search bar and query "Fractions".
    await _tap(tester, find.text('Search lessons…'));
    await tester.enterText(find.byType(TextField).first, 'Fractions');
    await _settle(tester);
    await _waitFor(tester, find.text('Understanding Fractions'));
    expect(find.text('Understanding Fractions'), findsWidgets);
    await tester.pageBack();
    await _settle(tester);

    // Open the Favorites screen (empty for a new student).
    await _tap(tester, find.text('Favorites'));
    await _waitFor(tester, find.textContaining('No favorite'));
    expect(find.textContaining('No favorite'), findsOneWidget);
  });
}
