# E-Baladya Push Notifications Integration

Complete guide for implementing Firebase Cloud Messaging (FCM) notifications in the E-Baladya mobile app with a Flask backend.

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Flutter Setup](#flutter-setup)
- [Flask Backend Setup](#flask-backend-setup)
- [API Endpoints](#api-endpoints)
- [Usage Examples](#usage-examples)
- [Scheduled Notifications](#scheduled-notifications)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)

---

## Overview

This integration provides:
1. **Push Notifications** via Firebase Cloud Messaging (FCM)
2. **Local Message Storage** in SQLite database
3. **Automatic Navigation** to relevant screens on notification tap
4. **Flask Backend** for sending targeted notifications
5. **Scheduled Messages** sent at specified intervals
6. **Topic-based Messaging** for targeted user groups

### Features Implemented

✅ Send notifications when app is open or closed  
✅ Local storage of received messages  
✅ Automatic navigation to correct screen on tap  
✅ Flask backend for initiating messages  
✅ Periodic scheduled notifications  
✅ Topic-based and user-specific messaging  
✅ Support for different notification types (booking, request, document, etc.)

---

## Architecture

```
┌─────────────────┐
│  Firebase Console│
│  (FCM Project)  │
└────────┬────────┘
         │
    ┌────┴─────────────────────┐
    │                          │
┌───▼─────────┐        ┌──────▼──────┐
│  Flutter    │        │   Flask     │
│  Mobile App │◄──────►│   Backend   │
│             │        │  (REST API) │
└─────────────┘        └─────────────┘
    │                        │
    │                   ┌────▼────┐
    └──────────────────►│ Firebase │
                        │   FCM    │
                        └──────────┘
```

---

## Flutter Setup

### 1. Firebase Configuration (Already Done)

The app is configured with Firebase credentials:
- Project ID: `e-baladya-2026`
- Android, iOS, Web, and Desktop configurations included

### 2. FCM Service Integration

The `FCMService` class handles all FCM operations:

```dart
// Initialize in main.dart
await FCMService().initialize(notificationRepository);

// Subscribe user to personal topic
await FCMService().subscribeUserToPersonalTopic(userId);

// Unsubscribe on logout
await FCMService().unsubscribeUserFromPersonalTopic(userId);
```

### 3. Local Message Storage

Messages are automatically saved to SQLite:
- Table: `notifications`
- Fields: `id`, `user_id`, `message`, `type`, `timestamp`, `read`

### 4. Notification Types and Navigation

Notification types automatically route to appropriate screens:

| Type | Screen | Route |
|------|--------|-------|
| `booking` | My Bookings | `/my-bookings` |
| `request` | Tracking | `/tracking` |
| `document` | Digital Versions | `/digital-versions` |
| `service` | Home | `/home` |
| `general` | Notifications | `/notifications` |

---

## Flask Backend Setup

### 1. Installation

```bash
# Navigate to project root
cd c:\Users\DELL\Documents\GitHub\Mobile_dev_E_Baladya

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows
venv\Scripts\activate
# On macOS/Linux
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

### 2. Firebase Credentials

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project: `e-baladya-2026`
3. Go to **Project Settings** → **Service Accounts**
4. Click **Generate New Private Key**
5. Save the JSON file as `firebase_credentials.json` in project root

### 3. Environment Configuration

Create `.env` file in project root:

```env
FIREBASE_CREDENTIALS_PATH=firebase_credentials.json
FLASK_ENV=development
FLASK_DEBUG=True
```

### 4. Run the Flask Server

```bash
# Make sure virtual environment is activated
python notification_service.py
```

The server will start on `http://localhost:5000`

Check health: `curl http://localhost:5000/api/health`

---

## API Endpoints

### 1. Send Notification to Single User

**Endpoint:** `POST /api/notify/user`

**Request:**
```json
{
  "user_id": 1,
  "title": "Booking Confirmed",
  "body": "Your booking has been confirmed for 2026-01-10",
  "type": "booking",
  "data": {
    "booking_id": "123"
  }
}
```

**Response:**
```json
{
  "success": true,
  "message": "Notification sent successfully",
  "message_id": "projects/e-baladya-2026/messages/..."
}
```

### 2. Send Notification to Multiple Users

**Endpoint:** `POST /api/notify/users`

**Request:**
```json
{
  "user_ids": [1, 2, 3, 4],
  "title": "System Update",
  "body": "A new version is available",
  "type": "general",
  "data": {}
}
```

**Response:**
```json
{
  "success": true,
  "message": "Sent notifications to 4 users",
  "results": [
    {
      "user_id": 1,
      "success": true,
      "message_id": "..."
    },
    ...
  ]
}
```

### 3. Send Notification to Topic

**Endpoint:** `POST /api/notify/topic`

**Request:**
```json
{
  "topic": "announcements",
  "title": "Important Notice",
  "body": "New services available",
  "type": "service",
  "data": {}
}
```

**Response:**
```json
{
  "success": true,
  "message": "Notification sent to topic: announcements",
  "message_id": "..."
}
```

### 4. Health Check

**Endpoint:** `GET /api/health`

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2026-01-05T10:30:00.000000",
  "service": "E-Baladya Notification Service"
}
```

### 5. API Documentation

**Endpoint:** `GET /api/docs`

Returns complete API documentation

---

## Usage Examples

### Example 1: Send Booking Confirmation

```bash
curl -X POST http://localhost:5000/api/notify/user \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "title": "Booking Confirmed",
    "body": "Your booking is confirmed for 2026-01-10 at 10:00 AM",
    "type": "booking",
    "data": {
      "booking_id": "123",
      "service": "تجديد البطاقة الوطنية"
    }
  }'
```

### Example 2: Send Service Request Update

```bash
curl -X POST http://localhost:5000/api/notify/user \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "title": "Request Status Update",
    "body": "Your request status has been updated to approved",
    "type": "request",
    "data": {
      "request_id": "456",
      "status": "approved"
    }
  }'
```

### Example 3: Notify All Users

```bash
curl -X POST http://localhost:5000/api/notify/topic \
  -H "Content-Type: application/json" \
  -d '{
    "topic": "announcements",
    "title": "System Maintenance",
    "body": "System will be under maintenance tomorrow from 2-4 AM",
    "type": "general"
  }'
```

### Example 4: Python Client

```python
import requests
import json

BASE_URL = "http://localhost:5000/api"

def send_notification_to_user(user_id, title, body, notification_type, data=None):
    """Send notification to user"""
    url = f"{BASE_URL}/notify/user"
    
    payload = {
        "user_id": user_id,
        "title": title,
        "body": body,
        "type": notification_type,
        "data": data or {}
    }
    
    response = requests.post(url, json=payload)
    return response.json()

# Usage
result = send_notification_to_user(
    user_id=1,
    title="Document Ready",
    body="Your requested document is ready for pickup",
    notification_type="document",
    data={"document_id": "789"}
)

print(result)
```

---

## Scheduled Notifications

### How It Works

The Flask backend includes a background scheduler that:
1. Sends booking reminders every 6 hours
2. Sends daily announcements at 9:00 AM
3. Runs in a separate thread without blocking the API

### Customizing Schedules

Edit `notification_service.py` in the `run_scheduler()` function:

```python
def run_scheduler():
    # Send booking reminders every 6 hours
    schedule.every(6).hours.do(send_scheduled_booking_reminders)
    
    # Send announcements daily at 9:00 AM
    schedule.every().day.at("09:00").do(send_scheduled_announcements)
    
    # Other examples:
    # schedule.every().minute.do(job)
    # schedule.every().hour.do(job)
    # schedule.every().day.do(job)
    # schedule.every().monday.do(job)
    # schedule.every().wednesday.at("13:15").do(job)
```

### Creating Custom Scheduled Notifications

```python
def send_custom_monthly_reminder():
    """Send reminder on first day of month"""
    print(f"[{datetime.now()}] Sending monthly reminder...")
    
    message_data = {
        'type': 'reminder',
        'message': 'Monthly reminder'
    }
    
    message = messaging.Message(
        notification=messaging.Notification(
            title='Monthly Reminder',
            body='Remember to renew your documents',
        ),
        data=message_data,
        topic='reminders',
    )
    
    response = messaging.send(message)
    print(f"Monthly reminder sent: {response}")

# Add to scheduler
schedule.every().month.do(send_custom_monthly_reminder)
```

---

## Testing

### 1. Test FCM Token Generation

Run this in Flutter app:
```dart
final token = await FCMService().getFCMToken();
print('FCM Token: $token');
```

### 2. Test Receiving Notifications (Foreground)

With app open, send notification:
```bash
curl -X POST http://localhost:5000/api/notify/user \
  -H "Content-Type: application/json" \
  -d '{"user_id": 1, "title": "Test", "body": "Test notification", "type": "general"}'
```

You should see the notification saved to SQLite.

### 3. Test Receiving Notifications (Background/Closed)

1. Stop the app
2. Send notification from Flask backend
3. Restart the app
4. Check SQLite database - notification should be there
5. Tap notification - should navigate to correct screen

### 4. Test Navigation

Click on a notification with `type: "booking"` → should go to My Bookings screen

### 5. Database Verification

Check notifications in SQLite:
```dart
final notifications = await DatabaseHelper.instance.database.then((db) {
  return db.query('notifications', where: 'user_id = ?', whereArgs: [1]);
});
print(notifications);
```

---

## Implementation Checklist

✅ Firebase Cloud Messaging configured  
✅ FCM Service class created  
✅ Main app updated with FCM initialization  
✅ Notification Cubit enhanced with navigation  
✅ Local message storage in SQLite  
✅ Flask backend for sending notifications  
✅ REST API endpoints created  
✅ Scheduled notifications setup  
✅ Topic-based messaging support  

---

## Common Issues & Solutions

### Issue: Notifications not received

**Solution:**
1. Verify Firebase credentials are correct
2. Check user is subscribed to topic: `FCMService().subscribeUserToPersonalTopic(userId)`
3. Check notification type matches message data
4. Ensure app has internet connection

### Issue: Navigation not working

**Solution:**
1. Verify notification type in message data
2. Check route exists in `AppRoutes`
3. Ensure `notificationCubit` is listening to `NotificationNavigate` state

### Issue: App crashes on notification tap

**Solution:**
1. Check notification data format
2. Verify all required fields are present
3. Check database foreign key constraints

### Issue: Background messages not persisting

**Solution:**
1. Ensure `firebaseMessagingBackgroundHandler` is registered
2. Check database connection in background thread
3. Verify SQLite permissions for app

---

## Next Steps for Production

1. **Secure the API:** Add authentication to Flask endpoints
2. **Database Integration:** Connect Flask to your database for dynamic user queries
3. **Load Balancing:** Deploy Flask with multiple workers (Gunicorn/uWSGI)
4. **SSL/TLS:** Use HTTPS for all endpoints
5. **Monitoring:** Add logging and error tracking
6. **Testing:** Set up automated tests for notification delivery
7. **Analytics:** Track notification delivery and engagement rates

---

## References

- [Firebase Cloud Messaging Documentation](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Firebase Messaging Package](https://pub.dev/packages/firebase_messaging)
- [Firebase Admin Python SDK](https://firebase.google.com/docs/database/admin/start)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Schedule Library](https://schedule.readthedocs.io/)

---

**Last Updated:** January 5, 2026  
**Version:** 1.0.0
