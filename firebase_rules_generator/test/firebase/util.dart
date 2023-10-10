import 'package:build/build.dart';
import 'package:firebase_rules_generator/firebase_rules_generator.dart';

import '../common/util.dart';

void testFirebaseRulesBuilder(
  String name, {
  bool expectThrows = false,
  dynamic skip,
}) {
  testRulesBuilder(
    'firebase/$name',
    builder: firebaseRules(BuilderOptions.empty),
    expectThrows: expectThrows,
    skip: skip,
  );
}
