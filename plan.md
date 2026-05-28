# MindGate — Project Plan

## What is MindGate?
A Flutter app that intercepts the user before they open Instagram, shows a timed mindfulness screen, and tracks whether they chose to go back or proceed. Tagline: **"Think Before You Scroll."**

---

## Current Status (v1.0.0)

### Done
- [x] Onboarding screen (first-launch flow)
- [x] Home dashboard — toggle protection, set delay duration (1–30s), view stats
- [x] Intervention screen — breathing animation, calming messages, countdown timer, Go Back / Proceed buttons
- [x] Stats tracking — total interceptions, changed mind, proceeded, mindfulness score, streak
- [x] Dark theme (portrait-locked)
- [x] Local persistence via `shared_preferences`
- [x] GitHub repo created: https://github.com/Shivam-Andotra/nomore-insta
- [x] Android APK release: https://github.com/Shivam-Andotra/nomore-insta/releases/tag/v1.0.0
- [x] All deprecation warnings fixed (withOpacity → withValues)

---

## Planned Features

### v1.1 — History & Insights
- [ ] SQLite history log (sqflite dep already added) — store timestamp, action (back/proceed), delay used
- [ ] Daily/weekly summary chart on home screen
- [ ] Best streak display alongside current streak

### v1.2 — App Blocker Integration
- [ ] Android `UsageStatsManager` integration to auto-detect Instagram launch
- [ ] Foreground service to intercept app opens without manual "Test" button
- [ ] Notification reminder if protection is turned off for >1 day

### v1.3 — Customization
- [ ] Custom calming messages (user can add/edit their own)
- [ ] Choose which apps to protect (not just Instagram)
- [ ] Custom background color/gradient on intervention screen

### v1.4 — Gamification
- [ ] Weekly challenges (e.g., "7 days without proceeding")
- [ ] Milestone badges (10, 50, 100 times changed mind)
- [ ] Share streak card to social media

### v2.0 — Cross-Platform
- [ ] iOS support (Screen Time API integration)
- [ ] Widget for home screen showing streak
- [ ] Cloud sync for stats (optional, opt-in)

---

## Known Issues / Tech Debt
- `sqflite` is declared in pubspec but not yet used — history log will use it
- `lib/core/theme/constant.dart` is empty (created but unused)
- The "Test Intervention Screen" button simulates interception manually; real auto-intercept requires Android accessibility/usage stats service
- No `.gitignore` for the `build/` folder (build artifacts not excluded from git)

---

## Download
Latest APK: https://github.com/Shivam-Andotra/nomore-insta/releases/tag/v1.0.0
