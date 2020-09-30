import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_hashing/image_hashing.dart';
import 'package:universal_io/io.dart';
import 'package:path/path.dart' as p;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // expose current dir for path_provider on test
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '.';
    });
    await ImageHashing.shared.init('');
  });

  tearDown(() {});

  test('test image folder', () async {
    var folderPath = "Test folder";
    var dir = Directory(folderPath);
    var outputDir = Directory(p.join(folderPath, 'output'));
    await outputDir.create();
    var files = dir.listSync();
    for (var file in files) {
      if (!File(file.path).existsSync() || file.path.contains('.DS_Store')) {
        continue;
      }

      var result = await ImageHashing.shared.process(file.path);
      var fileName = p.basename(file.path);
      var txtFile = p.join(outputDir.path, fileName + '.txt');
      await File(txtFile).writeAsString(result);
      assert(result is String);
      assert(result.isNotEmpty);
    }
  });

  test('test png', () async {
    var result = await ImageHashing.shared.process('test.png');
    assert(result is String);
    assert(result.isNotEmpty);
  });

  test('test jpg', () async {
    var result = await ImageHashing.shared.process('test.jpg');
    assert(result is String);
    assert(result.isNotEmpty);
  });

  test('test svg', () async {
    var result = await ImageHashing.shared.process('test.svg');
    assert(result is String);
    assert(result.isNotEmpty);
  });
}
