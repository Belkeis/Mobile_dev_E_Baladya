import 'package:file_picker/file_picker.dart';

class FilePickerHelper {
  /// Picks a single document (PDF or Image) from the device.
  static Future<PlatformFile?> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files.first;
    }
    return null;
  }

  /// Picks multiple documents from the device.
  static Future<List<PlatformFile>> pickMultipleDocuments() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      allowMultiple: true,
    );

    if (result != null) {
      return result.files;
    }
    return [];
  }
}
