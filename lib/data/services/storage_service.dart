import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Service to handle file storage operations using Firebase Storage
class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage}) 
      : _storage = storage ?? FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage and returns the download URL
  /// 
  /// [file] The file to upload
  /// [path] The storage path (e.g., 'documents/userId/filename.pdf')
  Future<String> uploadFile(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw StorageException('Failed to upload file: ${e.toString()}');
    }
  }

  /// Deletes a file from Firebase Storage
  /// 
  /// [path] The storage path of the file to delete
  Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      throw StorageException('Failed to delete file: ${e.toString()}');
    }
  }
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => message;
}
