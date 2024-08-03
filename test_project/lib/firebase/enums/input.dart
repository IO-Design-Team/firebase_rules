// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test(TestClass obj) {
  final a = TestEnum.a;
  final b = TestEnum.b;
  final c = TestEnum.c;
  final d = obj.test;
  return true;
}

@FirebaseRules(
  service: Service.firestore,
  functions: [test],
  enums: [TestEnum.map],
)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot),
];

enum TestEnum {
  a,
  b,
  c;

  static const map = {
    TestEnum.a: 'a',
    TestEnum.b: 'b',
    TestEnum.c: 'c',
  };
}

class TestClass {
  final TestEnum test;

  TestClass(this.test);
}
