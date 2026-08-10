import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parho_kp/app.dart';
import 'package:parho_kp/data/database/app_database.dart';
import 'package:parho_kp/data/providers.dart';
import 'package:parho_kp/shared/providers/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/native.dart';

void main() {
  testWidgets('Splash screen shows the app identity', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          databaseProvider.overrideWithValue(db),
        ],
        child: const ParhoKpApp(),
      ),
    );

    // First frame renders the splash with the brand name.
    await tester.pump();
    expect(find.text('PARHO KP'), findsOneWidget);

    // Let the splash timer fire and route onward (to onboarding, since no
    // profile exists) so no timers remain pending.
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();
  });
}
