// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';
import 'package:test_project/firebase/split/input2.dart';

@FirebaseRules(
  service: Service.firestore,
  functions: [isNotAnonymous],
)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    rules: detachedRules,
    matches: detachedMatches,
  ),
];
