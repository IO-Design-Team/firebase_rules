// This is a test
// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test(RulesPath other) {
  final a = rules.path('/path/to/resource'.rules());
  return true;
}

@FirebaseRules(
  service: Service.storage,
  functions: [test],
)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot),
];
