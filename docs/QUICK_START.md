# Quick Start Guide - E-Baladya Notifications

Get the notification system up and running in 5 minutes.

## Prerequisites

- Flutter app installed on device/emulator
- Python 3.8+ installed
- Firebase project credentials

## Step 1: Setup Firebase Credentials (2 minutes)

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select project: **e-baladya-2026**
3. Click: **Project Settings** → **Service Accounts** → **Generate New Private Key**
4. Save the downloaded JSON file as `firebase_credentials.json` in project root:
   ```
   c:\Users\DELL\Documents\GitHub\Mobile_dev_E_Baladya\firebase_credentials.json
   ```

## Step 2: Setup Python Environment (2 minutes)

Open PowerShell in project root and run:

```powershell
# Create virtual environment
python -m venv venv

# Activate it
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

## Step 3: Start Flask Backend (1 minute)

```powershell
python notification_service.py
```

You should see:
```
Running on http://0.0.0.0:5000
```

## Step 4: Test It Works

In a new PowerShell window, send a test notification:

```powershell
curl -X POST http://localhost:5000/api/notify/user `
  -H "Content-Type: application/json" `
  -d '{
    "user_id": 1,
    "title": "Test Notification",
    "body": "If you see this, it works!",
    "type": "booking"
  }'
```

Expected response:
```json
{
  "success": true,
  "message": "Notification sent successfully",
  "message_id": "..."
}
```

## Step 5: Run Flutter App

```bash
flutter pub get
flutter run
```

User ID 1 is already in the seed data. The app will:
1. Initialize Firebase
2. Subscribe user to FCM topic
3. Start listening for notifications
4. Receive your test notification
5. Display it in the notifications list

**Click the notification** → should navigate to My Bookings page (since type = "booking")

---

## Common Curl Commands

### Send Booking Reminder
```powershell
curl -X POST http://localhost:5000/api/notify/user `
  -H "Content-Type: application/json" `
  -d '{
    "user_id": 1,
    "title": "Booking Reminder",
    "body": "Your booking is tomorrow at 10:00 AM",
    "type": "booking"
  }'
```

### Send Request Update
```powershell
curl -X POST http://localhost:5000/api/notify/user `
  -H "Content-Type: application/json" `
  -d '{
    "user_id": 1,
    "title": "Request Status Update",
    "body": "Your request has been approved",
    "type": "request"
  }'
```

### Send to Multiple Users
```powershell
curl -X POST http://localhost:5000/api/notify/users `
  -H "Content-Type: application/json" `
  -d '{
    "user_ids": [1, 2, 3],
    "title": "System Update",
    "body": "New features available",
    "type": "general"
  }'
```

### Broadcast Announcement
```powershell
curl -X POST http://localhost:5000/api/notify/topic `
  -H "Content-Type: application/json" `
  -d '{
    "topic": "announcements",
    "title": "Important Notice",
    "body": "Please read this",
    "type": "general"
  }'
```

### Check Health
```powershell
curl http://localhost:5000/api/health
```

---

## Test Scenarios

### Scenario 1: App Open
1. Keep app on notifications page
2. Send notification from curl
3. See it appear instantly
4. Tap it to navigate

### Scenario 2: App Closed
1. Close app
2. Send notification
3. Open app
4. Notification appears in notifications list
5. Check SQLite: `SELECT * FROM notifications WHERE user_id = 1`

### Scenario 3: Different Types
- **type: "booking"** → Navigate to My Bookings
- **type: "request"** → Navigate to Tracking
- **type: "document"** → Navigate to Digital Versions
- **type: "service"** → Navigate to Home
- **type: "general"** → Stay on Notifications

---

## Troubleshooting

**"Connection refused" error**
- Flask not running. Start it with: `python notification_service.py`

**"ModuleNotFoundError: No module named 'firebase_admin'"**
- Dependencies not installed: `pip install -r requirements.txt`

**"Credentials file not found"**
- Download `firebase_credentials.json` from Firebase console
- Place in project root (same level as pubspec.yaml)

**Notification not received**
- Check Flask logs for errors
- Verify user_id = 1 is logged in on app
- Check internet connection
- Restart Flask and app

**Navigation not working**
- Check notification type is correct (booking, request, document, service, general)
- Verify route exists in lib/commons/app_routes.dart

---

## Documentation Files

- **IMPLEMENTATION_SUMMARY.md** - Complete overview
- **NOTIFICATIONS_SETUP.md** - Detailed setup guide
- **TESTING_NOTIFICATIONS.md** - Testing guide with examples

---

## What's Running

After setup, you have:

**Flutter App**
- Firebase Cloud Messaging enabled
- Receiving and storing notifications
- Displaying notifications with auto-navigation
- SQLite database with notification table

**Flask Backend** (http://localhost:5000)
- `/api/notify/user` - Send to single user
- `/api/notify/users` - Send to multiple users
- `/api/notify/topic` - Broadcast to topic
- `/api/health` - Check status
- `/api/docs` - View documentation

**Firebase Cloud Messaging**
- Routing messages from backend to mobile devices
- Managing user subscriptions and topics

---

## Next: Integration

To integrate with your system:

1. **Send from your database:**
```python
import requests

def notify_user(user_id, title, body, notification_type):
    requests.post('http://localhost:5000/api/notify/user', json={
        'user_id': user_id,
        'title': title,
        'body': body,
        'type': notification_type
    })

# Use it
notify_user(1, 'Booking Confirmed', 'Your booking is confirmed', 'booking')
```

2. **Schedule periodic messages:**
   - Edit `run_scheduler()` in `notification_service.py`
   - Add your scheduled tasks
   - They run in background automatically

3. **Add authentication:**
   - Protect Flask endpoints with API keys
   - Only admins can send notifications
   - See NOTIFICATIONS_SETUP.md for examples

---

**Ready to go!** 🚀

Send your first notification and watch it work! 📱✨
