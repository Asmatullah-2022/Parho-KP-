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
import 'package:shared_preferences/shared_preferences.dart';

Future<Widget> _app(Map<String, Object> prefs) async {
  SharedPreferences.setMockInitialValues(prefs);
  final sp = await SharedPreferences.getInstance();
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await seedDemoContentIfNeeded(db);
  await db.createStudent(name: 'Ahmed', grade: 5, languageCode: 'ur');
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sp),
      databaseProvider.overrideWithValue(db),
    ],
    child: const ParhoKpApp(),
  );
}

Map<String, Object> _prefs({String language = 'en', bool offline = false}) => {
      'onboardingComplete': true,
      'hasProfile': true,
      'language': language,
      'themeMode': 'light',
      'offlineMode': offline,
    };

Future<void> _settle(WidgetTester t, {int frames = 12}) async {
  for (var i = 0; i < frames; i++) {
    await t.pump(const Duration(milliseconds: 60));
  }
}

Future<void> _splash(WidgetTester t) async {
  await t.pump();
  await t.pump(const Duration(milliseconds: 1600));
  await _settle(t);
}

Future<void> _waitFor(WidgetTester t, Finder f, {int tries = 60}) async {
  for (var i = 0; i < tries && f.evaluate().isEmpty; i++) {
    await t.pump(const Duration(milliseconds: 50));
  }
}

Future<void> _tap(WidgetTester t, Finder f) async {
  final sc = find.byType(Scrollable);
  if (f.evaluate().isEmpty && sc.evaluate().isNotEmpty) {
    await t.scrollUntilVisible(f, 120, scrollable: sc.first);
    await _settle(t);
  } else if (sc.evaluate().isNotEmpty) {
    await t.ensureVisible(f.first);
    await _settle(t);
  }
  await t.tap(f.first, warnIfMissed: false);
  await _settle(t);
}

/// Taps an action chip in the tutor's horizontal actions bar, scrolling that
/// specific list into view if needed.
Future<void> _tapChip(WidgetTester t, String label) async {
  final f = find.text(label);
  await _waitFor(t, f);
  if (f.evaluate().isEmpty) {
    final row = find
        .ancestor(
            of: find.byType(ActionChip).first, matching: find.byType(Scrollable))
        .first;
    await t.scrollUntilVisible(f, 150, scrollable: row);
    await _settle(t);
  }
  await t.tap(f.first, warnIfMissed: false);
  await _settle(t);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('AI Tutor: explain lesson and test-my-understanding flow',
      (tester) async {
    await tester.pumpWidget(await _app(_prefs()));
    await _splash(tester);

    // Open the AI Tutor from Home.
    await _tap(tester, find.text('AI Tutor'));
    await _waitFor(tester, find.textContaining('I am here to help'));
    expect(find.textContaining('I am here to help'), findsOneWidget);
    // Context header shows the class.
    expect(find.textContaining('Grade 5'), findsWidgets);

    // Explain Lesson (first action chip).
    await _tapChip(tester, 'Explain a lesson');
    await _waitFor(tester, find.textContaining('read the lesson'));
    expect(find.textContaining('read the lesson'), findsWidgets);

    // Test My Understanding → answer the question.
    await _tapChip(tester, 'Test my understanding');
    await _waitFor(tester, find.text('1/4'));
    expect(find.text('1/4'), findsWidgets);
    await tester.ensureVisible(find.text('1/4').first);
    await _settle(tester);
    await tester.tap(find.text('1/4').first, warnIfMissed: false);
    await _settle(tester);
    await _waitFor(tester, find.textContaining('Correct'));
    expect(find.textContaining('Correct'), findsWidgets);
  });

  testWidgets('AI Tutor shows Offline title when offline', (tester) async {
    await tester.pumpWidget(await _app(_prefs(offline: true)));
    await _splash(tester);
    await _tap(tester, find.text('AI Tutor'));
    await _waitFor(tester, find.text('Offline AI Tutor'));
    expect(find.text('Offline AI Tutor'), findsOneWidget);
  });

  testWidgets('AI Tutor renders RTL in Urdu', (tester) async {
    await tester.pumpWidget(await _app(_prefs(language: 'ur')));
    await _splash(tester);
    await _tap(tester, find.text('AI Tutor'));
    await _waitFor(tester, find.textContaining('یہاں ہوں'));
    final dir = Directionality.of(
        tester.element(find.textContaining('یہاں ہوں').first));
    expect(dir, TextDirection.rtl);
  });
}
