import 'dart:io';
import 'storage_service.dart';

class MockStorageService implements StorageService {
  @override
  Future<String> uploadFile(File file, String remotePath) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Return a real working PDF link for testing purposes
    // In a real app, this would be the Firebase/Cloud storage URL
    return 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
  }

  @override
  Future<void> deleteFile(String path) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock implementation - in real app this would delete from Firebase Storage
    // For testing, we just simulate the operation without actual deletion
  }
}
