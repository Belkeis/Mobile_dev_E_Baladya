# FCM Testing & Backend Integration Guide

## 📱 Step 5: Testing Notifications

### 5.1 Test from Firebase Console

1. Go to Firebase Console → **Cloud Messaging**
2. Click **"Send your first message"**
3. Fill in:
   - **Notification title**: تحديث الطلب
   - **Notification text**: تم الموافقة على طلبك
4. Click **"Send test message"**
5. Paste your FCM token (from app console log)
6. Click **"Test"**

### 5.2 Test Notification Types

**Test different scenarios:**

#### Foreground Notification (App is open)
- Keep app open
- Send notification from Firebase Console
- Should show local notification

#### Background Notification (App is minimized)
- Minimize app
- Send notification
- Notification should appear in system tray
- Tap it → app should open

#### Terminated State (App is closed)
- Force close app
- Send notification
- Tap notification → app should open

### 5.3 Create Test Notification Button

Add this to your home page for testing:

**lib/presentation/screens/home_page.dart** (add this button)
```dart
// Add this button in your home page
ElevatedButton(
  onPressed: () async {
    final fcmService = FirebaseMessagingService();
    await fcmService.subscribeToTopic('test_topic');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('اشتركت في إشعارات الاختبار')),
    );
  },
  child: const Text('اختبار الإشعارات'),
)
```

---

## 🖥️ Step 6: Backend Integration

### 6.1 Backend Server Setup (Node.js Example)

**Install dependencies:**
```bash
npm install firebase-admin express body-parser
```

**server.js**
```javascript
const admin = require('firebase-admin');
const express = require('express');
const bodyParser = require('body-parser');

// Initialize Firebase Admin SDK
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const app = express();
app.use(bodyParser.json());

// Send notification to specific device
app.post('/api/send-notification', async (req, res) => {
  const { token, title, body, data } = req.body;

  const message = {
    notification: {
      title: title,
      body: body
    },
    data: data || {},
    token: token
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
    res.status(200).json({ success: true, messageId: response });
  } catch (error) {
    console.error('Error sending message:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Send notification to topic
app.post('/api/send-topic-notification', async (req, res) => {
  const { topic, title, body, data } = req.body;

  const message = {
    notification: {
      title: title,
      body: body
    },
    data: data || {},
    topic: topic
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent message to topic:', response);
    res.status(200).json({ success: true, messageId: response });
  } catch (error) {
    console.error('Error sending message:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Send notification when request status changes
app.post('/api/notify-request-status', async (req, res) => {
  const { userId, requestId, status, serviceType } = req.body;

  let title, body;
  
  switch(status) {
    case 'approved':
      title = 'تمت الموافقة على طلبك';
      body = `تم الموافقة على طلب ${serviceType}`;
      break;
    case 'ready':
      title = 'طلبك جاهز للاستلام';
      body = `يمكنك زيارة البلدية لاستلام ${serviceType}`;
      break;
    case 'rejected':
      title = 'تم رفض طلبك';
      body = `للأسف، تم رفض طلب ${serviceType}`;
      break;
    default:
      title = 'تحديث الطلب';
      body = `تم تحديث حالة طلب ${serviceType}`;
  }

  const message = {
    notification: { title, body },
    data: {
      type: 'request_status',
      request_id: String(requestId),
      status: status,
      service_type: serviceType
    },
    topic: `user_${userId}`
  };

  try {
    const response = await admin.messaging().send(message);
    res.status(200).json({ success: true, messageId: response });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

### 6.2 Get Service Account Key

1. Go to Firebase Console
2. Click ⚙️ (Settings) → **Project settings**
3. Go to **Service accounts** tab
4. Click **"Generate new private key"**
5. Download `serviceAccountKey.json`
6. Place it in your backend project root

**⚠️ NEVER commit this file to version control!**

### 6.3 API Endpoints for E-Baladya

**Send notification when request is approved:**
```bash
curl -X POST http://localhost:3000/api/notify-request-status \
  -H "Content-Type: application/json" \
  -d '{
    "userId": 1,
    "requestId": 123,
    "status": "approved",
    "serviceType": "بطاقة التعريف الوطنية"
  }'
```

**Send notification to specific device:**
```bash
curl -X POST http://localhost:3000/api/send-notification \
  -H "Content-Type: application/json" \
  -d '{
    "token": "YOUR_FCM_TOKEN_HERE",
    "title": "تحديث مهم",
    "body": "طلبك جاهز للاستلام",
    "data": {
      "type": "request_ready",
      "request_id": "123"
    }
  }'
```

---

## 🔔 Step 7: Advanced Features

### 7.1 Rich Notifications with Images

**Backend - Send notification with image:**
```javascript
const message = {
  notification: {
    title: 'وثيقتك جاهزة',
    body: 'يمكنك تحميل وثيقتك الآن',
    imageUrl: 'https://example.com/document.jpg'
  },
  android: {
    notification: {
      imageUrl: 'https://example.com/document.jpg'
    }
  },
  apns: {
    payload: {
      aps: {
        'mutable-content': 1
      }
    },
    fcm_options: {
      image: 'https://example.com/document.jpg'
    }
  },
  token: fcmToken
};
```

### 7.2 Scheduled Notifications

**Using Cloud Functions (Firebase):**

**functions/index.js**
```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Schedule reminder notification
exports.sendRequestReminder = functions.pubsub
  .schedule('every day 09:00')
  .timeZone('Africa/Algiers')
  .onRun(async (context) => {
    const db = admin.firestore();
    
    // Get pending requests older than 3 days
    const threeDaysAgo = new Date();
    threeDaysAgo.setDate(threeDaysAgo.getDate() - 3);
    
    const pendingRequests = await db.collection('requests')
      .where('status', '==', 'pending')
      .where('created_at', '<', threeDaysAgo)
      .get();
    
    const notifications = [];
    
    pendingRequests.forEach(doc => {
      const request = doc.data();
      const message = {
        notification: {
          title: 'تذكير بطلبك',
          body: `طلبك (${request.service_type}) قيد المراجعة منذ 3 أيام`
        },
        topic: `user_${request.user_id}`
      };
      
      notifications.push(admin.messaging().send(message));
    });
    
    await Promise.all(notifications);
    console.log(`Sent ${notifications.length} reminder notifications`);
  });
```

Deploy:
```bash
firebase deploy --only functions
```

### 7.3 Notification Categories (iOS)

**Update AppDelegate.swift for iOS:**
```swift
import UserNotifications

override func application(
  _ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
  // ... existing code
  
  // Define notification categories
  let viewAction = UNNotificationAction(
    identifier: "VIEW_ACTION",
    title: "عرض",
    options: [.foreground]
  )
  
  let downloadAction = UNNotificationAction(
    identifier: "DOWNLOAD_ACTION",
    title: "تحميل",
    options: [.foreground]
  )
  
  let documentCategory = UNNotificationCategory(
    identifier: "DOCUMENT_READY",
    actions: [viewAction, downloadAction],
    intentIdentifiers: [],
    options: []
  )
  
  UNUserNotificationCenter.current().setNotificationCategories([documentCategory])
  
  return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}
```

### 7.4 Analytics & Tracking

**Track notification open rate:**

**lib/data/services/firebase_messaging_service.dart** (add method)
```dart
Future<void> logNotificationOpen(String notificationId) async {
  // Log to Firebase Analytics
  await FirebaseAnalytics.instance.logEvent(
    name: 'notification_opened',
    parameters: {
      'notification_id': notificationId,
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}
```

---

## 🧪 Step 8: Testing Checklist

### ✅ Android Testing

- [ ] App receives notification in foreground
- [ ] App receives notification in background
- [ ] App receives notification when terminated
- [ ] Notification icon appears correctly
- [ ] Notification color is correct (blue #2563EB)
- [ ] Tapping notification opens app
- [ ] Sound plays on notification
- [ ] Vibration works on notification
- [ ] FCM token is generated and logged

### ✅ iOS Testing

- [ ] Permission dialog appears on first launch
- [ ] App receives notification in foreground
- [ ] App receives notification in background
- [ ] App receives notification when terminated
- [ ] Notification badge appears on app icon
- [ ] Tapping notification opens app
- [ ] Sound plays on notification
- [ ] FCM token is generated and logged

### ✅ Backend Testing

- [ ] Server can send notification to specific device
- [ ] Server can send notification to topic
- [ ] Server can send notification with custom data
- [ ] Status change triggers notification correctly

---

## 🐛 Common Issues & Solutions

### Issue 1: "MissingPluginException"
**Solution:**
```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run
```

### Issue 2: Android notification not showing
**Solution:**
- Check `google-services.json` is in `android/app/`
- Verify notification channel is created
- Check Android version (must be API 21+)
- Ensure icon resource exists

### Issue 3: iOS not receiving notifications
**Solution:**
- Check Push Notifications capability is enabled
- Verify `GoogleService-Info.plist` is added to Xcode
- Check APNs certificate in Firebase Console
- Test on physical device (not simulator)

### Issue 4: Token is null
**Solution:**
- Wait a few seconds after app launch
- Check internet connection
- Verify Firebase is initialized
- Check Firebase Console for errors

### Issue 5: Background handler not working
**Solution:**
- Ensure `@pragma('vm:entry-point')` is added
- Check handler is top-level function
- Verify `onBackgroundMessage` is called in main

---

## 📊 Monitoring & Logs

### View FCM Logs in Firebase Console

1. Go to Firebase Console
2. Click **Cloud Messaging**
3. View sent notifications statistics
4. Check delivery reports

### Enable Debug Logging

**Android:**
```bash
adb shell setprop log.tag.FCM DEBUG
adb logcat -s FCM
```

**iOS:**
In Xcode:
- Edit Scheme → Run → Arguments
- Add: `-FIRDebugEnabled`

---

## 🎯 E-Baladya Specific Notifications

### Notification Types for E-Baladya:

1. **Request Submitted**
   - Title: "تم استلام طلبك"
   - Body: "سيتم مراجعة طلب [service_type] قريباً"
   - Data: `{type: 'request_submitted', request_id: 'xxx'}`

2. **Request Approved**
   - Title: "تمت الموافقة على طلبك"
   - Body: "تم الموافقة على طلب [service_type]"
   - Data: `{type: 'request_approved', request_id: 'xxx'}`

3. **Request Ready**
   - Title: "طلبك جاهز للاستلام"
   - Body: "يمكنك زيارة البلدية لاستلام [service_type]"
   - Data: `{type: 'request_ready', request_id: 'xxx'}`

4. **Document Available**
   - Title: "وثيقة جديدة متاحة"
   - Body: "تم إضافة [document_name] إلى وثائقك الرقمية"
   - Data: `{type: 'document_available', document_id: 'xxx'}`

5. **Reminder**
   - Title: "تذكير: زيارة البلدية"
   - Body: "لديك طلب جاهز للاستلام منذ 3 أيام"
   - Data: `{type: 'reminder', request_id: 'xxx'}`

---

## 📝 Summary

### What We Implemented:

1. ✅ Firebase project setup
2. ✅ Android configuration with google-services.json
3. ✅ iOS configuration with GoogleService-Info.plist
4. ✅ Flutter FCM integration
5. ✅ Local notifications for Android/iOS
6. ✅ Background message handling
7. ✅ Foreground message handling
8. ✅ Notification navigation logic
9. ✅ Topic subscription
10. ✅ FCM token management
11. ✅ Notification Cubit for state management
12. ✅ Backend server example (Node.js)
13. ✅ Testing guide
14. ✅ Advanced features (images, scheduling, analytics)

### Files Created:

1. `lib/data/services/firebase_messaging_service.dart`
2. `lib/logic/cubits/notifications/notification_cubit.dart`
3. `lib/presentation/screens/notification_settings_page.dart`
4. `android/app/google-services.json` (download from Firebase)
5. `ios/Runner/GoogleService-Info.plist` (download from Firebase)
6. Backend server files (optional)

### Next Steps:

1. Download configuration files from Firebase Console
2. Place them in correct directories
3. Run `flutter pub get`
4. Test on physical devices
5. Integrate with your backend
6. Monitor notification delivery in Firebase Console

🎉 Your E-Baladya app now has full push notification support!