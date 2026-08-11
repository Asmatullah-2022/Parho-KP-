import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parho_kp/data/content/connectivity.dart';
import 'package:parho_kp/data/content/content_delivery_providers.dart';
import 'package:parho_kp/data/content/content_package_download_service.dart';
import 'package:parho_kp/data/content/package_catalog.dart';
import 'package:parho_kp/data/database/app_database.dart';
import 'package:parho_kp/data/providers.dart';
import 'package:parho_kp/features/content_packages/content_packages_screen.dart';
import 'package:parho_kp/l10n/app_localizations.dart';
import 'package:parho_kp/shared/providers/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _HostKey implements PublicKeyProvider {
  _HostKey(this.host);
  final MockContentHost host;
  @override
  Future<String> publicKeyBase64() async {
    await host.prepare();
    return host.publicKeyBase64;
  }
}

Future<void> _settle(WidgetTester tester, {int frames = 20}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 60));
  }
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('Content Packages: Available → Download → Installed', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final sp = await SharedPreferences.getInstance();
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final host = MockContentHost();
    await host.prepare();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sp),
          databaseProvider.overrideWithValue(db),
          // Use in-memory-backed stores so the UI test never touches
          // path_provider / native plugins.
          mockContentHostProvider.overrideWithValue(host),
          // Deterministic Wi-Fi so the test never depends on the real
          // connectivity_plus platform channel.
          connectivityProvider
              .overrideWithValue(ManualConnectivity(ConnectivityStatus.wifi)),
          contentPackageDownloadServiceProvider.overrideWith((ref) {
            return ContentPackageDownloadService(
              db,
              httpClient: MockDownloadHttpClient(host),
              publicKeyProvider: _HostKey(host),
              connectivity: ManualConnectivity(ConnectivityStatus.wifi),
              retryDelay: Duration.zero,
            );
          }),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ContentPackagesScreen(),
        ),
      ),
    );

    // The mock catalog resolves to one Available package.
    await _settle(tester);
    expect(find.text('Available'), findsOneWidget);
    expect(find.text('Download'), findsWidgets);

    // Tap Download → the pipeline downloads, verifies (real Ed25519) and installs.
    await tester.tap(find.text('Download').first);
    await _settle(tester, frames: 40);

    // After install the package shows as Installed and content is imported.
    expect(find.text('Installed'), findsWidgets);
    final subjects = await db.subjectsForGrade(5);
    expect(subjects.any((s) => s.code == 'math'), isTrue);

    await db.close();
  });
}
