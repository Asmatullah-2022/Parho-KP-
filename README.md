# پڑھو KP — Parho KP

**AI Learning Companion — Learn Anywhere, Even Without Internet**

An offline-first educational Android app for primary-school children in remote
areas of Khyber Pakhtunkhwa, Pakistan. Built with Flutter + Material 3.

> **Not an official government application.** Parho KP is an independent demo
> project. It does not use or imply any official Government of Khyber
> Pakhtunkhwa branding, and the learning content shipped here is clearly marked
> **DEMO CONTENT** — original samples, not copyrighted textbooks.

> **AI supports teachers, it does not replace them.** The in-app AI Tutor is a
> study assistant that helps explain difficult concepts. It is currently a
> **mock** (fully on-device, no external AI API).

---

## Features

- **Offline-first**: lessons, audio, practice, quizzes, results and progress all
  work with no internet. Data is stored locally in SQLite (Drift).
- **Three languages**: English (LTR), اردو (RTL), پښتو (RTL) with proper
  localization — no hardcoded user-facing text. Switchable in Settings.
- **Full learning flow**: Splash → Onboarding → Language → Student Setup → Home
  → Subjects → Units → Lessons → Practice → Quiz → Result → Progress.
- **Audio Learning**: lessons and answers are read aloud using on-device
  text-to-speech (no bundled media, no bandwidth).
- **"I didn't understand" helper**: re-explains a lesson more simply, with an
  example, or in Urdu/Pashto, and can read it aloud.
- **Mock AI Tutor**: friendly, purpose-built tutor with guided actions.
- **Progress tracking**: subject and overall progress are **computed** from
  completed lessons and quiz scores — never hardcoded. Status shown as
  Strong / Improving / Needs Practice (icon + text, never colour alone).
- **Offline downloads, Profile, Settings, Teacher Dashboard**.
- **Gamification** (Phase 5): encouraging achievements (First Lesson, First
  Quiz, Perfect Score, 5/10 Lessons, 7-Day Streak) and points — **no gambling
  or addictive mechanics**.
- **Deterministic recommendations** (Phase 5): a local, explainable next step —
  Review / Practice more / Try next lesson / Ready for next unit.
- **Accessibility**: large text, adjustable font size, ≥48dp touch targets,
  high contrast, screen-reader labels, light/dark/system themes.

### Phase 5 — production architecture (offline-first)

Phase 5 adds the architecture needed to grow into a real product, without
breaking the fully-offline experience or adding heavy dependencies:

- **Versioned content packages** — installable/updatable curriculum packages
  with metadata and **Installed / Available / Update-available** status
  (`ContentPackageService`). Semantic-version comparison decides updates.
- **Safe content importing** — every package (bundled, downloaded, or from a
  future server) is **validated before any database write**; invalid or
  malformed packages are rejected cleanly (`ContentValidator` /
  `ContentValidationException`) and never corrupt or crash the app.
- **Low-bandwidth sync queue** — learning signals (progress, quiz, achievements)
  are written locally first and queued for best-effort upload with
  `pending / synced / failed` states and retry. **Data is never lost** and only
  **anonymous** payloads are queued (`SyncService`). No backend is wired by
  default (`NoopSyncClient`) — the app is fully usable offline.
- **Secure AI Tutor backend contract** — `Flutter → Secure Backend → AI
  Provider`. `RemoteTutorService` + `TutorApiClient` define the wire contract
  (`TutorApiRequest` / `TutorApiResponse` with `answer / language /
  suggestedAction / safetyFlag`). **No API key is ever stored in the app.** Cost
  control (local knowledge + cache first, minimal payloads) and safety (safe
  answers for sensitive questions) run before any network call. The offline
  `MockTutorService` remains the default.
- **Accounts** — guest-offline student by default (`AccountService`); optional
  school/class only. Teacher accounts via `MockAuthService` with interfaces
  shaped for future secure sign-in. **No CNIC, address, GPS, phone or family
  data is ever collected.**
- **Voice / audio** — `LessonAudioService` plays a bundled offline audio file
  when a downloaded package includes one, otherwise falls back to on-device TTS,
  and reports "unavailable" gracefully (never crashes).
- **Teacher reporting** — local **CSV** export for a student report and a whole
  class (`ReportExportService`), plus a `ReportPdfExporter` interface ready for
  a future PDF implementation. No internet required.
- **School mode** — clean interfaces (`SchoolSyncService` / `SchoolSyncTransport`)
  for a teacher device to collect progress from nearby student devices over a
  **local** link (Wi-Fi Direct / hotspot / Bluetooth), architecture-only today.

### Phase 7 — production catalog + offline audio

- **Production catalog config** — one config point (`CatalogConfig.production`,
  `useMockHost:false`) with a configurable HTTPS catalog URL and the public key
  injected via `--dart-define`; the dev mock host stays for testing.
- **Real connectivity** — `connectivity_plus` behind the `Connectivity`
  interface (fails safe to Wi-Fi in tests); downloads **pause** if Wi-Fi drops
  mid-stream and **resume** from the saved partial when it returns.
- **File-based downloads** — partial downloads stream to a **temporary file**
  (not RAM) and are only imported after verification; the installed version is
  never replaced by an unverified download.
- **Offline audio** — packages can ship `audio/lesson_*.mp3`; the importer
  records each lesson's `audioAsset`, files are stored on disk, and the lesson's
  **Listen** button plays the downloaded audio (falling back to TTS). Audio is
  streamed by the platform — never preloaded into memory.
- **Signing tools** — `tool/generate_keys.dart` and `tool/sign_package.dart`
  produce the key pair, ZIP, SHA-256, Ed25519 signature and manifest entry. The
  private key is read only from `PARHO_PRIVATE_KEY` — never from source or repo.

## Tech stack

| Concern        | Choice                                  |
|----------------|-----------------------------------------|
| UI             | Flutter, Material 3                     |
| State          | Riverpod (`flutter_riverpod`)           |
| Navigation     | GoRouter (with a bottom-nav shell)      |
| Local database | Drift + SQLite (`sqlite3_flutter_libs`) |
| Preferences    | `shared_preferences`                    |
| Audio (TTS)    | `flutter_tts` (on-device)               |
| i18n           | Flutter `gen_l10n` (ARB files)          |
| Downloads      | `http` (HTTPS, behind an interface)     |
| Integrity      | `crypto` (SHA-256)                       |
| Authenticity   | `cryptography` (Ed25519, public key)    |
| Packages       | `archive` (ZIP, pure Dart)              |
| Connectivity   | `connectivity_plus` (Wi-Fi/mobile/offline) |
| Offline audio  | `audioplayers` (file playback, lazy)    |
| Free space     | `disk_space_plus` (download pre-check)   |

## Project structure (feature-first)

```
lib/
  main.dart                 # bootstrap: prefs + DB + seed, runApp
  app.dart                  # MaterialApp.router: theme, locale, font scale
  core/theme/               # colors + Material 3 theme (light/dark)
  core/router/              # GoRouter routes + redirect gating
  l10n/                     # app_en/ur/ps.arb (+ generated)
  data/database/            # Drift tables, DAOs, connection (schema v3)
  data/seed/                # DEMO CONTENT (Grade 1–8, 3 languages)
  core/config/              # single catalog config point (endpoint + public key)
  data/content/             # content models, validation, importer, packages,
                            #   manifest, verifier (sha256+ed25519), zip reader,
                            #   catalog (mock/remote), download service
  features/content_packages/ # Content Packages screen (install/update/progress)
  data/sync/                # low-bandwidth outbound sync queue
  data/accounts/            # student + teacher accounts (mock auth)
  data/repositories/        # progress computation + data access
  data/providers.dart       # Riverpod providers
  features/ai_tutor/        # tutor service + secure backend contract (tutor_api)
  features/gamification/    # achievements catalog, service + screen
  features/recommendations/ # deterministic next-step recommender
  features/report/          # student report + CSV/PDF export service
  features/school_mode/     # local school-sync interfaces
  features/<feature>/       # one folder per screen/feature
  shared/widgets/           # PrimaryButton, SubjectCard, QuizOption, …
  shared/services/          # TTS, speech input, lesson audio (file→TTS)
  shared/providers/         # settings (language/theme/font/flags)
```

## Building the APK

Prerequisites: the **Flutter SDK** and the **Android SDK** (platform-tools,
build-tools and a platform, e.g. android-34). Android Studio installs these for
you, or use `sdkmanager` from the command-line tools.

```bash
flutter pub get
dart run build_runner build            # generate Drift + code (first time / after schema edits)
flutter gen-l10n                       # generate localizations
flutter analyze                        # static analysis (clean)
flutter test                           # unit + widget tests (passing)
flutter build apk --debug              # → build/app/outputs/flutter-apk/app-debug.apk
```

Release build: `flutter build apk --release`. Release signing is already wired
via `android/key.properties` — see **Building on Windows with Android Studio**
below for the full, exact procedure.

> **Note on this repository's build environment:** this project was developed in
> a sandbox with **no Android SDK** (`flutter build apk` reports "No Android SDK
> found") and a network policy that blocks `dl.google.com`. `flutter analyze`
> and `flutter test` pass there, but the APK/AAB **cannot** be built in that
> sandbox. Run the commands below on any machine with the Android SDK and it
> will produce the artifacts at the paths shown. No build success is faked here.

## Building on Windows with Android Studio (exact steps)

Do this on your own Windows PC (or macOS/Linux — commands are identical).

### 0. One-time prerequisites
1. Install **Flutter** (`flutter.dev/docs/get-started/install/windows`) and add
   `flutter\bin` to PATH.
2. Install **Android Studio**, then open **More Actions → SDK Manager** and
   install: **Android SDK Platform 34** (or the latest), **Android SDK
   Build-Tools**, **Android SDK Command-line Tools**, **Android SDK
   Platform-Tools**.
3. Accept licenses: `flutter doctor --android-licenses` (answer `y` to all).
4. Verify: `flutter doctor` — the **Android toolchain** line must be a ✓.

### 1. Get the project ready
```powershell
git clone <this-repo-url>
cd Parho-KP-
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # Drift/codegen
flutter gen-l10n                                            # localizations
flutter analyze                                             # expect: No issues found
flutter test                                                # expect: All tests passed (127)
```

### 2. Create your release keystore (ONCE, keep it OUTSIDE the repo)
```powershell
keytool -genkey -v -keystore %USERPROFILE%\parho-kp-upload.jks ^
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
Then create `android\key.properties` (this file is **git-ignored** — never
commit it). Copy `android\key.properties.example` and fill in real values:
```properties
storeFile=C:/Users/<you>/parho-kp-upload.jks
storePassword=<your store password>
keyAlias=upload
keyPassword=<your key password>
```
If `android\key.properties` is missing, the build falls back to **debug**
signing (fine for testing, **not** accepted by Google Play).

### 3. Build the release APK (sideload / direct install)
```powershell
flutter build apk --release ^
  --dart-define=PARHO_CATALOG_URL=https://YOUR-CDN/parho-kp/catalog.json ^
  --dart-define=PARHO_PUBLIC_KEY=<your base64 Ed25519 PUBLIC key>
```
**Output APK:** `build\app\outputs\flutter-apk\app-release.apk`

### 4. Build the Android App Bundle (for Google Play)
```powershell
flutter build appbundle --release ^
  --dart-define=PARHO_CATALOG_URL=https://YOUR-CDN/parho-kp/catalog.json ^
  --dart-define=PARHO_PUBLIC_KEY=<your base64 Ed25519 PUBLIC key>
```
**Output AAB:** `build\app\outputs\bundle\release\app-release.aab`

Upload the `.aab` to the Google Play Console.

### 5. Where the keys go
- **Public Ed25519 key** → passed into the app at build time via
  `--dart-define=PARHO_PUBLIC_KEY=...`; it is the ONLY key inside the APK. It
  lives in `CatalogConfig.production.publicKeyBase64` (read from the
  `--dart-define`). Also flip the app to production by using
  `CatalogConfig.production` (which already sets `useMockHost: false`).
- **Private Ed25519 key** → used ONLY by `tool/sign_package.dart` on a secure
  machine, read from the `PARHO_PRIVATE_KEY` environment variable. It must
  **never** be committed, put in the APK, in `--dart-define`, or logged. Store
  it in a secret manager / offline signer.
- **Release keystore** (`*.jks`) + `android/key.properties` → on your build
  machine only; both are git-ignored.

### 6. Hosting the catalog + packages
1. Build/sign each package: `dart run tool/sign_package.dart ...` (see
   **Production deployment guide**). It prints the `sha256` + `signature`.
2. Assemble `catalog.json` = `{ "manifestVersion":1, "packages":[ ...entries ] }`.
3. Upload `catalog.json` and every `*.zip` to a **static HTTPS host / CDN**
   (the app refuses non-HTTPS URLs). Point `PARHO_CATALOG_URL` at `catalog.json`
   and make sure the manifest `downloadUrl`s are the HTTPS URLs of the ZIPs.

## Replacing the demo content

All sample content lives in `lib/data/seed/demo_content.dart` as trilingual
data (`T(en, ur, ps)`), seeded on first launch and marked `isDemo = true`. To
ship real curriculum:

1. Replace the `_catalog` data (or load it from your own licensed source).
2. Bump `_seedVersion` so the database re-seeds.
3. The schema and UI need no changes.

## Content package format (adding lessons, quizzes, languages)

Content is imported through a single, validated pipeline
(`ContentImporter` → `ContentValidator` → SQLite). A package is a JSON object:

```jsonc
{
  "grade": 6,                       // 1–8
  "province": "Khyber Pakhtunkhwa", // optional
  "isDemo": true,
  "subjects": [
    {
      "code": "math",              // stable subject code
      "emoji": "➕",
      "name": { "en": "Mathematics", "ur": "ریاضی", "ps": "ریاضي" },
      "units": [
        {
          "title": { "en": "Geometry", "ur": "…", "ps": "…" },
          "lessons": [
            {
              "title":       { "en": "Shapes", "ur": "…", "ps": "…" },
              "objective":   { "en": "…", "ur": "…", "ps": "…" },
              "explanation": { "en": "…", "ur": "…", "ps": "…" },
              "example":     { "en": "…", "ur": "…", "ps": "…" },
              "illustration": "🔺",
              "questions": [
                {
                  "prompt":  { "en": "Sides of a triangle?", "ur": "…", "ps": "…" },
                  "options": [ {"en":"3","ur":"۳","ps":"۳"}, {"en":"4","ur":"۴","ps":"۴"} ],
                  "correctIndex": 0        // 0-based, must be within options
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
```

- **Add a lesson / quiz**: append to the relevant `units[].lessons[]` /
  `lessons[].questions[]`. Every text field is trilingual (`en` / `ur` / `ps`);
  missing `ur`/`ps` fall back to `en`.
- **Add a language**: extend `LText` and the ARB files (see below). Content
  fields are stored per language in the schema.
- **Validation**: `ContentValidator` rejects bad grade ranges, empty
  subjects/units, missing titles/prompts, too-few/too-many options, and
  out-of-range `correctIndex` — an invalid package throws
  `ContentValidationException` and writes nothing (safe rejection).
- **Import at runtime**: `ContentImporter(db).importJson(jsonText,
  replaceGrade: true)`, or install a versioned package via
  `ContentPackageService.install(...)`.

## Connecting a real AI Tutor backend (later)

The app never holds an AI provider key. The intended flow is
`Flutter → your secure backend → AI provider`:

1. Implement `TutorApiClient` (in `lib/features/ai_tutor/tutor_api.dart`) to
   `POST` `TutorApiRequest.toJson()` to **your** HTTPS endpoint and parse the
   reply with `TutorApiResponse.fromJson(...)`.
2. Point `tutorServiceProvider` at
   `RemoteTutorService(apiClient: yourClient, cache: TutorResponseCache())`.
3. No UI changes are needed. Safety and cost-control (local knowledge/cache
   first, minimal payloads) already run before any call, and the app falls back
   to the offline `MockTutorService` whenever the backend isn't configured.

## Content package delivery (Phase 6)

Phase 6 wires a real, secure, offline-first delivery pipeline for downloadable
content packages. Installed content always works offline; the network is used
only to discover and fetch new/updated packages.

```
catalog manifest ─► download (Wi-Fi, resumable) ─► SHA-256 checksum ─►
Ed25519 signature ─► validate structure ─► import into SQLite ─► mark installed
```

### Package archive format

A package is a ZIP with a predictable layout:

```
package.zip
  manifest.json                 # packageId, grade, subject, language, version, isDemo, province
  content/
    subjects.json               # [{ id, code, emoji, name{en,ur,ps} }]
    units.json                  # [{ id, subjectId, title{…} }]
    lessons.json                # [{ id, unitId, title, objective, explanation, example, illustration }]
    questions.json              # [{ id, lessonId, prompt, options[…], correctIndex }]
  audio/                        # optional compressed offline audio
  images/                       # optional images
```

The importer (`PackageZipReader`) requires `manifest.json` and the four
`content/*.json` files, reassembles them into a `ContentPackage`, and runs the
Phase 5 `ContentValidator`. Malformed packages are rejected before any DB write.

### Catalog manifest format

The catalog endpoint returns JSON describing available packages:

```jsonc
{
  "manifestVersion": 1,
  "generatedAt": "2026-01-01T00:00:00Z",
  "packages": [
    {
      "packageId": "grade5_math_ur_v1",
      "grade": 5, "subject": "math", "language": "ur",
      "version": "1", "contentVersion": 1,
      "sizeBytes": 24576,
      "downloadUrl": "https://cdn.example.org/grade5_math_ur_v1.zip",
      "sha256": "<hex>",
      "signature": "<base64 Ed25519 signature over the archive bytes>",
      "releaseDate": "2026-01-01",
      "minimumAppVersion": "1.0.0"
    }
  ]
}
```

### Signing process & public/private key architecture

Packages are signed with **Ed25519**. The split is strict:

- The **private signing key lives only on your build/release infrastructure** —
  never in this repository or the shipped APK.
- The app ships **only the public verification key** (set once in
  `lib/core/config/catalog_config.dart` → `CatalogConfig.publicKeyBase64`).
- Before install, the app verifies **both** the SHA-256 checksum (integrity)
  and the Ed25519 signature (authenticity). If either fails, the package is
  **not installed** and the download is deleted. A working installed version is
  never replaced by an unverified or corrupt download.

To sign a production package (outside the app), compute `sha256(package.zip)`
and `ed25519_sign(private_key, package.zip)`, then publish both in the manifest.
Keep the private key in a secret manager / HSM — **never commit it**.

### Development mock host vs. production server

Because a production server may not exist yet, the app ships a **development
mock host** (`MockContentHost`) that builds and **really signs** an original
demo package (Grade 5 Mathematics — Fractions, 3 lessons, 11 questions, en/ur/ps)
with a per-run dev key, then serves it through the same interfaces as production.
This exercises the full download→verify→install pipeline entirely offline.

This is **not** a production server. Switch to a real catalog by editing the
single config point:

```dart
// lib/core/config/catalog_config.dart (or override catalogConfigProvider in main)
const CatalogConfig(
  useMockHost: false,
  catalogUrl: 'https://cdn.example.org/catalog.json',
  publicKeyBase64: '<your Ed25519 public key>',
  appVersion: '1.0.0',
);
```

`MockPackageManifestCatalog` ↔ `RemotePackageManifestCatalog` and the mock ↔
real download clients are interchangeable — the Content Packages UI never
changes.

### Wi-Fi, storage, updates and offline behavior

- **Wi-Fi-only = ON by default**; mobile-data downloads are OFF by default. On
  mobile data the app shows "Wi-Fi required for content download" instead of
  silently using data. Large packages confirm size before downloading.
- Downloads report progress, **resume** from a saved partial, **retry**
  transient failures, and can be **canceled**.
- **Storage pre-check (real device free space).** Before a download starts, the
  app queries actual free space via `disk_space_plus` (a `statfs`-style query on
  the app's storage — no extra Android permission) through the `StorageProbe`
  abstraction (`DeviceStorageProbe`, MB→bytes). It requires room for the package
  **plus a temporary-download copy plus a safety margin**
  (`requiredFreeBytes = 2 × packageSize + 5 MB`). If space is insufficient the
  download is blocked with "Not enough storage space to download this lesson
  package." and the installed working package is never touched. If free space
  can't be read on a platform, it returns `null` ("unknown") and the pre-check
  is safely skipped rather than guessing.
- If the catalog is unreachable, the Content Packages screen shows
  "Offline — installed content is available" and installed packages keep working.

### Testing downloads & offline installation

- `flutter test test/phase6_test.dart` covers manifest parsing, checksum and
  Ed25519 signature (pass/fail/wrong-key), version comparison, Wi-Fi/offline/
  storage gating, download + resume + retry, install, and **rollback** (a failed
  update keeps the previous version).
- `flutter test test/content_packages_widget_test.dart` drives the UI:
  Available → Download → (verify) → Installed, then confirms the content is
  imported into the local database.
- `flutter test test/phase7_1_storage_test.dart` covers the storage pre-check:
  enough space installs, insufficient space blocks (and never destroys the
  installed package), unknown space (null) skips the check, plus the
  `DeviceStorageProbe` MB→bytes conversion and the required-space /
  temp-overhead calculation.

## Production deployment guide (Phase 7)

This is the step-by-step for shipping real signed content and offline audio.
**Never commit the private key.**

### 1. Create a package

Lay out the package directory in the production format:

```
grade5_math_ur_v1/
  manifest.json                 # { packageId, grade, subject, language, version, isDemo:false }
  content/subjects.json
  content/units.json
  content/lessons.json          # a lesson may set "audio": "audio/lesson_100.mp3"
  content/questions.json
  audio/lesson_100.mp3          # compressed speech (mono, ~32–48 kbps MP3)
  images/…                      # optional
```

Keep audio small: mono, low-bitrate MP3 sized for fast download and low storage.
See `lib/data/content/demo_package_builder.dart` for a complete worked example.

### 2–5. Generate manifest, checksum, sign — one command

```bash
# One-time: create the signing key pair.
dart run tool/generate_keys.dart
#   → prints PUBLIC key (ships in the app) and PRIVATE key SEED (store securely)

# Package + SHA-256 + Ed25519 signature + manifest entry:
export PARHO_PRIVATE_KEY='<base64 private seed from a secret manager>'
dart run tool/sign_package.dart \
  --dir build/packages/grade5_math_ur_v1 \
  --out build/packages/grade5_math_ur_v1.zip \
  --package-id grade5_math_ur_v1 --grade 5 --subject math \
  --language ur --version 1 \
  --url https://cdn.example.org/parho-kp/grade5_math_ur_v1.zip
#   → writes the .zip and prints the manifest entry (sha256 + signature)
```

`sign_package.dart` reads the private key **only** from `PARHO_PRIVATE_KEY` — it
is never stored in source, logs, or the repo.

**Where the private key lives:** a secret manager (e.g. cloud KMS/Secrets) or an
offline signing machine. It must never enter the repository, the APK, config
files, or logs. The app ships **only the public key**.

### 6–7. Upload catalog.json and package ZIPs

Assemble `catalog.json` from the printed manifest entries:

```json
{ "manifestVersion": 1, "packages": [ /* one entry per package */ ] }
```

Upload `catalog.json` and every `*.zip` to any static HTTPS host / CDN.

### 8. How the app verifies packages

On download the app: fetches the manifest → downloads the ZIP (Wi-Fi, resumable)
→ verifies **SHA-256** → verifies the **Ed25519 signature** with the bundled
public key → validates the ZIP structure → imports into SQLite (transactional)
→ stores audio to disk → marks installed → deletes the temp download. If any
step fails, nothing is installed and the previous version keeps working.

Point the app at production via the single config point
(`lib/core/config/catalog_config.dart` → `CatalogConfig.production`), e.g.:

```bash
flutter build apk --release \
  --dart-define=PARHO_CATALOG_URL=https://cdn.example.org/parho-kp/catalog.json \
  --dart-define=PARHO_PUBLIC_KEY=<base64 public key>
# and set useMockHost:false for the production config in main().
```

### 9. Test offline learning

1. Install a package over Wi-Fi from **Content Packages**.
2. Enable **Offline Mode** in Settings (or turn off the network).
3. Open a lesson → read it → tap **Listen** (plays the downloaded audio, or
   falls back to TTS) → take the quiz → save progress → view progress.
   Everything works with no internet.

### 10. Build the release APK / App Bundle

**Release signing.** The release build reads its keystore from
`android/key.properties`, which is **git-ignored and must never be committed**.
Copy the template and fill in real values (see `android/key.properties.example`):

```properties
storeFile=/absolute/path/to/parho-kp-upload.jks
storePassword=…
keyAlias=upload
keyPassword=…
```

Generate the keystore once, outside the repo:

```bash
keytool -genkey -v -keystore ~/parho-kp-upload.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

When `key.properties` is absent (e.g. `flutter run`, CI without secrets) the
build falls back to debug signing so development still works — but a Play
submission **requires** the release keystore.

**Build commands** (need the Android SDK — see **Building the APK**):

```bash
# APK (sideload / direct install):
flutter build apk --release \
  --dart-define=PARHO_CATALOG_URL=https://cdn.example.org/parho-kp/catalog.json \
  --dart-define=PARHO_PUBLIC_KEY=<base64 public key>
#   → build/app/outputs/flutter-apk/app-release.apk

# App Bundle (Google Play):
flutter build appbundle --release \
  --dart-define=PARHO_CATALOG_URL=https://cdn.example.org/parho-kp/catalog.json \
  --dart-define=PARHO_PUBLIC_KEY=<base64 public key>
#   → build/app/outputs/bundle/release/app-release.aab
```

## Release security requirements

- **No secrets in the repo.** Private signing keys (`*.jks`), `key.properties`,
  `*.p12/*.pem`, and `.env` files are git-ignored; only the app's **public**
  Ed25519 key ships (via `--dart-define`).
- **HTTPS only.** The production catalog + download clients refuse any non-HTTPS
  URL.
- **Verified installs only.** Packages are SHA-256 + Ed25519 verified before
  import; a failed/corrupt/insufficient-storage install never destroys the
  installed version (transactional rollback).
- **Safe extraction.** Archive entries with absolute paths or `..` traversal
  ("zip slip") are rejected, and audio extraction is contained to the store dir.
- **Minimal permissions.** Only `INTERNET` + `ACCESS_NETWORK_STATE`; no
  location/camera/contacts/microphone/storage.

## Sync (low-bandwidth, offline-first)

Learning signals are saved locally first, then queued in `sync_queue` for
best-effort upload (`SyncService`). Only anonymous payloads (lesson id, score,
achievement code) are queued — never names or school. Rows move through
`pending → synced / failed` with retry, and **data is never dropped**. Provide a
real `SyncClient` and call `flush()` when a backend exists; with the default
`NoopSyncClient` the app is fully usable offline.

## Localization

Add or edit strings in `lib/l10n/app_en.arb` (template) and the `ur` / `ps`
files, then run `flutter gen-l10n`. Every user-facing string is looked up via
`AppLocalizations`.

## Privacy & security

- **No secrets in source**: no API keys or credentials are embedded; a secure
  backend holds any keys.
- **Minimal data**: only name, grade, language and optional school/class are
  stored — **never** CNIC, address, GPS, phone or family details.
- **Untrusted input is validated**: imported content and network responses are
  validated before use; the app degrades gracefully instead of crashing.
- **Android permissions**: the core app requests no dangerous permissions (no
  location, camera, contacts or microphone).
