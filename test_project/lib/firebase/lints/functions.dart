// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

// expect_lint: undeclared_function
bool test() {
  final a = Test.a;
  final b = Test.b;
  final c = Test.c;
  return true;
}

// expect_lint: invalid_rules_function
void test2() {}

// expect_lint: invalid_rules_function
bool test3({required String named}) {
  return true;
}

// expect_lint: invalid_rules_function
bool test4() => true;

@FirebaseRules(
  service: Service.firestore,
  enums: [Test.map],
  functions: [test2, test3, test4],
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
