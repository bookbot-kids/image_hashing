import 'dart:async';

import 'package:image_hashing/file_util.dart';
import 'package:process_run/process_run.dart';
import 'package:universal_io/io.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:path/path.dart' as p;

class ImageHashing {
  ImageHashing._privateConstructore();
  static ImageHashing shared = ImageHashing._privateConstructore();

  /// Get working directory
  static Future<String> get processDir async {
    final dir = Directory('image_hashing');
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }

    return dir.path;
  }

  /// Setup the executable files before running, copy all files into an execute directory
  /// `imagemagick` in macOS is come from homebrew
  Future<void> config() async {
    if (UniversalPlatform.isMacOS) {
      // install imagemagick
      //await run('brew', ['install', 'imagemagick'], verbose: true);

      // copy binary files into executeable dir
      final binaries = [
        'blockhash-macos',
      ];
      for (var binary in binaries) {
        await FileUtil.copyFile(
            'binaries/$binary', p.join(await processDir, binary));
      }
    } else if (UniversalPlatform.isWindows) {
      // copy execute into current dir

      // copy binary files into executeable dir
      final binaries = [
        'blockhash-win.exe',
        'magick.exe',
      ];
      for (var binary in binaries) {
        await FileUtil.copyFile(
            'binaries/$binary', p.join(await processDir, binary));
      }
    }
  }

  Future<dynamic> process(String file) async {
    var fileExtension = p.extension(file).toLowerCase();
    if (['.png', '.jpg', '.svg'].contains(fileExtension.toLowerCase())) {
      if (fileExtension.toLowerCase() == '.svg') {
        // convert svg into jpg
        var magicKExeFile = UniversalPlatform.isMacOS
            ? 'magick' // from homebrew
            : p.join(await processDir, 'magick.exe');
        var tempFile = p.join(await processDir, '$_newFileName.jpg');
        await run(magicKExeFile, ['convert', file, tempFile], verbose: true);
        var exeFile = p.join(
            await processDir,
            UniversalPlatform.isMacOS
                ? 'blockhash-macos'
                : 'blockhash-win.exe');
        var result = (await run(exeFile, [tempFile], verbose: true)).stdout;
        await FileUtil.delete(tempFile);
        return result;
      } else {
        var exeFile = p.join(
            await processDir,
            UniversalPlatform.isMacOS
                ? 'blockhash-macos'
                : 'blockhash-win.exe');
        var result = (await run(exeFile, [file], verbose: true)).stdout;
        return result;
      }
    }
  }

  /// Create new file name from current file path
  String get _newFileName {
    var now = DateTime.now();
    return '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}';
  }
}
