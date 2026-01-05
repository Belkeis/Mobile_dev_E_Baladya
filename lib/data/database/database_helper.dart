import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/service_model.dart';
import '../models/request_model.dart';
import '../models/document_model.dart';
import '../models/digital_document_model.dart';
import '../models/notification_model.dart';
import '../models/booking_model.dart';
import '../models/request_document_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('e_baladya.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 6, // Increment version to apply seed data changes
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add booking_types table
      await db.execute('''
      CREATE TABLE booking_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL
      )
      ''');

      // Add booking_type_id column to bookings table
      await db.execute('''
      ALTER TABLE bookings ADD COLUMN booking_type_id INTEGER
      ''');

      // Insert booking types
      await db.insert('booking_types', {
        'id': 1,
        'name': 'الحالة المدنية',
        'description': 'استخراج وثائق الحالة المدنية'
      });
      await db.insert('booking_types', {
        'id': 2,
        'name': 'المصالح البيومترية',
        'description': 'خدمات البصمة والبيانات البيومترية'
      });
      await db.insert('booking_types', {
        'id': 3,
        'name': 'الاستلام',
        'description': 'استلام الوثائق الجاهزة'
      });
    }

    if (oldVersion < 4) {
      // Ensure request_documents table exists (was added in v3, but forcing v4 upgrade)
      await db.execute("CREATE TABLE IF NOT EXISTS request_documents ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "request_id INTEGER NOT NULL,"
          "file_url TEXT NOT NULL,"
          "file_name TEXT NOT NULL,"
          "FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE"
          ")");
    }

    if (oldVersion < 5) {
      // Migration: Change digital_documents to link to documents instead of services
      await db.execute('DROP TABLE IF EXISTS digital_documents');
      await db.execute('''
        CREATE TABLE digital_documents (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          document_id INTEGER NOT NULL,
          file_path TEXT NOT NULL,
          issued_date TEXT NOT NULL,
          expires_on TEXT,
          is_valid INTEGER NOT NULL DEFAULT 1,
          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
          FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE
        )
      ''');
    }

    if (oldVersion < 6) {
      // Add 'Passport' to document types
      final passportId = await db.insert('documents', {'name': 'جواز سفر', 'type': 'passport'});
      
      final now = DateTime.now();
      
      // Insert dummy digital documents for the default user (ID 1)
      // Birth Certificate (assuming ID 1)
      await db.insert('digital_documents', {
        'user_id': 1,
        'document_id': 1, 
        'file_path': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        'issued_date': now.subtract(const Duration(days: 30)).toIso8601String(),
        'expires_on': now.add(const Duration(days: 3650)).toIso8601String(),
        'is_valid': 1,
      });

      // National ID Copy (assuming ID 2)
      await db.insert('digital_documents', {
        'user_id': 1,
        'document_id': 2, 
        'file_path': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 
        'issued_date': now.subtract(const Duration(days: 100)).toIso8601String(),
        'expires_on': now.add(const Duration(days: 3000)).toIso8601String(),
        'is_valid': 1,
      });

      // Passport
      await db.insert('digital_documents', {
        'user_id': 1,
        'document_id': passportId, 
        'file_path': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 
        'issued_date': now.subtract(const Duration(days: 20)).toIso8601String(),
        'expires_on': now.add(const Duration(days: 1500)).toIso8601String(),
        'is_valid': 1,
      });
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      full_name TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      phone TEXT,
      national_id TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      created_at TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE services (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      fee REAL NOT NULL,
      processing_time TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE documents (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      type TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE requests (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      service_id INTEGER NOT NULL,
      status TEXT NOT NULL,
      request_date TEXT NOT NULL,
      expected_date TEXT NOT NULL,
      notes TEXT,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
    )
  ''');

    await db.execute('''
    CREATE TABLE service_requirements (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      service_id INTEGER NOT NULL,
      document_id INTEGER NOT NULL,
      FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
      FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE
    )
  ''');

    // Create booking_types table
    await db.execute('''
    CREATE TABLE booking_types (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE bookings (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      service_id INTEGER NOT NULL,
      booking_type_id INTEGER,
      date TEXT NOT NULL,
      status TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE,
      FOREIGN KEY (booking_type_id) REFERENCES booking_types(id) ON DELETE SET NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE notifications (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      message TEXT NOT NULL,
      type TEXT NOT NULL,
      timestamp TEXT NOT NULL,
      read INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    )
  ''');

    await db.execute('''
    CREATE TABLE digital_documents (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      document_id INTEGER NOT NULL,
      file_path TEXT NOT NULL,
      issued_date TEXT NOT NULL,
      expires_on TEXT,
      is_valid INTEGER NOT NULL DEFAULT 1,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE
    )
  ''');

    await db.execute('''
    CREATE TABLE request_documents (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      request_id INTEGER NOT NULL,
      file_url TEXT NOT NULL,
      file_name TEXT NOT NULL,
      FOREIGN KEY (request_id) REFERENCES requests(id) ON DELETE CASCADE
    )
  ''');

    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    // Insert default user
    await db.insert('users', {
      'full_name': 'أحمد محمد',
      'email': 'ahmed@example.com',
      'phone': '0555123456',
      'national_id': '1234567890',
      'password': 'password123',
      'created_at': DateTime.now().toIso8601String(),
    });

    // Insert services
    final services = [
      {
        'name': 'تجديد بطاقة تعريف وطنية',
        'description': 'تجديد البطاقة الوطنية عند انتهاء صلاحيتها',
        'fee': 400.0,
        'processing_time': '7 أيام',
      },
      {
        'name': 'تجديد جواز السفر',
        'description': 'تجديد جواز السفر عند انتهاء صلاحيته',
        'fee': 5000.0,
        'processing_time': '14 يوم',
      },
      {
        'name': 'شهادة ميلاد',
        'description': 'الحصول على شهادة ميلاد جديدة',
        'fee': 200.0,
        'processing_time': '5 أيام',
      },
      {
        'name': 'عقد زواج',
        'description': 'الحصول على عقد زواج',
        'fee': 300.0,
        'processing_time': '10 أيام',
      },
      {
        'name': 'شهادة إقامة',
        'description': 'الحصول على شهادة إقامة',
        'fee': 250.0,
        'processing_time': '7 أيام',
      },
    ];

    for (final service in services) {
      await db.insert('services', service);
    }

    // Insert booking types
    await db.insert('booking_types', {
      'id': 1,
      'name': 'الحالة المدنية',
      'description': 'استخراج وثائق الحالة المدنية'
    });
    await db.insert('booking_types', {
      'id': 2,
      'name': 'المصالح البيومترية',
      'description': 'خدمات البصمة والبيانات البيومترية'
    });
    await db.insert('booking_types',
        {'id': 3, 'name': 'الاستلام', 'description': 'استلام الوثائق الجاهزة'});

    // Insert documents
    final documents = [
      {'name': 'شهادة ميلاد', 'type': 'certificate'},
      {'name': 'نسخة من بطاقة الهوية', 'type': 'copy'},
      {'name': 'نموذج الطلب', 'type': 'form'},
      {'name': 'صورة شخصية', 'type': 'photo'},
      {'name': 'إثبات الإقامة', 'type': 'proof'},
      {'name': 'جواز سفر', 'type': 'passport'}, // Added Passport
    ];


    for (final doc in documents) {
      await db.insert('documents', doc);
    }

    // Insert service requirements
    await db
        .insert('service_requirements', {'service_id': 1, 'document_id': 2});
    await db
        .insert('service_requirements', {'service_id': 1, 'document_id': 4});
    await db
        .insert('service_requirements', {'service_id': 1, 'document_id': 3});

    await db
        .insert('service_requirements', {'service_id': 2, 'document_id': 1});
    await db
        .insert('service_requirements', {'service_id': 2, 'document_id': 2});
    await db
        .insert('service_requirements', {'service_id': 2, 'document_id': 4});
    await db
        .insert('service_requirements', {'service_id': 2, 'document_id': 3});

    await db
        .insert('service_requirements', {'service_id': 3, 'document_id': 2});
    await db
        .insert('service_requirements', {'service_id': 3, 'document_id': 3});

    // Insert sample requests
    final now = DateTime.now();
    await db.insert('requests', {
      'user_id': 1,
      'service_id': 2,
      'status': 'pending',
      'request_date': now.toIso8601String(),
      'expected_date': now.add(const Duration(days: 14)).toIso8601String(),
      'notes': null,
    });

    await db.insert('requests', {
      'user_id': 1,
      'service_id': 1,
      'status': 'ready',
      'request_date': now.subtract(const Duration(days: 5)).toIso8601String(),
      'expected_date': now.add(const Duration(days: 2)).toIso8601String(),
      'notes': 'جاهز للاستلام',
    });

    // Insert sample digital documents (Dummy Data for Admin Side)
    // Document IDs: 1 (Birth Cert), 2 (ID Copy), 6 (Passport) based on insertion order
    
    // Birth Certificate
    await db.insert('digital_documents', {
      'user_id': 1,
      'document_id': 1, 
      'file_path': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', // Dummy remote URL
      'issued_date': now.subtract(const Duration(days: 30)).toIso8601String(),
      'expires_on': now.add(const Duration(days: 3650)).toIso8601String(),
      'is_valid': 1,
    });

    // National ID Copy
    await db.insert('digital_documents', {
      'user_id': 1,
      'document_id': 2, 
      'file_path': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 
      'issued_date': now.subtract(const Duration(days: 100)).toIso8601String(),
      'expires_on': now.add(const Duration(days: 3000)).toIso8601String(),
      'is_valid': 1,
    });

    // Passport
    await db.insert('digital_documents', {
      'user_id': 1,
      'document_id': 6, 
      'file_path': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', 
      'issued_date': now.subtract(const Duration(days: 20)).toIso8601String(),
      'expires_on': now.add(const Duration(days: 1500)).toIso8601String(),
      'is_valid': 1,
    });

    // Insert sample notifications
    await db.insert('notifications', {
      'user_id': 1,
      'message': 'تم قبول طلبك لتجديد بطاقة الهوية',
      'type': 'request_update',
      'timestamp': now.toIso8601String(),
      'read': 0,
    });

    // No sample bookings - users will create their own
  }

  // User operations
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  Future<UserModel?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  // Service operations
  Future<List<ServiceModel>> getAllServices() async {
    final db = await database;
    final maps = await db.query('services');
    return maps.map((map) => ServiceModel.fromMap(map)).toList();
  }

  Future<ServiceModel?> getServiceById(int id) async {
    final db = await database;
    final maps = await db.query(
      'services',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return ServiceModel.fromMap(maps.first);
  }

  // Request operations
  Future<int> insertRequest(RequestModel request) async {
    final db = await database;
    return await db.insert('requests', request.toMap());
  }

  Future<List<RequestModel>> getRequestsByUserId(int userId) async {
    final db = await database;
    final maps = await db.query(
      'requests',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'request_date DESC',
    );
    return maps.map((map) => RequestModel.fromMap(map)).toList();
  }

  /// Finds active (pending/approved) requests for a specific service and user
  Future<List<RequestModel>> getActiveRequestsByService(int userId, int serviceId) async {
    final db = await database;
    final maps = await db.query(
      'requests',
      where: 'user_id = ? AND service_id = ? AND (status = ? OR status = ?)',
      whereArgs: [userId, serviceId, 'pending', 'approved'],
    );
    return maps.map((map) => RequestModel.fromMap(map)).toList();
  }

  Future<RequestModel?> getRequestById(int id) async {
    final db = await database;
    final maps = await db.query(
      'requests',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return RequestModel.fromMap(maps.first);
  }

  Future<int> updateRequest(RequestModel request) async {
    final db = await database;
    return await db.update(
      'requests',
      request.toMap(),
      where: 'id = ?',
      whereArgs: [request.id],
    );
  }

  // Document operations
  Future<List<DocumentModel>> getAllDocuments() async {
    final db = await database;
    final maps = await db.query('documents');
    return maps.map((map) => DocumentModel.fromMap(map)).toList();
  }

  Future<List<DocumentModel>> getDocumentsByServiceId(int serviceId) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT d.* FROM documents d
      INNER JOIN service_requirements sr ON d.id = sr.document_id
      WHERE sr.service_id = ?
    ''', [serviceId]);
    return maps.map((map) => DocumentModel.fromMap(map)).toList();
  }

  // Digital document operations
  Future<List<DigitalDocumentModel>> getDigitalDocumentsByUserId(
      int userId) async {
    final db = await database;
    final maps = await db.query(
      'digital_documents',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'issued_date DESC',
    );
    return maps.map((map) => DigitalDocumentModel.fromMap(map)).toList();
  }

  /// Finds digital documents of a specific document type for a user
  Future<List<DigitalDocumentModel>> getDigitalDocumentsByDocumentId(int userId, int documentId) async {
    final db = await database;
    final maps = await db.query(
      'digital_documents',
      where: 'user_id = ? AND document_id = ? AND is_valid = 1',
      whereArgs: [userId, documentId],
    );
    return maps.map((map) => DigitalDocumentModel.fromMap(map)).toList();
  }

  Future<int> insertDigitalDocument(DigitalDocumentModel doc) async {
    final db = await database;
    return await db.insert('digital_documents', doc.toMap());
  }

  // Notification operations
  Future<List<NotificationModel>> getNotificationsByUserId(int userId) async {
    final db = await database;
    final maps = await db.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );
    return maps.map((map) => NotificationModel.fromMap(map)).toList();
  }

  Future<int> insertNotification(NotificationModel notification) async {
    final db = await database;
    return await db.insert('notifications', notification.toMap());
  }

  Future<int> markNotificationAsRead(int notificationId) async {
    final db = await database;
    return await db.update(
      'notifications',
      {'read': 1},
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  // Booking type operations
  Future<Map<String, dynamic>?> getBookingTypeById(int id) async {
    final db = await database;
    final maps = await db.query(
      'booking_types',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return maps.first;
  }

  // Booking operations
  Future<int> insertBooking(BookingModel booking) async {
    final db = await database;
    return await db.insert('bookings', booking.toMap());
  }

  Future<List<BookingModel>> getBookingsByUserId(int userId) async {
    final db = await database;
    final maps = await db.query(
      'bookings',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return maps.map((map) => BookingModel.fromMap(map)).toList();
  }

  // Request document operations
  Future<int> insertRequestDocument(RequestDocumentModel doc) async {
    final db = await database;
    return await db.insert('request_documents', doc.toMap());
  }

  Future<List<RequestDocumentModel>> getDocumentsByRequestId(int requestId) async {
    final db = await database;
    final maps = await db.query(
      'request_documents',
      where: 'request_id = ?',
      whereArgs: [requestId],
    );
    return maps.map((map) => RequestDocumentModel.fromMap(map)).toList();
  }

  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
