// This is a test
// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test() {
  final a = Test.a;
  final b = Test.b;
  final c = Test.c;
  return true;
}

@FirebaseRules(
  service: Service.firestore,
  functions: [test],
  enums: [Test.map],
)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot),
];

enum Test {
  a,
  b,
  c;

  static const map = {
    Test.a: 'a',
    Test.b: 'b',
    Test.c: 'c',
  };
}
