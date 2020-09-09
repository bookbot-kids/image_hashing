import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_hashing/image_hashing.dart';
import 'package:universal_io/io.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // expose current dir for path_provider on test
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '.';
    });
    await ImageHashing.shared.config();
  });

  tearDown(() {});

  test('test image folder', () async {
    var folderPath = "Test folder";
    var dir = Directory(folderPath);
    var files = dir.listSync();
    for (var file in files) {
      var result = await ImageHashing.shared.process(file.path);
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
