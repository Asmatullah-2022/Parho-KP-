import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/database/app_database.dart';
import 'data/providers.dart';
import 'data/seed/demo_content.dart';
import 'shared/providers/app_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load lightweight preferences and open + seed the offline database before
  // the first frame so routing and content are ready immediately.
  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase();
  await seedDemoContentIfNeeded(db);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        databaseProvider.overrideWithValue(db),
      ],
      child: const ParhoKpApp(),
    ),
  );
}
