"""
Flask Backend for E-Baladya Push Notifications
Sends FCM messages to mobile app users
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import firebase_admin
from firebase_admin import credentials, messaging
import json
from datetime import datetime
import os
from dotenv import load_dotenv
import schedule
import time
from threading import Thread

# Load environment variables
load_dotenv()

app = Flask(__name__)
CORS(app)

# Initialize Firebase Admin SDK
# Look for credentials in parent directory (project root) or use env var
firebase_credentials_path = os.getenv('FIREBASE_CREDENTIALS_PATH')
if not firebase_credentials_path:
    parent_dir = os.path.dirname(os.path.abspath(__file__))
    firebase_credentials_path = os.path.join(parent_dir, '..', 'firebase_credentials.json')

try:
    cred = credentials.Certificate(firebase_credentials_path)
    firebase_admin.initialize_app(cred)
    print(f"Firebase initialized successfully from {firebase_credentials_path}")
except Exception as e:
    print(f"Error initializing Firebase: {e}")

# ============================================================================
# API ENDPOINTS FOR SENDING NOTIFICATIONS
# ============================================================================

@app.route('/api/notify/user', methods=['POST'])
def send_notification_to_user():
    """
    Send notification to a specific user.
    
    Request body:
    {
        "user_id": 1,
        "title": "Your Booking Confirmed",
        "body": "Your booking has been confirmed for 2026-01-10",
        "type": "booking",
        "data": {
            "booking_id": "123",
            "additional_field": "value"
        }
    }
    """
    try:
        data = request.get_json()
        
        # Validate required fields
        if not data.get('user_id'):
            return jsonify({'error': 'user_id is required'}), 400
        
        user_id = data.get('user_id')
        title = data.get('title', 'E-Baladya Notification')
        body = data.get('body', 'You have a new notification')
        notification_type = data.get('type', 'general')
        extra_data = data.get('data', {})
        
        # Create message data
        message_data = {
            'user_id': str(user_id),
            'type': notification_type,
            'timestamp': datetime.now().isoformat(),
            'message': body,
        }
        
        # Add any extra data
        message_data.update(extra_data)
        
        # Send message to user's topic
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body,
            ),
            data=message_data,
            topic=f'user_{user_id}',
        )
        
        response = messaging.send(message)
        
        return jsonify({
            'success': True,
            'message': 'Notification sent successfully',
            'message_id': response
        }), 200
        
    except Exception as e:
        print(f"Error sending notification: {e}")
        return jsonify({'error': str(e)}), 500


@app.route('/api/notify/users', methods=['POST'])
def send_notification_to_multiple_users():
    """
    Send notification to multiple users.
    
    Request body:
    {
        "user_ids": [1, 2, 3],
        "title": "Important Update",
        "body": "Check out the new features",
        "type": "general",
        "data": {}
    }
    """
    try:
        data = request.get_json()
        
        user_ids = data.get('user_ids', [])
        if not user_ids:
            return jsonify({'error': 'user_ids list is required'}), 400
        
        title = data.get('title', 'E-Baladya Notification')
        body = data.get('body', 'You have a new notification')
        notification_type = data.get('type', 'general')
        extra_data = data.get('data', {})
        
        results = []
        
        for user_id in user_ids:
            try:
                message_data = {
                    'user_id': str(user_id),
                    'type': notification_type,
                    'timestamp': datetime.now().isoformat(),
                    'message': body,
                }
                
                message_data.update(extra_data)
                
                message = messaging.Message(
                    notification=messaging.Notification(
                        title=title,
                        body=body,
                    ),
                    data=message_data,
                    topic=f'user_{user_id}',
                )
                
                response = messaging.send(message)
                results.append({
                    'user_id': user_id,
                    'success': True,
                    'message_id': response
                })
            except Exception as e:
                results.append({
                    'user_id': user_id,
                    'success': False,
                    'error': str(e)
                })
        
        return jsonify({
            'success': True,
            'message': f'Sent notifications to {len(user_ids)} users',
            'results': results
        }), 200
        
    except Exception as e:
        print(f"Error sending notifications: {e}")
        return jsonify({'error': str(e)}), 500


@app.route('/api/notify/topic', methods=['POST'])
def send_notification_to_topic():
    """
    Send notification to all users subscribed to a topic.
    
    Request body:
    {
        "topic": "general_updates",
        "title": "General Update",
        "body": "This is an update for all users",
        "type": "general",
        "data": {}
    }
    """
    try:
        data = request.get_json()
        
        topic = data.get('topic')
        if not topic:
            return jsonify({'error': 'topic is required'}), 400
        
        title = data.get('title', 'E-Baladya Notification')
        body = data.get('body', 'You have a new notification')
        notification_type = data.get('type', 'general')
        extra_data = data.get('data', {})
        
        message_data = {
            'type': notification_type,
            'timestamp': datetime.now().isoformat(),
            'message': body,
        }
        
        message_data.update(extra_data)
        
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body,
            ),
            data=message_data,
            topic=topic,
        )
        
        response = messaging.send(message)
        
        return jsonify({
            'success': True,
            'message': f'Notification sent to topic: {topic}',
            'message_id': response
        }), 200
        
    except Exception as e:
        print(f"Error sending notification to topic: {e}")
        return jsonify({'error': str(e)}), 500


# ============================================================================
# SCHEDULED NOTIFICATIONS
# ============================================================================

def send_scheduled_booking_reminders():
    """
    This function runs periodically to send booking reminders.
    In production, you would query your database for upcoming bookings.
    """
    print(f"[{datetime.now()}] Running scheduled booking reminders...")
    
    try:
        # Example: Send reminder to user 1
        # In production, query your database for users with upcoming bookings
        
        message_data = {
            'user_id': '1',
            'type': 'booking',
            'timestamp': datetime.now().isoformat(),
            'message': 'Reminder: You have a booking tomorrow',
        }
        
        message = messaging.Message(
            notification=messaging.Notification(
                title='Booking Reminder',
                body='You have a booking tomorrow at 10:00 AM',
            ),
            data=message_data,
            topic='user_1',
        )
        
        # Only send if there are actual bookings to remind about
        # response = messaging.send(message)
        # print(f"Booking reminder sent: {response}")
        
    except Exception as e:
        print(f"Error in scheduled notification: {e}")


def send_scheduled_announcements():
    """
    Send periodic announcements to all users.
    Runs daily at a specified time.
    """
    print(f"[{datetime.now()}] Running scheduled announcements...")
    
    try:
        message_data = {
            'type': 'announcement',
            'timestamp': datetime.now().isoformat(),
            'message': 'Daily update from E-Baladya',
        }
        
        message = messaging.Message(
            notification=messaging.Notification(
                title='Daily Update',
                body='Check out our latest updates and services',
            ),
            data=message_data,
            topic='announcements',
        )
        
        # Uncomment to enable daily announcements
        # response = messaging.send(message)
        # print(f"Announcement sent: {response}")
        
    except Exception as e:
        print(f"Error in scheduled announcement: {e}")


def run_scheduler():
    """
    Background scheduler that runs scheduled notification tasks.
    This runs in a separate thread.
    """
    # Schedule booking reminders every 6 hours
    schedule.every(6).hours.do(send_scheduled_booking_reminders)
    
    # Schedule announcements daily at 9:00 AM
    schedule.every().day.at("09:00").do(send_scheduled_announcements)
    
    print("Scheduler started. Scheduled jobs:")
    for job in schedule.jobs:
        print(f"  - {job}")
    
    while True:
        schedule.run_pending()
        time.sleep(60)  # Check every minute


# Start the scheduler in a background thread
scheduler_thread = Thread(target=run_scheduler, daemon=True)
scheduler_thread.start()


# ============================================================================
# UTILITY ENDPOINTS
# ============================================================================

@app.route('/api/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'service': 'E-Baladya Notification Service'
    }), 200


@app.route('/api/docs', methods=['GET'])
def documentation():
    """API documentation"""
    docs = {
        'service': 'E-Baladya Push Notification Service',
        'version': '1.0.0',
        'endpoints': {
            'POST /api/notify/user': {
                'description': 'Send notification to a specific user',
                'body': {
                    'user_id': 'int (required)',
                    'title': 'string',
                    'body': 'string',
                    'type': 'string (booking, request, document, service, general)',
                    'data': 'object'
                }
            },
            'POST /api/notify/users': {
                'description': 'Send notification to multiple users',
                'body': {
                    'user_ids': 'array of int (required)',
                    'title': 'string',
                    'body': 'string',
                    'type': 'string',
                    'data': 'object'
                }
            },
            'POST /api/notify/topic': {
                'description': 'Send notification to all users subscribed to a topic',
                'body': {
                    'topic': 'string (required)',
                    'title': 'string',
                    'body': 'string',
                    'type': 'string',
                    'data': 'object'
                }
            },
            'GET /api/health': {
                'description': 'Check service health'
            },
            'GET /api/docs': {
                'description': 'Get API documentation'
            }
        }
    }
    return jsonify(docs), 200


# ============================================================================
# ERROR HANDLERS
# ============================================================================

@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Endpoint not found'}), 404


@app.errorhandler(500)
def internal_error(error):
    return jsonify({'error': 'Internal server error'}), 500


if __name__ == '__main__':
    # Run Flask app
    # Set debug=False in production
    app.run(
        host='0.0.0.0',
        port=5000,
        debug=True
    )
