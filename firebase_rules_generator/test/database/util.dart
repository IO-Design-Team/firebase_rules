import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:firebase_rules_generator/firebase_rules_generator.dart';
import 'package:test/test.dart';

void testDatabaseRulesBuilder(String name) {
  test('database/$name', () async {
    final input =
        File('test_project/lib/database/$name/input.dart').readAsStringSync();
    final output = File('test_project/lib/database/$name/output.rules.json')
        .readAsStringSync();
    await testBuilder(
      databaseRules(BuilderOptions.empty),
      {'test|test.dart': input},
      reader: await PackageAssetReader.currentIsolate(),
      outputs: {'test|test.rules.json': output},
    );
  });
}
