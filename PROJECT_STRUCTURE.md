# E-Baladya Project Structure

## Overview
This is a Flutter mobile application for E-Baladya with Firebase integration and push notification support.

## Directory Structure

```
e_baladya/
├── lib/                           # Flutter application source code
│   ├── main.dart                 # Application entry point
│   ├── firebase_options.dart     # Firebase configuration
│   ├── commons/                  # Common utilities and constants
│   ├── data/                     # Data layer (models, repositories)
│   ├── logic/                    # Business logic and state management
│   ├── utils/                    # Helper functions and utilities
│   ├── views/                    # UI screens and widgets
│   └── i18n/                     # Internationalization files
│
├── backend/                      # Python backend services
│   ├── notification_service.py   # Firebase notification service
│   └── requirements.txt          # Python dependencies
│
├── config/                       # Configuration files
│   ├── firebase.json             # Firebase project config
│   ├── firebase_credentials.json # Firebase service account
│   ├── analysis_options.yaml     # Dart analyzer rules
│   └── .env.example              # Environment variables template
│
├── docs/                         # Documentation
│   ├── README.md                 # Main project documentation
│   ├── START_HERE.md             # Quick start guide
│   ├── QUICK_START.md            # Setup instructions
│   ├── DOCUMENTATION_INDEX.md    # Documentation index
│   ├── IMPLEMENTATION_SUMMARY.md # Implementation details
│   ├── CODE_CHANGES.md           # Track of changes made
│   ├── FCM_imlimentation.md      # FCM setup details
│   ├── fcm_integration.md        # FCM integration guide
│   ├── NOTIFICATIONS_README.md   # Notification system info
│   ├── NOTIFICATIONS_SETUP.md    # Notification setup guide
│   ├── TESTING_NOTIFICATIONS.md  # Testing notifications
│   ├── VISUAL_SUMMARY.md         # Visual project summary
│   └── presentation.html         # Project presentation
│
├── assets/                       # Application assets
│   ├── fonts/                    # Custom fonts
│   ├── icons/                    # App icons
│   └── images/                   # Images and illustrations
│
├── android/                      # Android platform code
│   ├── app/                      # Android app module
│   └── gradle/                   # Gradle configuration
│
├── ios/                          # iOS platform code
│   ├── Runner/                   # iOS app target
│   └── RunnerTests/              # iOS tests
│
├── web/                          # Web platform code
│   ├── index.html                # Web entry point
│   └── manifest.json             # Web app manifest
│
├── windows/                      # Windows platform code
├── linux/                        # Linux platform code
├── macos/                        # macOS platform code
│
├── test/                         # Flutter tests
│   └── widget_test.dart          # Widget tests
│
├── build/                        # Build output (generated, ignore)
│
├── pubspec.yaml                  # Flutter dependencies
├── pubspec.lock                  # Locked dependency versions
├── .gitignore                    # Git ignore rules
├── .metadata                     # Flutter metadata
├── analysis_options.yaml         # Dart analysis config
├── flutter_plugins_dependencies  # Plugin dependencies
└── .flutter-plugins-dependencies # Plugin info
```

## Key Directories Explained

### `/lib` - Application Source
Main Flutter application code organized by clean architecture principles:
- **commons/**: Shared constants and utilities
- **data/**: Data models and repositories
- **logic/**: State management (GetX, Provider, etc.)
- **utils/**: Helper functions
- **views/**: UI components and screens
- **i18n/**: Multi-language support files

### `/backend` - Backend Services
Python service for handling notifications independently:
- `notification_service.py`: Flask/FastAPI service for FCM notifications
- `requirements.txt`: Python dependencies

### `/config` - Configuration
All configuration files in one place:
- Firebase credentials and settings
- Dart analyzer rules
- Environment variables template

### `/docs` - Documentation
Complete project documentation and guides for setup, implementation, and testing.

### `/assets` - Static Resources
Images, fonts, and icons used throughout the application.

### Platform-Specific Code
- `/android`: Android-specific code (Kotlin/Java)
- `/ios`: iOS-specific code (Swift/Objective-C)
- `/web`: Web-specific code (HTML/CSS/JS)
- `/windows`, `/linux`, `/macos`: Desktop platform code

## Getting Started

1. Read [docs/START_HERE.md](docs/START_HERE.md)
2. Follow [docs/QUICK_START.md](docs/QUICK_START.md)
3. Check [docs/NOTIFICATIONS_SETUP.md](docs/NOTIFICATIONS_SETUP.md) for notification setup

## Development

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Build release
flutter build apk    # Android
flutter build ios    # iOS
flutter build web    # Web
```

## Backend Setup

```bash
cd backend
pip install -r requirements.txt
python notification_service.py
```

---
Last updated: January 5, 2026
