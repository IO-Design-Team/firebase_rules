// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';

bool test() {
  final a = rules.raw("foo.bar.baz == 'qux'");
  final b = rules.raw('foo.bar.baz == 123');
  // Make sure raws are completely ignored during sanitization
  final c = rules.raw("foo.bar.rules == 'asdf'");
  return true;
}

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(firestoreRoot, functions: [test]),
];
