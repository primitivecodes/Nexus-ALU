**NexusALU (Connect_ALU)**

A lightweight Flutter app for the ALU community to discover, post, and RSVP to events and opportunities. It demonstrates a simple local persistence strategy (using `SharedPreferences`), a staff approval workflow, and a set of UI screens for onboarding, feed discovery, posting, and RSVP management.

**Key Features**
- **Discover:** Browse approved events and opportunities in a categorized feed.
- **Post:** Create new event/opportunity posts that are stored locally and submitted for staff review.
- **Staff Review:** Staff can approve or reject pending posts from the Staff Dashboard.
- **RSVP:** Register for events with a simple ticket model persisted locally.
- **Auth (demo):** Sign-up and login flow backed by `SharedPreferences` (demo-only, not secure for production).

**Project Structure**
- `lib/`
	- `main.dart` — App entry point and initialization.
	- `theme.dart` — Colors and theme definitions used across the app.
	- `services/` — Business logic and persistence helpers:
		- `auth_service.dart` — Simple SharedPreferences-backed auth and `UserModel`.
		- `post_service.dart` — Manage `OpportunityModel` posts and user-submitted posts.
		- `rsvp_service.dart` — `RsvpModel` and RSVP persistence.
		- `mock_data.dart` — Seed data and models used for demo content.
	- `screens/` — UI screens (onboarding, login, main feed, event details, staff dashboard, etc.).

**Dependencies**
- Flutter SDK (stable channel recommended)
- `shared_preferences` (local persistence)

**Setup**
1. Install Flutter: https://flutter.dev/docs/get-started/install
2. From the project root (where `pubspec.yaml` lives), fetch packages:

```bash
flutter pub get
```

3. (Windows) If you need plugin support that requires symlinks, enable Developer Mode:

```powershell
start ms-settings:developers
```

**Build & Run**
- Run in Chrome (web):

```bash
flutter run -d chrome
```

- Run as Windows desktop app (if supported):

```bash
flutter run -d windows
```

Helpful commands:

```bash
flutter clean        # clear build artifacts
flutter pub get      # install dependencies
flutter test         # run tests
```

**Notes & Limitations**
- This project uses `SharedPreferences` for demo authentication and local state; it is not secure for real production authentication.
- The staff approval flow is simulated locally; replace `lib/services/*` implementations to integrate a backend API.

**Testing & Debugging**
- Use hot reload (`r`) while running to iterate quickly.
- DevTools links are printed when you run the app — open for widget inspection and profiling.

**Next Steps I can help with**
- Add a `CONTRIBUTING.md` and simple GitHub Actions CI for `flutter analyze` and `flutter test`.
- Replace `SharedPreferences` stubs with a REST API and authentication flow.

---
Generated and updated by the development assistant.
