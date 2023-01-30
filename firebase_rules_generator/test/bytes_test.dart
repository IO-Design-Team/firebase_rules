import 'dart:io';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:firebase_rules_generator/firebase_rules_generator.dart';
import 'package:test/test.dart';

void main() {
  test('bytes', () async {
    final input = File('test_resources/bytes/input.dart').readAsStringSync();
    final output = File('test_resources/bytes/output.rules').readAsStringSync();
    await testBuilder(
      rules(BuilderOptions.empty),
      {'a|test.dart': input},
      outputs: {'a|test.rules': output},
    );
  });
}
