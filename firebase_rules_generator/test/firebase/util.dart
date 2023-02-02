import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:firebase_rules_generator/firebase_rules_generator.dart';
import 'package:test/test.dart';

void testFirebaseRulesBuilder(String name, {dynamic skip}) {
  test(
    'firebase/$name',
    () async {
      final input = File('../test_project/lib/firebase/$name/input.dart')
          .readAsStringSync();
      final output = File('../test_project/lib/firebase/$name/output.rules')
          .readAsStringSync();
      await testBuilder(
        firebaseRules(BuilderOptions.empty),
        {'test|test.dart': input},
        reader: await PackageAssetReader.currentIsolate(),
        outputs: {'test|test.rules': output},
      );
    },
    skip: skip,
  );
}
