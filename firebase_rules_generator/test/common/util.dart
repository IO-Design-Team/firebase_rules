import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void testRulesBuilder(
  String slug, {
  required Builder builder,
  required String outputExtension,
  dynamic skip,
  bool expectThrows = false,
}) {
  test(
    slug,
    () async {
      final input =
          File(path.join('..', 'test_project', 'lib', slug, 'input.dart'))
              .readAsStringSync();
      final outputFile = File(
        path.join('..', 'test_project', 'lib', slug, 'output$outputExtension'),
      );
      final readerWriter = TestReaderWriter(rootPackage: 'test');
      await readerWriter.testing.loadIsolateSources();
      final result = await testBuilder(
        builder,
        {'test|test.dart': input},
        outputs: expectThrows
            ? null
            : {'test|test$outputExtension': outputFile.readAsStringSync()},
        readerWriter: readerWriter,
      );

      if (expectThrows) {
        expect(result.succeeded, isFalse);
      }
    },
    skip: skip,
  );
}
