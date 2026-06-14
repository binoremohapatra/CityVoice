# 📢 CityVoice — Civic Issue Reporting App (Flutter)

> A Flutter mobile app for citizens to report, view, and track civic issues on an interactive map. Features location-based issue submission with photo support, complaint status tracking, and a glassmorphism UI.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.3+-0175C2?logo=dart)](https://dart.dev)

---

## ✨ Features

- **Authentication** — Google Auth + role selection (Citizen / Official)
- **Report Issue** — Category selection, urgency level, location picker, photo/media capture, review & submit flow
- **Interactive Map** — View all reported issues on map with filter panel, location search, and complaint preview sheet
- **Complaint Feed** — Personal complaint list with filter chips and analytics bottom sheet
- **Complaint Detail** — Status timeline (`SUBMITTED → ASSIGNED → INVESTIGATION → RESOLVED`), metadata, location card, comment system, related complaints
- **Notifications** — Filterable notification feed with settings
- **User Profile** — Gamification panel, theme preview, settings
- **Splash Screen** — Animated launch screen

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter / Dart |
| Platforms | Android, iOS, Web, Linux, macOS, Windows |
| State | Widget-level state (Stateful widgets) |
| Map | Interactive map screen with location delegates |
| Media | Camera / gallery via image picker |
| UI | Custom theme, glassmorphism, custom tab/app bars |

## 🚀 Run Locally

```bash
git clone https://github.com/binoremohapatra/CityVoice.git
cd CityVoice
flutter pub get
flutter run
```

## 📁 Project Structure

```
lib/
├── main.dart
├── routes/app_routes.dart
├── theme/app_theme.dart
├── presentation/
│   ├── authentication_screen/
│   ├── citizen_dashboard/
│   ├── report_issue_flow/
│   ├── interactive_map_screen/
│   ├── complaint_details_tracking/
│   ├── my_complaints_feed/
│   ├── notifications_screen/
│   ├── user_profile_screen/
│   └── splash_screen/
└── widgets/           Shared UI components
```

---

**Built by [Binore Mohapatra](https://github.com/binoremohapatra)**
