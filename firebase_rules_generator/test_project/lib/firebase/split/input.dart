// ignore_for_file: unused_local_variable

import 'package:firebase_rules/firebase.dart';
import 'package:firebase_rules_test/firebase/split/input2.dart';

@FirebaseRules(service: Service.firestore)
final firestoreRules = [
  Match<FirestoreRoot, FirestoreResource>(
    functions: [isNotAnonymous],
    rules: detachedRules,
    matches: detachedMatches,
  ),
];
