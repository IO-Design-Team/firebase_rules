// This is a test
// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test(RulesPath other) {
  final a = rules.path('/path/to/resource'.rules());
  final b = other['fieldname'];
  final c = other[0];
  final d = other.bind({'foo': 'something', 'bar': 'another'}.rules());
  final e = rules.path('/path/to/resource'.rules(), database: 'default');
  final f = rules
      .path('/path/to/resource'.rules())
      .bind({'foo': 'something', 'bar': 'another'}.rules());
  return true;
}

@FirebaseRules(
  service: Service.firestore,
  functions: [test],
)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot),
];
