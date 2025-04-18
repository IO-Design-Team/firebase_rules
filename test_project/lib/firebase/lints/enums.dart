// This is a test
// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';
import 'package:meta/meta.dart';

bool test(TestClass obj) {
  // expect_lint: undeclared_enum_value
  final a = TestEnum.a;
  // expect_lint: undeclared_enum_value
  final b = TestEnum.b;
  // expect_lint: undeclared_enum_value
  final c = TestEnum.c;
  obj.test;
  return true;
}

@FirebaseRules(
  service: Service.firestore,
  functions: [test],
)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot),
];

enum TestEnum {
  a,
  b,
  c;

  static const map = {
    // expect_lint: undeclared_enum_value
    TestEnum.a: 'a',
    // expect_lint: undeclared_enum_value
    TestEnum.b: 'b',
    // expect_lint: undeclared_enum_value
    TestEnum.c: 'c',
  };
}

@immutable
class TestClass {
  final TestEnum test;

  const TestClass(this.test);
}
