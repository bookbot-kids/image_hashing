import 'package:flutter/services.dart';
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

  /// Copy file from asset, ignore if exist
  static Future<void> copyAssetFile(String asssetPath, String to) async {
    var destFile = File(to);
    if (await destFile.exists()) {
      return;
    }

    final data = await rootBundle.load(asssetPath);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await destFile.writeAsBytes(bytes);
  }
}
