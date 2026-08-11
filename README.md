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
  data/content/             # content models, validation, importer, packages
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

Release build: `flutter build apk --release` (add your own signing config in
`android/app/build.gradle.kts`).

> **Note on this repository's build environment:** this project was developed in
> a sandbox whose network policy blocks `dl.google.com` (the Android SDK and
> Google Maven / AndroidX host). `flutter analyze` and `flutter test` pass
> there, but `flutter build apk` cannot complete because the Android SDK and
> AndroidX dependencies can't be downloaded. Run the build command above on any
> machine or CI with normal access to `dl.google.com` and it will produce the
> APK at the path shown.

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
