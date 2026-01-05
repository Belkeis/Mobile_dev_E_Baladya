# Setup Guide for Running E-Baladya Project

This guide explains how to set up and run the E-Baladya project on a fresh system.

## Project Overview

E-Baladya is a **Flutter mobile application** with an integrated **Python backend service** for handling Firebase Cloud Messaging (FCM) notifications.

## Prerequisites

- **Flutter SDK** (v3.5.4+) - [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (comes with Flutter)
- **Python 3.7+** - [Install Python](https://www.python.org/downloads/)
- **Git** - [Install Git](https://git-scm.com/)
- **Android Studio** or **Xcode** (depending on target platform)

## Step 1: Clone the Repository

```bash
git clone <repository-url>
cd Mobile_dev_E_Baladya
```

## Step 2: Flutter Setup

### Install Flutter Dependencies

```bash
flutter pub get
```

### Configure Firebase

1. Copy Firebase credentials to the appropriate location:
   - Android: `android/app/google-services.json` (already configured)
   - iOS: Download from Firebase Console and add to project
   - Web: Firebase is auto-configured in `web/` folder

2. Verify Firebase configuration in `lib/firebase_options.dart`

### Run the Flutter App

```bash
# List connected devices
flutter devices

# Run the app
flutter run

# Or run on a specific device
flutter run -d <device_id>
```

## Step 3: Python Backend Setup

The Python backend handles push notifications and runs separately from the Flutter app.

### Create Virtual Environment

**Windows:**
```bash
cd backend
python -m venv venv
venv\Scripts\activate
```

**macOS/Linux:**
```bash
cd backend
python3 -m venv venv
source venv/bin/activate
```

### Install Python Dependencies

```bash
pip install -r requirements.txt
```

### Configure Environment Variables

Create a `.env` file in the `backend/` folder:

```bash
# Firebase credentials
FIREBASE_KEY_PATH=path/to/firebase_credentials.json

# Backend configuration
FLASK_ENV=development
FLASK_DEBUG=True
SERVER_PORT=5000
```

### Run the Backend Service

```bash
python notification_service.py
```

The service will start on `http://localhost:5000`

## Step 4: Test the Integration

### Test Push Notifications

With the Flask backend running, send a test notification:

**Using PowerShell (Windows):**
```powershell
$body = @{
    user_id = 1
    title   = "Test Notification"
    body    = "If you see this, notifications work!"
    type    = "booking"
} | ConvertTo-Json

Invoke-RestMethod `
  -Uri "http://localhost:5000/api/notify/user" `
  -Method POST `
  -ContentType "application/json" `
  -Body $body
```

**Using cURL (Mac/Linux):**
```bash
curl -X POST http://localhost:5000/api/notify/user \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "title": "Test Notification",
    "body": "If you see this, notifications work!",
    "type": "booking"
  }'
```

## Directory Structure

```
Mobile_dev_E_Baladya/
├── lib/                    # Flutter app source code
├── backend/                # Python notification service
│   ├── notification_service.py
│   ├── requirements.txt
│   └── venv/              # (Local only - not in git)
├── config/                # Configuration files
├── docs/                  # Documentation
├── android/               # Android platform code
├── ios/                   # iOS platform code
├── web/                   # Web platform code
├── pubspec.yaml           # Flutter dependencies
└── .gitignore             # Git ignore rules
```

## Important Notes

### Virtual Environment (`venv`)
- The `venv/` folder is **NOT** included in the repository
- Each developer/environment creates its own using `python -m venv venv`
- Dependencies are installed from `requirements.txt`
- This keeps the repository size small and prevents compatibility issues

### Firebase Credentials
- Ensure `firebase_credentials.json` is in `config/` folder
- **NEVER commit sensitive credentials to public repositories**
- Use environment variables or `.env` files instead

### Running Both Services
For full functionality, you need to run both simultaneously:

**Terminal 1 (Flutter App):**
```bash
flutter run
```

**Terminal 2 (Python Backend):**
```bash
cd backend
source venv/bin/activate  # or venv\Scripts\activate on Windows
python notification_service.py
```

## Troubleshooting

### Flutter Issues
- **"Flutter not found"**: Ensure Flutter is added to PATH
- **"Android SDK not found"**: Run `flutter doctor` for details
- **Pub errors**: Try `flutter clean` then `flutter pub get`

### Python Issues
- **"ModuleNotFoundError"**: Ensure virtual environment is activated
- **Port 5000 in use**: Change port in `notification_service.py`
- **Firebase auth errors**: Verify credentials path in `.env`

### Device Connection
```bash
# List available devices
flutter devices

# Kill all running emulators
adb kill-server

# Restart adb
adb start-server
```

## Running Tests

```bash
# Flutter tests
flutter test

# Python backend tests (if available)
cd backend
pytest
```

## Building for Production

```bash
# Android APK
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

## Documentation

- [Start Here](START_HERE.md) - Quick overview
- [Quick Start](QUICK_START.md) - Step-by-step setup
- [Notifications Setup](NOTIFICATIONS_SETUP.md) - FCM configuration
- [Implementation Summary](IMPLEMENTATION_SUMMARY.md) - Technical details
- [Testing Notifications](TESTING_NOTIFICATIONS.md) - Testing guide

## Support

For issues or questions:
1. Check the [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md) for all docs
2. Review [CODE_CHANGES.md](CODE_CHANGES.md) for implementation details
3. Check [VISUAL_SUMMARY.md](VISUAL_SUMMARY.md) for architecture overview

---

**Last Updated:** January 5, 2026
