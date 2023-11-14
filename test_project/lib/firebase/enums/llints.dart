// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test() {
  // expect_lint: undeclared_enum
  final a = Test.a;
  // expect_lint: undeclared_enum
  final b = Test.b;
  // expect_lint: undeclared_enum
  final c = Test.c;
  return true;
}

@FirebaseRules(
  service: Service.firestore,
  functions: [test],
)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot),
];

enum Test {
  a,
  b,
  c;

  static const map = {
    // expect_lint: undeclared_enum
    Test.a: 'a',
    // expect_lint: undeclared_enum
    Test.b: 'b',
    // expect_lint: undeclared_enum
    Test.c: 'c',
  };
}
