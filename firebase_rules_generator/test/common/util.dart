import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

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
      final future = testBuilder(
        builder,
        {'test|test.dart': input},
        reader: await PackageAssetReader.currentIsolate(),
        outputs: expectThrows
            ? null
            : {'test|test$outputExtension': outputFile.readAsStringSync()},
      );

      if (expectThrows) {
        await expectLater(
          () async => await future,
          throwsA(isA<InvalidGenerationSourceError>()),
        );
      } else {
        await future;
      }
    },
    skip: skip,
  );
}
