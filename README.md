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
- **Accessibility**: large text, adjustable font size, ≥48dp touch targets,
  high contrast, screen-reader labels, light/dark/system themes.

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
  data/database/            # Drift tables, DAOs, connection
  data/seed/                # DEMO CONTENT (Grade 5, 3 languages)
  data/repositories/        # progress computation + data access
  data/providers.dart       # Riverpod providers
  features/<feature>/       # one folder per screen/feature
  shared/widgets/           # PrimaryButton, SubjectCard, QuizOption, …
  shared/services/          # TTS service
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

## Localization

Add or edit strings in `lib/l10n/app_en.arb` (template) and the `ur` / `ps`
files, then run `flutter gen-l10n`. Every user-facing string is looked up via
`AppLocalizations`.
