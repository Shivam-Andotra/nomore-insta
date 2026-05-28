# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

MindGate is a Flutter app (dark-theme only, portrait-locked) that intercepts the user before they open Instagram, shows a timed mindfulness screen, and tracks whether they chose to go back or proceed.

## Commands

```bash
flutter run                        # run on connected device/emulator
flutter run -d windows             # run on Windows desktop
flutter build apk                  # build Android APK
flutter test                       # run all tests
flutter test test/widget_test.dart # run a single test file
flutter analyze                    # lint
```

## Architecture

No state management library — state is local `setState` + the static `AppPreferences` class.

**Data layer** (`lib/data/preferences.dart`)  
`AppPreferences` is a static wrapper around `shared_preferences`. It is initialized once in `main()` and accessed synchronously everywhere via getters. All user settings, stats, and streaks live here. `sqflite` is a declared dependency but not yet used.

**Routing** (`lib/main.dart`)  
Named routes only: `/onboarding`, `/home`, `/intervention`, `/settings`. The start route is decided at launch based on `AppPreferences.onboardingComplete`.

**Intervention flow**  
`InterventionScreen` is the core feature. It starts a 100ms-tick timer on `initState`, logs the interception immediately via `AppPreferences.logInterception()`, and unlocks the "Proceed" button only after the delay elapses. "Go Back" is always active and calls `logChangedMind()` (increments streak); "Proceed" calls `logProceeded()` (resets streak).

**Theme**  
Dark theme only — defined in `AppTheme.darkTheme` and registered at the `MaterialApp` level. Colors are all static consts in `AppColors`. Never add a light theme or conditional theming.

**Conventions**
- Screens go in `lib/screens/<name>/<name>_screen.dart`
- Shared widgets go in `lib/widgets/`
- All persistent reads/writes go through `AppPreferences` — do not use `SharedPreferences` directly elsewhere
- Use `AppColors` constants for all colors — no inline `Color(...)` values in UI code
