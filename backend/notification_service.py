from flask import Flask, request, jsonify
from flask_cors import CORS
import firebase_admin
from firebase_admin import credentials, messaging
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

# Initialize Firebase Admin SDK (simple fallback to repo root credentials)
firebase_credentials_path = os.getenv('FIREBASE_CREDENTIALS_PATH')
if not firebase_credentials_path:
    parent_dir = os.path.dirname(os.path.abspath(__file__))
    firebase_credentials_path = os.path.join(parent_dir, '..', 'firebase_credentials.json')

try:
    cred = credentials.Certificate(firebase_credentials_path)
    firebase_admin.initialize_app(cred)
    print(f"Firebase initialized from {firebase_credentials_path}")
except Exception as e:
    print(f"Firebase init error: {e}")


# ---------------------------------------------------------------------------
# Simple API: Send to single user (personal topic `user_<id>`)
# ---------------------------------------------------------------------------
@app.route('/api/notify/user', methods=['POST'])
def send_notification_to_user():
    try:
        data = request.get_json() or {}
        user_id = data.get('user_id')
        if not user_id:
            return jsonify({'error': 'user_id is required'}), 400

        title = data.get('title', 'E-Baladya')
        body = data.get('body', 'لديك إشعار جديد')
        extra = data.get('data', {})

        message_data = {
            'user_id': str(user_id),
            'timestamp': datetime.now().isoformat(),
            'message': body,
        }
        message_data.update(extra)

        message = messaging.Message(
            notification=messaging.Notification(title=title, body=body),
            data=message_data,
            topic=f'user_{user_id}',
        )

        response = messaging.send(message)
        return jsonify({'success': True, 'message_id': response}), 200

    except Exception as e:
        print(f"send_notification_to_user error: {e}")
        return jsonify({'error': str(e)}), 500


# ---------------------------------------------------------------------------
# Simple scheduler: single repeating job configurable by interval and unit
# Set interval via env vars: SCHEDULER_ENABLED, SCHEDULER_INTERVAL, SCHEDULER_UNIT
# Unit can be 'seconds', 'minutes' or 'hours'
# ---------------------------------------------------------------------------
SCHEDULER_ENABLED = os.getenv('SCHEDULER_ENABLED', 'True').lower() in ('1', 'true', 'yes')
SCHEDULER_INTERVAL = int(os.getenv('SCHEDULER_INTERVAL', '60'))
SCHEDULER_UNIT = os.getenv('SCHEDULER_UNIT', 'munits')  # seconds/minutes/hours


def send_scheduled_tasks():
    """Simple scheduled job. In production replace test logic with DB queries."""
    print(f"[{datetime.now()}] Running scheduled tasks...")
    try:
        # Simple test message to user 1 (change to real logic as needed)
        message_data = {
            'user_id': '1',
            'timestamp': datetime.now().isoformat(),
            'message': 'تذكير مجدول من تطبيق البلدية الإلكترونية',
        }

        message = messaging.Message(
            notification=messaging.Notification(
                title='تذكير مجدول',
                body='هذا إشعار تلقائي مجدول',
            ),
            data=message_data,
            topic='user_1',
        )
        response = messaging.send(message)
        print(f"Scheduled message sent, id: {response}")

    except Exception as e:
        print(f"Scheduled task error: {e}")


def run_scheduler():
    # Register single repeating job based on interval/unit
    unit = SCHEDULER_UNIT.lower()
    if unit == 'seconds':
        schedule.every(SCHEDULER_INTERVAL).seconds.do(send_scheduled_tasks)
        print(f"Scheduler: every {SCHEDULER_INTERVAL} seconds")
    elif unit == 'minutes':
        schedule.every(SCHEDULER_INTERVAL).minutes.do(send_scheduled_tasks)
        print(f"Scheduler: every {SCHEDULER_INTERVAL} minutes")
    elif unit == 'hours':
        schedule.every(SCHEDULER_INTERVAL).hours.do(send_scheduled_tasks)
        print(f"Scheduler: every {SCHEDULER_INTERVAL} hours")
    else:
        schedule.every(SCHEDULER_INTERVAL).seconds.do(send_scheduled_tasks)
        print(f"Scheduler: unit unknown, defaulting to seconds every {SCHEDULER_INTERVAL}")

    while True:
        schedule.run_pending()
        time.sleep(1)


if SCHEDULER_ENABLED:
    scheduler_thread = Thread(target=run_scheduler, daemon=True)
    scheduler_thread.start()


@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy', 'timestamp': datetime.now().isoformat()}), 200


@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Endpoint not found'}), 404


@app.errorhandler(500)
def internal_error(error):
    return jsonify({'error': 'Internal server error'}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

