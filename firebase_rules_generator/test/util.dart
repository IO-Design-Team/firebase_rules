import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:firebase_rules_generator/firebase_rules_generator.dart';
import 'package:test/test.dart';

void testRulesBuilder(String name) {
  test(name, () async {
    final input = File('test_project/lib/$name/input.dart').readAsStringSync();
    final output =
        File('test_project/lib/$name/output.rules').readAsStringSync();
    await testBuilder(
      rules(BuilderOptions.empty),
      {'test|test.dart': input},
      reader: await PackageAssetReader.currentIsolate(),
      outputs: {'test|test.rules': output},
    );
  });
}
