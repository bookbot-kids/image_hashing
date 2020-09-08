import 'package:universal_io/io.dart';

class FileUtil {
  /// Copy file, ignore if exist
  static Future<void> copyFile(String from, String to) async {
    if (await File(to).exists()) {
      return;
    }

    var file = File(from);
    await file.copy(to);
  }

  /// Delete a file
  static Future<void> delete(String path) async {
    if (await File(path).exists()) {
      await File(path).delete();
    }
  }
}
