// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';
import 'package:test_project/firebase/split/input2.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreResource>(
    firestoreRoot,
    functions: [isNotAnonymous],
    rules: detachedRules,
    matches: detachedMatches,
  ),
];
