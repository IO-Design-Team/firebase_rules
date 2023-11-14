// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

// expect_lint: undeclared_function
bool test() {
  final a = Test.a;
  final b = Test.b;
  final c = Test.c;
  return true;
}

@FirebaseRules(
  service: Service.firestore,
  enums: [Test.map],
)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    rules: (database, request, resource) => [
      Allow([Operation.read], test()),
    ],
  ),
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
