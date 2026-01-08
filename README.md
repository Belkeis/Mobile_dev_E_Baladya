# Run Guide — E-Baladya (simple)

Short instructions to run the mobile app and the notification backend locally.

Prerequisites
- Flutter SDK installed and configured
- Android SDK / emulator or iOS device
- Python 3.8+ and pip
- Firebase project for `e-baladya-2026` (service account JSON)

Files you will need
- `lib/firebase_options.dart` is present (project configured)
- `android/app/google-services.json` is present for Android
- Add Firebase Admin service account JSON as `firebase_credentials.json` in repo root

1) Start the Flask notification backend
- Create & activate virtual environment and install dependencies:

```powershell
cd C:\Users\DELL\Documents\GitHub\Mobile_dev_E_Baladya
python -m venv venv
venv\Scripts\activate
pip install -r backend/requirements.txt
```

- Place Firebase Admin JSON in project root as `firebase_credentials.json` (download from Firebase Console → Project Settings → Service accounts)

- Run the backend:

```powershell
python backend/notification_service.py
```

The backend will run on `http://localhost:5000` by default.

2) Run the Flutter app
- Get packages and run:

```bash
flutter pub get
flutter run
```

- The seeded user (id=1) exists in local DB. When logged in, the app subscribes to topic `user_1`.

3) Send a test notification (example: user)
- From PowerShell (example uses topic `announcements`):

```powershell
Invoke-RestMethod `
  -Uri "http://localhost:5000/api/notify/user" `
  -Method POST `
  -ContentType "application/json" `
  -Body ( @{
      user_id = 1
      title   = "Booking Reminder"
      body    = "Your booking is tomorrow at 10:00 AM"
      type    = "booking"
  } | ConvertTo-Json -Depth 3 )
```

Or curl:

```bash
curl -X POST http://localhost:5000/api/notify/topic \
  -H "Content-Type: application/json" \
  -d '{"topic":"announcements","title":"Important Notice","body":"Please read this","type":"general"}'
```

4) Getting a real system notification (Android)
- To ensure a notification appears in the device notification bar even when the app is closed:
  - Backend must send an FCM message with a `notification` payload (title/body) and high priority; `notification_service.py` already sends notifications to topics by default.
  - For Android 8+ make sure a matching `channel_id` is used on server and the app creates that notification channel via `flutter_local_notifications`.
  - The app must register a background handler via `FirebaseMessaging.onBackgroundMessage` (already implemented in `lib/utils/fcm_service.dart`), and initialize `flutter_local_notifications` so data messages can be converted to system notifications when received in background/terminated states.

5) Verify
- Open the app (or keep it closed) and send the test message. If configured correctly, a system notification will appear on the device. Tapping it will open the app and navigate according to message `type`.

Troubleshooting
- No notification in system tray:
  - Check Flask logs and Firebase Admin errors
  - Ensure `firebase_credentials.json` is valid
  - Confirm the device has network and the FCM token was generated (check app logs)
  - For data-only messages some OEMs block background delivery; use `notification` payload for guaranteed system display

If you want, I can replace the repo `README.md` with this content or further shorten it.