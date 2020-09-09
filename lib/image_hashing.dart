import 'dart:async';

import 'package:image_hashing/file_util.dart';
import 'package:process_run/process_run.dart';
import 'package:universal_io/io.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:path/path.dart' as p;

/// An image hash calculation tool base on [blockhash](https://github.com/commonsmachinery/blockhash-js)
class ImageHashing {
  ImageHashing._privateConstructore();

  static ImageHashing shared = ImageHashing._privateConstructore();

  /// Setup the executable files before running, copy all files into an execute directory
  /// `imagemagick` in macOS is come from homebrew
  Future<void> config() async {
    if (UniversalPlatform.isMacOS) {
      // install imagemagick if not available
      var info =
          (await run('brew', ['info', 'imagemagick'], verbose: true)).stdout;
      if (info.contains('No available') || info.contains('Not installed')) {
        await run('brew', ['install', 'imagemagick'], verbose: true);
      }

      // copy binary files into executeable dir
      final binaries = [
        'blockhash-macos',
        'blockhash',
      ];
      for (var binary in binaries) {
        await FileUtil.copyFile(
            'binaries/$binary', p.join(await _processDir, binary));
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
            'binaries/$binary', p.join(await _processDir, binary));
      }
    }
  }

  /// Process the image and return a unique hash not null
  Future<dynamic> process(String file) async {
    var fileExtension = p.extension(file).toLowerCase();
    if (['.png', '.jpg', '.svg', '.tiff']
        .contains(fileExtension.toLowerCase())) {
      if (fileExtension.toLowerCase() == '.svg') {
        // convert svg into jpg by imagemagick
        var magicKExeFile = UniversalPlatform.isMacOS
            ? 'magick' // from homebrew
            : p.join(await _processDir, 'magick.exe');
        var tempFile = p.join(await _processDir, '$_newFileName.jpg');
        await run(magicKExeFile, ['convert', file, tempFile], verbose: true);
        var exeFile = p.join(await _processDir,
            UniversalPlatform.isMacOS ? 'blockhash' : 'blockhash-win.exe');
        var result = (await run(exeFile, [tempFile], verbose: true)).stdout;
        // then delete this temp jpg
        await FileUtil.delete(tempFile);
        result = result.split(' ').first;
        print('[$file] has result $result');
        return result;
      } else {
        var exeFile = p.join(await _processDir,
            UniversalPlatform.isMacOS ? 'blockhash' : 'blockhash-win.exe');
        var result = (await run(exeFile, [file], verbose: true)).stdout;
        result = result.split(' ').first;
        print('[$file] has result $result');
        return result;
      }
    } else {
      throw UnsupportedError('file type $fileExtension is not supported');
    }
  }

  /// Create new file name from current file path
  String get _newFileName {
    var now = DateTime.now();
    return '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}';
  }

  /// Get working directory
  static Future<String> get _processDir async {
    final dir = Directory('image_hashing');
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }

    return dir.path;
  }
}
