import 'package:build/build.dart';
import 'package:firebase_rules_generator/firebase_rules_generator.dart';

import '../common/util.dart';

void testDatabaseRulesBuilder(
  String name, {
  bool expectThrows = false,
  dynamic skip,
}) {
  testRulesBuilder(
    'database/$name',
    builder: databaseRules(BuilderOptions.empty),
    expectThrows: expectThrows,
    skip: skip,
  );
}
