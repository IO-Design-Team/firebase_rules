// This is a test
// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test() {
  // expect_lint: avoid_raw_rules
  final a = rules.raw("foo.bar.baz == 'qux'");
  // expect_lint: avoid_raw_rules
  final b = rules.raw('foo.bar.baz == 123');
  // Make sure raws are completely ignored during sanitization
  // expect_lint: avoid_raw_rules
  final c = rules.raw("foo.bar.rules == 'asdf'");
  // Make sure types are stripped
  // expect_lint: avoid_raw_rules
  final d = rules.raw<RulesString>('foo.bar.baz');
  return true;
}

@FirebaseRules(
  service: Service.firestore,
  functions: [test],
)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot),
];
