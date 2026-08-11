import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parho_kp/data/database/app_database.dart';
import 'package:parho_kp/data/providers.dart';
import 'package:parho_kp/data/seed/demo_content.dart';
import 'package:parho_kp/features/gamification/achievements_screen.dart';
import 'package:parho_kp/features/report/student_report_screen.dart';
import 'package:parho_kp/features/teacher/teacher_screen.dart';
import 'package:parho_kp/l10n/app_localizations.dart';
import 'package:parho_kp/shared/providers/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Renders a screen inside a seeded, in-memory app for a given locale so we can
/// catch crashes, overflow (which throws in tests) and broken RTL layouts.
Future<AppDatabase> _pump(
  WidgetTester tester,
  Widget screen, {
  String language = 'en',
  bool withStudent = true,
}) async {
  SharedPreferences.setMockInitialValues({'language': language});
  final sp = await SharedPreferences.getInstance();
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await seedDemoContentIfNeeded(db);
  if (withStudent) {
    await db.createStudent(name: 'Ahmad', grade: 5, languageCode: language);
  }
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sp),
        databaseProvider.overrideWithValue(db),
      ],
      child: MaterialApp(
        locale: Locale(language),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: screen,
      ),
    ),
  );
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 60));
  }
  return db;
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('Student Report renders (English) without overflow/crash',
      (tester) async {
    final db = await _pump(tester, const StudentReportScreen());
    expect(tester.takeException(), isNull);
    expect(find.byType(StudentReportScreen), findsOneWidget);
    await db.close();
  });

  testWidgets('Student Report renders RTL (Urdu) without overflow/crash',
      (tester) async {
    final db =
        await _pump(tester, const StudentReportScreen(), language: 'ur');
    expect(tester.takeException(), isNull);
    // Content is laid out right-to-left for Urdu.
    expect(Directionality.of(tester.element(find.byType(StudentReportScreen))),
        TextDirection.rtl);
    await db.close();
  });

  testWidgets('Teacher dashboard renders without overflow/crash',
      (tester) async {
    final db = await _pump(tester, const TeacherScreen());
    expect(tester.takeException(), isNull);
    expect(find.byType(TeacherScreen), findsOneWidget);
    await db.close();
  });

  testWidgets('Achievements screen renders without overflow/crash',
      (tester) async {
    final db = await _pump(tester, const AchievementsScreen());
    expect(tester.takeException(), isNull);
    expect(find.byType(AchievementsScreen), findsOneWidget);
    await db.close();
  });
}
