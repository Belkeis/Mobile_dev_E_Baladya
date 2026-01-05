import 'dart:io';

abstract class StorageService {
  /// Uploads a file and returns the download URL.
  Future<String> uploadFile(File file, String remotePath);
}
