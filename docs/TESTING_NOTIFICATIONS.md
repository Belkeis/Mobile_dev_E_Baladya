## Quick Testing Guide for E-Baladya Notifications

This guide helps you quickly test the notification system end-to-end.

### Prerequisites

1. **Flutter App Running**
   - Make sure the app is installed on your device/emulator
   - User should be logged in (user ID: 1 by default from seed data)

2. **Flask Backend Running**
   ```bash
   cd c:\Users\DELL\Documents\GitHub\Mobile_dev_E_Baladya
   python notification_service.py
   ```

3. **Firebase Credentials**
   - `firebase_credentials.json` file in project root

---

## Test Scenario 1: Send Notification While App is Open

**Step 1:** Keep app open on notifications page

**Step 2:** Send notification from terminal:
```bash
curl -X POST http://localhost:5000/api/notify/user \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "title": "Testing Notifications",
    "body": "This is a test notification while app is open",
    "type": "booking",
    "data": {"booking_id": "123"}
  }'
```

**Expected Result:**
- Notification appears in SQLite database
- Appears in notifications list (might need to refresh)
- Can mark as read by tapping
- Tapping notification navigates to Bookings page

---

## Test Scenario 2: Send Notification While App is Closed

**Step 1:** Close the app completely

**Step 2:** Send notification:
```bash
curl -X POST http://localhost:5000/api/notify/user \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "title": "App Closed Test",
    "body": "Testing notification with app closed",
    "type": "request"
  }'
```

**Step 3:** Reopen the app

**Expected Result:**
- Notification is received and stored
- Appears in notifications page
- Check SQLite to confirm it was stored

---

## Test Scenario 3: Test Different Notification Types

### Booking Notification → My Bookings
```bash
curl -X POST http://localhost:5000/api/notify/user \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "title": "Booking Confirmed",
    "body": "Your booking is confirmed for tomorrow",
    "type": "booking"
  }'
```

### Request Notification → Tracking
```bash
curl -X POST http://localhost:5000/api/notify/user \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "title": "Request Updated",
    "body": "Your request status has been updated",
    "type": "request"
  }'
```

### Document Notification → Digital Versions
```bash
curl -X POST http://localhost:5000/api/notify/user \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "title": "Document Ready",
    "body": "Your digital document is ready",
    "type": "document"
  }'
```

### Service Notification → Home
```bash
curl -X POST http://localhost:5000/api/notify/user \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "title": "New Service Available",
    "body": "Check out our new services",
    "type": "service"
  }'
```

### General Notification → Notifications Page
```bash
curl -X POST http://localhost:5000/api/notify/user \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "title": "General Update",
    "body": "This is a general update",
    "type": "general"
  }'
```

---

## Test Scenario 4: Send to Multiple Users

```bash
curl -X POST http://localhost:5000/api/notify/users \
  -H "Content-Type: application/json" \
  -d '{
    "user_ids": [1, 2],
    "title": "System Update",
    "body": "A new feature has been released",
    "type": "general"
  }'
```

**Expected Result:**
- Notifications sent to all specified users
- Each notification stored with correct user_id

---

## Test Scenario 5: Topic-based Messaging

First, subscribe all users to "announcements" topic:
```bash
# In your app - need to add this capability
# For now, just test the endpoint
```

Send to topic:
```bash
curl -X POST http://localhost:5000/api/notify/topic \
  -H "Content-Type: application/json" \
  -d '{
    "topic": "announcements",
    "title": "Important Announcement",
    "body": "All users should see this",
    "type": "general"
  }'
```

---

## Debugging Checklist

### Notification Not Received?

1. **Check FCM Token**
   - App logs should show: `FCM Token: ...`
   - If not generated, check Firebase configuration

2. **Verify User Subscription**
   - Check app logs for: `User subscribed to personal topic: user_1`
   - Check Flask logs for successful send

3. **Check Network**
   ```bash
   curl http://localhost:5000/api/health
   ```
   Should return 200 OK

4. **Check Database**
   - Use Flutter SQLite viewer or query directly
   - `SELECT * FROM notifications WHERE user_id = 1`

### Notification Received But Not Navigating?

1. **Check Notification Type**
   - Verify type matches one of: `booking`, `request`, `document`, `service`, `general`
   
2. **Check Routes**
   - Verify route exists in `AppRoutes`
   - Check no typos in route names

3. **Check BLoC Setup**
   - Verify `NotificationNavigate` listener is active in main.dart

### Database Not Storing?

1. **Check Permissions**
   - App needs write permission to SQLite

2. **Check DatabaseHelper**
   - Verify `insertNotification` method exists
   - Check database is initialized before receiving notifications

3. **Check Data Format**
   - Ensure message has all required fields:
     - `user_id`
     - `message` or notification `body`
     - `type`

---

## Manual Database Check (Flutter)

Add this to a test screen:

```dart
import '../data/database/database_helper.dart';

Future<void> checkNotifications() async {
  final db = await DatabaseHelper.instance.database;
  final notifications = await db.query('notifications', where: 'user_id = ?', whereArgs: [1]);
  
  print('=== Notifications in Database ===');
  for (var notif in notifications) {
    print('ID: ${notif['id']}, Message: ${notif['message']}, Type: ${notif['type']}, Read: ${notif['read']}');
  }
}
```

---

## Common cURL Errors & Solutions

### "Failed to connect to localhost"
- Flask server not running
- Start with: `python notification_service.py`

### "400 Bad Request"
- Missing required fields (user_id, title, body, etc.)
- Check JSON formatting

### "500 Internal Server Error"
- Firebase credentials issue
- Check `firebase_credentials.json` exists and is valid
- Check Flask logs for detailed error

### "Unknown host"
- Network issue
- Check internet connection
- Verify Flask is on correct port (5000)

---

## Performance Testing

### Send 100 notifications to same user
```bash
for i in {1..100}; do
  curl -X POST http://localhost:5000/api/notify/user \
    -H "Content-Type: application/json" \
    -d "{\"user_id\": 1, \"title\": \"Test $i\", \"body\": \"Message $i\", \"type\": \"general\"}"
done
```

**Check:**
- App doesn't crash
- Database handles bulk inserts
- UI remains responsive

### Send to multiple users concurrently
```bash
curl -X POST http://localhost:5000/api/notify/users \
  -H "Content-Type: application/json" \
  -d '{"user_ids": [1,2,3,4,5,6,7,8,9,10], "title": "Bulk", "body": "Testing", "type": "general"}' &
curl -X POST http://localhost:5000/api/notify/users \
  -H "Content-Type: application/json" \
  -d '{"user_ids": [11,12,13,14,15], "title": "Bulk 2", "body": "Testing 2", "type": "general"}' &
wait
```

---

## Next: Integrate with Your Backend

Once working, replace test data with actual calls from your system:

```python
# In your main application
import requests

def send_booking_confirmation(user_id, booking_id, date):
    """Send notification when booking is confirmed"""
    url = "http://localhost:5000/api/notify/user"
    payload = {
        "user_id": user_id,
        "title": "تم تأكيد موعدك",
        "body": f"تم تأكيد موعدك في {date}",
        "type": "booking",
        "data": {"booking_id": booking_id}
    }
    response = requests.post(url, json=payload)
    return response.json()
```

---

**Happy Testing!** 🎉
